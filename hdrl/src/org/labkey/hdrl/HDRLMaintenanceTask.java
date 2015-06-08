/*
 * Copyright (c) 2015 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.labkey.hdrl;

import org.apache.log4j.Logger;
import org.labkey.api.data.DbSchema;
import org.labkey.api.data.DbScope;
import org.labkey.api.data.SQLFragment;
import org.labkey.api.data.SqlExecutor;
import org.labkey.api.util.SystemMaintenance;
import org.labkey.hdrl.query.HDRLQuerySchema;

import java.util.Calendar;

/**
 * Created by: jeckels
 * Date: 5/10/15
 */
public class HDRLMaintenanceTask implements SystemMaintenance.MaintenanceTask
{
    private static final Logger LOG = Logger.getLogger(HDRLMaintenanceTask.class);


    @Override
    public String getDescription()
    {
        return "HDRL Request Portal PHI Deletion";
    }

    @Override
    public String getName()
    {
        return "HdrlPhiDeletion";
    }

    @Override
    public boolean canDisable()
    {
        return true;
    }

    @Override
    public boolean hideFromAdminPage()
    {
        return false;
    }

    @Override
    public void run()
    {
        // Get this from the configurable setting
        int retentionDays = HDRLManager.getNumberOfDays();
        final String requestStatusStatement = HDRLQuerySchema.COL_REQUEST_STATUS_ID + " = " + "(SELECT rowid FROM hdrl.requeststatus WHERE name = ?)";
        final String submittedCondition1 = " WHERE (" + HDRLSchema.getInstance().getSchema().getSqlDialect().getDateDiff(Calendar.DATE, "NOW()", "i.Modified") + " >= ?";
        final String submittedCondition2 = " AND i." + requestStatusStatement + ")";

        DbSchema hdrl = HDRLSchema.getInstance().getSchema();
        try (DbScope.Transaction transaction = hdrl.getScope().ensureTransaction())
        {
            // Depending on strategy for remembering the number of specimens in the request, might need to stash the value
            // here, prior to deleting the specimen rows

            //set ArchivedRequestCount in InboundRequest table
            SQLFragment addToArchivedRequestCountColSQL = new SQLFragment("UPDATE ");
            addToArchivedRequestCountColSQL.append(HDRLSchema.getInstance().getTableInfoInboundRequest(), "i");
            addToArchivedRequestCountColSQL.append(" SET " + HDRLQuerySchema.COL_ARCHIVED_REQUEST_COUNT + " = (SELECT COUNT(*) FROM ");
            addToArchivedRequestCountColSQL.append(HDRLSchema.getInstance().getTableInfoInboundSpecimen());
            addToArchivedRequestCountColSQL.append(" WHERE " + HDRLQuerySchema.COL_INBOUND_REQUEST_ID + " = RequestId)");
            addToArchivedRequestCountColSQL.append(submittedCondition1);
            addToArchivedRequestCountColSQL.add(retentionDays);
            addToArchivedRequestCountColSQL.append(submittedCondition2);
            addToArchivedRequestCountColSQL.add(HDRLQuerySchema.STATUS_SUBMITTED);

            LOG.info("Adding specimen count to column '" + HDRLQuerySchema.COL_ARCHIVED_REQUEST_COUNT + "' in table " + HDRLSchema.getInstance().getTableInfoInboundRequest().getName());

            int numRequests = new SqlExecutor(HDRLSchema.getInstance().getScope()).execute(addToArchivedRequestCountColSQL);

            LOG.info("Finished adding specimen count to column '" + HDRLQuerySchema.COL_ARCHIVED_REQUEST_COUNT + "' in table "
                    + HDRLSchema.getInstance().getTableInfoInboundRequest().getName()
                    +". Added specimen counts to " + numRequests +" rows.");

            // Delete based on the completion date being at least X days in the past
            SQLFragment specimenDeleteSQL = new SQLFragment("DELETE FROM ");
            specimenDeleteSQL.append(HDRLSchema.getInstance().getTableInfoInboundSpecimen());
            specimenDeleteSQL.append(" WHERE " + HDRLQuerySchema.COL_INBOUND_REQUEST_ID + " IN (SELECT RequestId FROM ");
            specimenDeleteSQL.append(HDRLSchema.getInstance().getTableInfoInboundRequest(), "i");
            specimenDeleteSQL.append(submittedCondition1);
            specimenDeleteSQL.add(retentionDays);
            specimenDeleteSQL.append(submittedCondition2 + ")");
            specimenDeleteSQL.add(HDRLQuerySchema.STATUS_SUBMITTED);

            LOG.info("Starting to delete HDRL specimen data");

            int rowCount = new SqlExecutor(HDRLSchema.getInstance().getScope()).execute(specimenDeleteSQL);

            LOG.info("Deleted " + rowCount + " row(s) of HDRL specimen data");

            //Modify Request Status to 'Archived' from 'Submitted' in InboundRequest table
            SQLFragment requestStatusSQL = new SQLFragment("UPDATE ");
            requestStatusSQL.append(HDRLSchema.getInstance().getTableInfoInboundRequest(), "s");
            requestStatusSQL.append(" SET " + requestStatusStatement);
            requestStatusSQL.add("Archived");
            requestStatusSQL.append(" WHERE s." + requestStatusStatement);
            requestStatusSQL.add(HDRLQuerySchema.STATUS_SUBMITTED);

            LOG.info("Modifying Request Status to 'Archived'");

            int numRequestsStatuses = new SqlExecutor(HDRLSchema.getInstance().getScope()).execute(requestStatusSQL);

            LOG.info("Modified " + numRequestsStatuses + " request statuses to 'Archived'");

            transaction.commit();
        }
        // Also delete from specimen results when we're mapping them back from LabWare
    }
}
