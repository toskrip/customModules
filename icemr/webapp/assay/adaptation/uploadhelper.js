/**
 * Created with IntelliJ IDEA.
 * User: Dax
 * Date: 1/10/13
 * Time: 10:14 AM
 * To change this template use File | Settings | File Templates.
 */
LABKEY.requiresScript('clientapi/ext4/Util.js');
LABKEY.requiresScript('assay/schemahelper.js');
Ext.namespace("LABKEY.icemr");

/**
 * These functions manage the upload of Day 0 and daily data to LabKey Server
 */
function createExperiment()
{
    return createRecord(LABKEY.icemr.runConfigs);
}

function createFlask()
{
    return createRecord(LABKEY.icemr.flaskConfigs);
}

function createRecord(fieldConfigs)
{
    var record = {};
    for (var i = 0; i < fieldConfigs.length; i++)
    {
        record[fieldConfigs[i].name] = null;
    }

    return record;
}

/**
 * These functions are used for saving data
 */

function saveDaily(experiment, flasks)
{
    //
    // obviously undone
    //
    return;
}

function saveDay0(experiment, flasks, success, failure)
{
    if (!experiment)
        throw "You must provide an experiment object";

    if (!flasks)
        throw "You must provide an array of flasks";

    if (!success)
        throw "You must provide a Success callback function";

    // save off client callbacks
    LABKEY.icemr.saveDay0Success = success;
    LABKEY.icemr.saveDay0Failure = failure;

    //
    // start upload -> upload flask, then upload runs as part of a batch
    // with each flask as a material input
    //
    uploadFlasks(experiment, flasks);
}

function uploadFlasks(experiment, flasks)
{
    //
    // save experiment for context
    //
    LABKEY.icemr.experiment = experiment;

    LABKEY.Query.insertRows( {
        schemaName : 'Samples',
        queryName : LABKEY.icemr.adaptation.flaskSampleSet,
        rows : flasks,
        success : onUploadFlasksSuccess
    });
}

//
//  Once flasks are uploaded then establish them as material inputs
//  to the run
//
function onUploadFlasksSuccess(result)
{
    //
    // establish materials as inputs to the run and upload
    //
    var materialInputs = [];
    for (var i = 0; i < result.rows.length; i++)
    {
        //
        // create a material from the flask we just inserted
        //
        materialInputs.push({
            id : result.rows[i]['rowid'],
            role : "Flask " + (i+1)
        });
    }

    var run = new LABKEY.Exp.Run();
    run.materialInputs = materialInputs;
    run.name = LABKEY.icemr.experiment[LABKEY.icemr.adaptation.patient];
    run.properties = LABKEY.icemr.experiment;

    LABKEY.page.batch.runs = [];
    LABKEY.page.batch.runs.push(run);
    LABKEY.setDirty(true);

    //
    // UNDONE: need to use the role here
    //
    LABKEY.Experiment.saveBatch({
        assayId : LABKEY.page.assay.id,
        batch : LABKEY.page.batch,
        successCallback : LABKEY.icemr.saveDay0Success,
        failureCallback : LABKEY.icemr.saveDay0Failure
    });
}

/**
 * These functions are used for retrieving metadata
 */
function getDay0Configs(successCallback)
{
    LABKEY.icemr.getDay0Success = successCallback;
    //
    // Day 0 configs consist of the run properties for the adaptation
    // assay design as well as the flask metadata for the sample set
    // We also fetch the Flasks Sample Set ID and store it away for later use
    // before returning to the caller
    //
    getAdaptationFieldConfigs(onAssayConfigsReady)
}

function onAssayConfigsReady(runConfigs, resultConfigs)
{
    LABKEY.icemr.runConfigs = runConfigs;
    //
    // now get flask data
    //
    var flasks = new LABKEY.Exp.SampleSet({name: LABKEY.icemr.adaptation.flaskSampleSet});
    flasks.getDomain({ success : onFlasksDomainReady, failure : onFlasksFailure });
}

function onFlasksDomainReady(domain)
{
    LABKEY.icemr.flaskConfigs = buildConfigs(domain.fields, LABKEY.icemr.metaType.SampleSet);
    LABKEY.icemr.getDay0Success(LABKEY.icemr.runConfigs, LABKEY.icemr.flaskConfigs);
}
function onFlasksFailure(data)
{
    Ext.Msg.hide();
    Ext.Msg.alert(LABKEY.icemr.errConfigTitle, LABKEY.icemr.errConfigMissingFlask);
}