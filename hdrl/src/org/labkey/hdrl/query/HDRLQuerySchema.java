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

package org.labkey.hdrl.query;

import org.jetbrains.annotations.Nullable;
import org.labkey.api.data.Container;
import org.labkey.api.data.ContainerManager;
import org.labkey.api.data.DbSchema;
import org.labkey.api.data.DisplayColumn;
import org.labkey.api.data.RenderContext;
import org.labkey.api.data.SchemaTableInfo;
import org.labkey.api.data.SimpleDisplayColumn;
import org.labkey.api.data.SimpleFilter;
import org.labkey.api.data.TableInfo;
import org.labkey.api.data.TableSelector;
import org.labkey.api.data.dialect.SqlDialect;
import org.labkey.api.module.Module;
import org.labkey.api.query.DefaultSchema;
import org.labkey.api.query.FieldKey;
import org.labkey.api.query.FilteredTable;
import org.labkey.api.query.QuerySchema;
import org.labkey.api.query.QuerySettings;
import org.labkey.api.query.QueryView;
import org.labkey.api.query.SimpleUserSchema;
import org.labkey.api.security.User;
import org.labkey.api.security.permissions.AdminPermission;
import org.labkey.api.security.permissions.UpdatePermission;
import org.labkey.api.util.PageFlowUtil;
import org.labkey.api.view.ActionURL;
import org.labkey.api.view.ViewContext;
import org.labkey.hdrl.HDRLController;
import org.labkey.hdrl.HDRLModule;
import org.springframework.validation.BindException;

import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class HDRLQuerySchema extends SimpleUserSchema
{
    public static final String NAME = "hdrl";
    public static final String DESCRIPTION = "Provides information on test requests and specimen sets";

    public static final String TABLE_INBOUND_REQUEST = "InboundRequest";
    public static final String TABLE_SPECIMEN = "InboundSpecimen";
    public static final String TABLE_REQUEST_STATUS = "RequestStatus";
    public static final String TABLE_FAMILY_MEMBER_PREFIX = "FamilyMemberPrefix";
    public static final String TABLE_DUTY_CODE = "DutyCode";
    public static final String TABLE_SOURCE_OF_TESTING = "SourceOfTesting";

    public static final String COL_REQUEST_STATUS_ID = "RequestStatusId";
    public static final String COL_INBOUND_REQUEST_ID = "InboundRequestId";
    public static final String COL_ARCHIVED_REQUEST_COUNT = "ArchivedRequestCount";

    public static final String STATUS_SUBMITTED = "Submitted";
    public static final String STATUS_ARCHIVED = "Archived";

    private Map<Integer, String> statusMap = null;

    public String getStatus(int s)
    {
        if(statusMap == null)
        {
            statusMap = new HashMap<Integer, String>();
            TableSelector selector = new TableSelector(org.labkey.hdrl.HDRLSchema.getInstance().getSchema().getTable(TABLE_REQUEST_STATUS), null, null);
            for (Map<String, Object> stringObjectMap : selector.getMapCollection())
            {
                Integer key = new Integer(-1);
                String value = "";
                for (String s1 : stringObjectMap.keySet())
                {
                    if(s1.equals("name"))
                        value = (String) stringObjectMap.get(s1);
                    else if(s1.equals("rowid"))
                        key = (Integer) stringObjectMap.get(s1);
                }
                statusMap.put(key, value);
            }
        }
        return statusMap.get((Integer)s);
    }

    public static void register(final HDRLModule module)
    {
        DefaultSchema.registerProvider(NAME, new DefaultSchema.SchemaProvider(module)
        {
            @Override
            public QuerySchema createSchema(DefaultSchema schema, Module module)
            {
                return new HDRLQuerySchema(schema.getUser(), schema.getContainer());
            }
        });
    }

    public HDRLQuerySchema(User user, Container container)
    {
        super(NAME, DESCRIPTION, user, container, DbSchema.get(NAME));
    }

    public DbSchema getSchema()
    {
        return DbSchema.get(NAME);
    }

    public SqlDialect getSqlDialect()
    {
        return getSchema().getSqlDialect();
    }

    @Nullable
    @Override
    protected TableInfo createTable(String name)
    {
        if (TABLE_INBOUND_REQUEST.equalsIgnoreCase(name))
        {
            return new InboundRequestTable(this);
        }
        else if (TABLE_SPECIMEN.equalsIgnoreCase(name))
        {
            return new InboundSpecimenTable(this);
        }

        //just return a filtered table over the db table if it exists
        SchemaTableInfo tableInfo = getDbSchema().getTable(name);
        if (null == tableInfo)
            return null;

        FilteredTable filteredTable = new FilteredTable<>(tableInfo, this);
        filteredTable.wrapAllColumns(true);
        return filteredTable;
    }

    @Override
    public Set<String> getTableNames()
    {
        return new HashSet<>(getDbSchema().getTableNames());
    }

    @Override
    public QueryView createView(ViewContext context, QuerySettings settings, BindException errors)
    {
        if (settings.getQueryName().equalsIgnoreCase(TABLE_INBOUND_REQUEST))
        {
            return new QueryView(this, settings, errors)
            {
                @Override
                protected void addDetailsAndUpdateColumns(List<DisplayColumn> ret, TableInfo table)
                {

                    SimpleDisplayColumn actionColumn = new SimpleDisplayColumn()
                    {
                        @Override
                        public void renderGridCellContents(RenderContext ctx, Writer out) throws IOException
                        {
                            Container c = ContainerManager.getForId(ctx.get(FieldKey.fromParts("container")).toString());

                            int status = ((Integer) ctx.get(FieldKey.fromParts(COL_REQUEST_STATUS_ID)));

                            if ((STATUS_SUBMITTED.equals(getStatus(status)) && getContainer().hasPermission(getUser(), UpdatePermission.class)) || getContainer().hasPermission(getUser(), AdminPermission.class))
                            {
                                FieldKey requestFieldKey = FieldKey.fromParts("RequestId");
                                ActionURL actionUrl = new ActionURL(HDRLController.EditRequestAction.class, c).addParameter("requestId", (Integer)ctx.get(requestFieldKey));
                                out.write(PageFlowUtil.textLink("Edit", actionUrl));
                            }
                            else
                            {
                                if(!STATUS_ARCHIVED.equals(getStatus(status)))
                                {
                                    // FIXME would it be better to change the schema so the Specimen table uses "RequestId" instead of InboundRequestId?
                                    FieldKey requestFieldKey = FieldKey.fromParts(COL_INBOUND_REQUEST_ID);
                                    SimpleFilter filter = new SimpleFilter(requestFieldKey, ctx.get("requestId"));
                                    ActionURL actionUrl = new ActionURL(HDRLController.RequestDetailsAction.class, c);
                                    filter.applyToURL(actionUrl, DATAREGIONNAME_DEFAULT);
                                    out.write(PageFlowUtil.textLink("View", actionUrl));
                                }
                            }
                        }
                    };
                    ret.add(actionColumn);

                }
            };
        }
        else if (settings.getQueryName().equalsIgnoreCase(TABLE_SPECIMEN))
        {
            QueryView queryView = new QueryView(this, settings, errors);
            queryView.setShowDeleteButton(false);
            queryView.setShowUpdateColumn(false);
            queryView.setShowInsertNewButton(false);
            queryView.setShowImportDataButton(false);
            return queryView;
        }
        return super.createView(context, settings, errors);

    }
}
