/*
 * Copyright (c) 2011-2019 LabKey Corporation
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

package org.labkey.viscstudies;

import org.jetbrains.annotations.NotNull;
import org.labkey.api.module.CodeOnlyModule;
import org.labkey.api.module.FolderTypeManager;
import org.labkey.api.module.Module;
import org.labkey.api.module.ModuleContext;
import org.labkey.api.query.DefaultSchema;
import org.labkey.api.query.QuerySchema;
import org.labkey.api.view.WebPartFactory;

import java.util.Collection;
import java.util.Collections;

public class ViscStudiesModule extends CodeOnlyModule
{
    @Override
    public String getName()
    {
        return "ViscStudies";
    }

    @Override
    @NotNull
    protected Collection<WebPartFactory> createWebPartFactories()
    {
        return Collections.emptyList();
    }

    @Override
    protected void init()
    {
        addController("viscstudies", ViscStudiesController.class);

        DefaultSchema.registerProvider(ViscStudySchema.NAME, new DefaultSchema.SchemaProvider(this)
        {
            @Override
            public QuerySchema createSchema(DefaultSchema schema, Module module)
            {
                return new ViscStudySchema(schema.getUser(), schema.getContainer());
            }
        });
    }

    @Override
    public void doStartup(ModuleContext moduleContext)
    {
        FolderTypeManager.get().registerFolderType(this, new ViscStudyFolderType(this));
    }
}
