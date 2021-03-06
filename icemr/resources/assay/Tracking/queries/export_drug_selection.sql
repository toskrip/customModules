/*
 * Copyright (c) 2013-2019 LabKey Corporation
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
SELECT RowId, PatientID As ParticipantID, ExperimentID, SampleID, MeasurementDate As Date, Scientist, Parasitemia,
Gametocytemia, Stage, Removed, RBCBatchID, SerumBatchID, AlbumaxBatchID, GrowthFoldTestInitiated,
GrowthFoldTestFinished, Contamination, MycoTestResult, FreezerProIDs, FlaskMaintenanceStopped, InterestingResult,
Comments, StartDate,
f.*,
abs(timestampdiff('SQL_TSI_DAY', MeasurementDate, StartDate)) As DateIndex
FROM tracking_results r INNER JOIN alias_select_flasks f ON r.SampleID = f.FlaskSampleID