/*
 * Copyright (c) 2018-2019 LabKey Corporation
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

/* hdrl-0.00-15.30.sql */

-- Note: Despite the version number, this script was actually added early in the 15.20 cycle.
CREATE SCHEMA hdrl;

CREATE TABLE hdrl.RequestStatus
(
    RowId SERIAL NOT NULL,
    Name VARCHAR(32) NOT NULL,
    Description VARCHAR(128),

    CONSTRAINT PK_RequestStatus PRIMARY KEY (RowId),
    CONSTRAINT UQ_RequestStatus UNIQUE (Name)
);

INSERT INTO hdrl.RequestStatus VALUES (DEFAULT, 'Pending', 'Not yet submitted');
INSERT INTO hdrl.RequestStatus VALUES (DEFAULT, 'Submitted', 'User has submitted the request but no other progress has occurred');
INSERT INTO hdrl.RequestStatus VALUES (DEFAULT, 'Received', 'All specimens in the request were successfully received by the lab and are being processed');
INSERT INTO hdrl.RequestStatus VALUES (DEFAULT, 'Completed', 'All specimens in the request have been tested, results are available');
INSERT INTO hdrl.RequestStatus VALUES (DEFAULT, 'Exception', 'There was some issue with one or more of the specimens in the lab');
INSERT INTO hdrl.RequestStatus VALUES (DEFAULT, 'Archived', 'There was some issue with one or more of the specimens in the lab');

CREATE TABLE hdrl.TestType
(
    RowId SERIAL NOT NULL,
    Name VARCHAR(128) NOT NULL,

    CONSTRAINT PK_TestType PRIMARY KEY (RowId),
    CONSTRAINT UQ_TestType UNIQUE (Name)
);

INSERT INTO hdrl.TestType VALUES(DEFAULT, 'HIV Screening Algorithm');

CREATE TABLE hdrl.FamilyMemberPrefix
(
    RowId SERIAL NOT NULL,
    Code CHAR(2) NOT NULL,
    Description VARCHAR(128),

    CONSTRAINT PK_FamilyMemberPrefix PRIMARY KEY (RowId),
    CONSTRAINT UQ_FamilyMemberPrefix UNIQUE (Code)
);

INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '00', 'No FMP Number (MEPS)');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '01', 'Oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '02', '2nd oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '03', '3rd oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '04', '4th oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '05', '5th oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '06', '6th oldest child'); 
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '07', '7th oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '08', '8th oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '09', '9th oldest child');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '20', 'Sponsor');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '30', 'Sponsor''s current spouse'); 
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '31', 'Sponsor''s Eligible Former Spouse(s)'); 
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '32', 'Sponsor''s Eligible Former Spouse(s)'); 
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '33', 'Sponsor''s Eligible Former Spouse(s)');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '40', 'Sponsor''s Dependent Mother or Stepmother');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '45', 'Sponsor''s Dependent Father or Stepfather');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '50', 'Sponsor''s Dependent Mother-in-law');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '55', 'Sponsor''s Dependent Father-in-law');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '60', 'Other Authorized Sponsor''s Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '61', 'Other Authorized Sponsor''s Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '62', 'Other Authorized Sponsor''s Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '63', 'Other Authorized Sponsor''s Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '64', 'Other Authorized Sponsor''s Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '65', 'Other Authorized Sponsor''s Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '90', 'Children of Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '91', 'Children of Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '92', 'Children of Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '93', 'Children of Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '94', 'Children of Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '95', 'Children of Dependents');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '98', 'Civilian, Indigent and Non-Indigent');
INSERT INTO hdrl.FamilyMemberPrefix VALUES(DEFAULT, '99', 'Other Qualified Beneficiaries');

CREATE TABLE hdrl.SourceOfTesting
(
    RowId SERIAL NOT NULL,
    Code CHARACTER(1) NOT NULL,
    Description VARCHAR(128),

    CONSTRAINT PK_SourceOfTesting PRIMARY KEY (RowId),
    CONSTRAINT UQ_SourceOfTesting UNIQUE (Code)
);

INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'A', 'Alcohol and Drug Rehabilitation');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'B', 'Blood Donor');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'C', 'Contact Referred HIV');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'D', 'Deceased (whether DOA or Dying in ER');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'F', 'Force Testing');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'H', 'Post-Deployment Serum');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'I', 'Indicated Clinically');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'J', 'Jail, Prisoners or Detained Persons');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'M', 'Medical Adimission (including Psychiatric)');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'N', 'Pre-deployment Serum');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'O', 'Obstetrics/Gynecology Test');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'P', 'Physical Examination');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'S', 'Surgical Admission (including invasive procedures and trauma patients in the ER)');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'V', 'Venereal Disease Clinic Visit/STD Clinic');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'W', 'Double ELISA Positive, Blood Bank Specimen');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'X', 'Other');
INSERT INTO hdrl.SourceOfTesting VALUES(DEFAULT, 'Z', 'Redrawn (Double ELISA Positive) Clinical Specimen');

CREATE TABLE hdrl.DutyCode
(
    RowId SERIAL NOT NULL,
    Code CHARACTER(3),
    Description VARCHAR(128),
    Service VARCHAR(128),
   
    CONSTRAINT PK_DutyCode PRIMARY KEY (RowId),
    CONSTRAINT UQ_DutyDoce UNIQUE (Code)
);

INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A12','ACDUTRA-A','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A13','RECRUITS-A','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A14','CADETS - ACADEMY','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A15','ACDU - NTL GUARD','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A22','INACDUTRA-RESERVE','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A21','RET-ACDUTRA/ROTC','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A00','DECEASED SPONSOR','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A11','ACDU-A','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A17','Unknown','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A16','Unknown','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A23','INACDUTRA-NTL GUARD','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A24','A24 - unknown - found in Viromed data but not defined in our paper copies','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A25','A25 - unknown - found in Viromed data but not defined in our paper copies','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A26','APPLICANT ENLIST','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A27','EX MIL MATERNITY','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A28','DEPT OF EX MILITARY','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A31','RET-A-LOS','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A32','RET-A-PDRL','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A33','RET-A-TDRL','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A41','DEP-ACDU-A','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A43','DEP-RET-A','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A45','DEP-ACDU-DEC','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B11','ACDU-NOAA','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A47','DEP-RET-DEC','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A48','UNREMARRIED FORMER SPOUSE','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'A49','FAM MBR OF A48','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B00','DECEASED SPONSOR','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B31','RET-NOAA-LOS','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B32','RET-NOAA-PDRL','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B33','RET-NOAA-TDRL','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B41','DEP-ACDU-NOAA','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B43','DEP-RET-NOAA','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B45','DEP-ACDU-DEC','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B47','DEP-RET-DEC','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B48','UNREMARRIED FORMER SPOUSE','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'B49','FAM MBR OF B48','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C00','DECEASED SPONSOR','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C13','RECRUITS-CG','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C12','ACDUTRA-CG','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C11','ACDU-CG','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C21','RET-ACDUTRA/ROTC','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C14','CADETS - ACADEMY','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C41','DEP-ACDU-CG','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C33','RET-CG-TDRL','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C22','INACDUTRA-RESERVE','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C32','RET-CG-PDRL','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C31','RET-CG-LOS','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C28','DEPT OF EX MILITARY','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C27','EX MIL MATERNITY','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C26','Applicant Enlist','NOAA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C45','DEP-ACDU-DEC','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C43','DEP-RET-CG','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F12','ACDUTRA-AF','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F13','RECRUITS-AF','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F14','CADETS-ACADEMY','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F00','DECEASED SPONSOR','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C48','UNREMARRIED FORMER SPOUSE','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C49','FAM MBR OF C48','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'C47','DEP-RET-DEC','USCG');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F11','ACDU-AF','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F15','ACDU-NTL GUARD','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F21','RET-ACDUTRA/ROTC','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F22','INACDUTRA-RESERVE','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F23','INACDUTRA-NTL GUARD','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F26','APPLICANT ENLIST','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F27','EX MIL MATERNITY','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F28','DEPT OF EX MILITARY','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F31','RET-AF-LOS','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F32','RET-AF-PDRL','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F33','RET-AF-TDRL','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F41','DEP-ACDU-AF','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F43','DEP-RET-AF','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F45','DEP-ACDU-DEC','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F47','DEP-RET-DEC','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F48','UNREMARRIED FORMER SPOUSE','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'F49','FAM MBR OF F48','USAF');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K51','Civilian Employee (OCONUS)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K52','Fam Mbr of K51','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K53','Civ Employee(Fed Other)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K54','Fam Mbr of K53','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K55','Civ Employee(DOD Remote)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K56','Fam Mbr of K55','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K57','Civ Employee(DOD Occ Hlth)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K58','Civ Employee(Disb Ret Exam)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K59','Civ Employee(Others)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K61','Civ Employee(VA)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K62','Office of Workers Comp','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K63','Service Home(not retired)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K64','Social Security','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K65','Contract Employee','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K66','Federal Prisoner','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K67','PHS Beneficiary(Amer Indians, Aleu, Eskimo)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K68','PHS Beneficiary(Micronesian, Samoan, Trust)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K69','Other US Beneficiary(Spon & Dep)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K71','NATO/Non-NATO(Foreign Military Sales)','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K72','NATO Active Duty','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K73','Dependent of K72','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K74','Non-NATO Active Duty','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K75','Dependent of K74','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K76','K76 - unknown - found in Viromed data but not defined in our paper copies','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K77','Dependent of Foreign Civilian','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K78','Foreign National POW','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K82','Secry Army Designee','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K83','Secry Navy Designee','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K84','Secry Air Force Designee','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K79','Other Foreign National','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K81','Secry Defense Designee','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K89','Childre of Dependent Daughter','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K91','Civil Humanitarian Care','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K92','Emergency Care','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M00','DECEASED SPONSOR','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'K99','Patient NOt Elsewhere Classified','OTHER_ELIGIBLES');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M31','RET-MC-LOS','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M28','DEPT OF EX MILITARY','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M27','EX MIL MATERNITY','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M26','APPLICANT ENLIST','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M22','INACDUTRA-RESERVE-MC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M13','RECRUITS-MC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M12','ACDUTRA-MC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M11','ACDU-MC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M33','RET-MC-TDRL','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M32','RET-MC-PDRL','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N00','DECEASED SPONSOR','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N11','ACDU-N','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M49','FAM MBR OF M48','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M48','UNREMARRIED FORMER SPOUSE','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M47','DEP-RET-DEC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M45','DEP-ACDU-DEC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M43','DEP-RET-MC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'M41','DEP-ACDU-MC','USMC');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N12','ACDUTRA-N','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N13','RECRUITS-N','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N14','CADETS - ACADEMY','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N21','RET-ACDUTRA/ROTC','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N22','INACDUTRA-RESERVE','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N26','APPLICANT ENLIST','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N27','EX MIL MATERNITY','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N28','DEPT OF EX MILITARY','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N31','RET-N-LOS','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N24','N24 - unknown - found in Viromed data but not defined in our paper copies','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N32','RET-N-PDRL','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N33','RET-N-TDRL','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P11','ACDU-PHS','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P00','DECEASED SPONSOR','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N41','DEP-ACDU-N','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N43','DEP-RET-N','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N45','DEP-ACDU-DEC','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N47','DEP-RET-DEC','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N48','UNREMARRIED FORMER SPOUSE','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'N49','FAM MBR OFN48','USN');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P12','ACDUTRA-PHS','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P22','INACDUTRA-RESERVE','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P31','RET-PHS-LOS','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P32','RET-PHS-PDRL','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P33','RET-PHS-TDRL','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P41','DEP-ACDU-PHS','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P43','DEP-RET-PHS','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P45','DEP-ACDU-DEC','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P47','DEP-RET-DEC','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P26','P26 - unknown - found in Viromed data but not defined in our paper copies','USA');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P48','UNREMARRIED FORMER SPOUSE','PUBLIC_HEALTH');
INSERT INTO hdrl.DutyCode VALUES(DEFAULT,'P49','FAM MBR OF P48','PUBLIC_HEALTH');

CREATE TABLE hdrl.ShippingCarrier
(
    RowId SERIAL NOT NULL,
    Name VARCHAR(32),

    CONSTRAINT PK_ShippingCarrier PRIMARY KEY (RowId)
);

INSERT INTO hdrl.ShippingCarrier VALUES(DEFAULT, 'DHL');
INSERT INTO hdrl.ShippingCarrier VALUES(DEFAULT, 'FedEx');
INSERT INTO hdrl.ShippingCarrier VALUES(DEFAULT, 'UPS');
INSERT INTO hdrl.ShippingCarrier VALUES(DEFAULT, 'USPS');

CREATE TABLE hdrl.InboundRequest
(
    RequestId SERIAL NOT NULL,
    RequestStatusId INT NOT NULL,
    ShippingCarrierId INT,
    ShippingNumber VARCHAR(32),
    SubmittedBy USERID,
    Submitted TIMESTAMP,
    TestTypeId INT NOT NULL,

    Container ENTITYID NOT NULL,
    CreatedBy USERID,
    Created TIMESTAMP,
    ModifiedBy USERID,
    Modified TIMESTAMP,
    ArchivedRequestCount INT,

    CONSTRAINT PK_InboundRequest PRIMARY KEY (RequestId),
    CONSTRAINT FK_InboundRequest_Test FOREIGN KEY (TestTypeId) REFERENCES hdrl.TestType (RowId),
    CONSTRAINT FK_InboundRequest_Status FOREIGN KEY (RequestStatusId) REFERENCES hdrl.RequestStatus (RowId),
    CONSTRAINT FK_InboundRequest_ShippingCarrier FOREIGN KEY (ShippingCarrierId) REFERENCES hdrl.ShippingCarrier (RowId)
);

CREATE TABLE hdrl.InboundSpecimen
(
    RowId SERIAL NOT NULL,
    CustomerBarcode VARCHAR(64),
    LastName VARCHAR(64),
    FirstName VARCHAR(64),
    BirthDate TIMESTAMP,
    SSN VARCHAR(9),
    InboundRequestId INT NOT NULL,
    FMPId INT,
    DutyCodeId INT,
    TestingSourceId INT,
    DrawDate TIMESTAMP,
    DoDId BIGINT,
    Container ENTITYID NOT NULL,
    MiddleName VARCHAR(64),
    Initials VARCHAR(5),
    NumContainers INT DEFAULT 1,
    GenderId INT,

    CreatedBy USERID,
    Created TIMESTAMP,
    ModifiedBy USERID,
    Modified TIMESTAMP,

    CONSTRAINT PK_InboundSpecimen PRIMARY KEY (RowId),
    CONSTRAINT FK_InboundSpecimen_FMP FOREIGN KEY (FMPId) REFERENCES hdrl.FamilyMemberPrefix (RowId),
    CONSTRAINT FK_InboundSpecimen_DutyCode FOREIGN KEY (DutyCodeId) REFERENCES hdrl.DutyCode (RowId),
    CONSTRAINT FK_InboundSpecimen_TestingSource FOREIGN KEY (TestingSourceId) REFERENCES hdrl.SourceOfTesting (RowId),
    CONSTRAINT FK_InboundSpecimen_Request FOREIGN KEY (InboundRequestId) REFERENCES hdrl.InboundRequest (RequestId) ON DELETE CASCADE
);

CREATE TABLE hdrl.Gender
(
   RowId SERIAL NOT NULL,
   Code VARCHAR(1) NOT NULL,
   Description VARCHAR(20) NOT NULL,

   CONSTRAINT PK_Gender PRIMARY KEY (RowId),
   CONSTRAINT UQ_Gender UNIQUE (Code)
);

INSERT INTO hdrl.Gender VALUES(DEFAULT, 'A', 'Ambiguous');
INSERT INTO hdrl.Gender VALUES(DEFAULT, 'F', 'Female');
INSERT INTO hdrl.Gender VALUES(DEFAULT, 'M', 'Male');
INSERT INTO hdrl.Gender VALUES(DEFAULT, 'N', 'Not applicable');
INSERT INTO hdrl.Gender VALUES(DEFAULT, 'O', 'Other');
INSERT INTO hdrl.Gender VALUES(DEFAULT, 'U', 'Unknown');

ALTER TABLE hdrl.InboundSpecimen ADD CONSTRAINT FK_InboundSpecimen_Gender FOREIGN KEY (GenderId) REFERENCES hdrl.Gender (RowId);

CREATE TABLE hdrl.RequestResult
(
  RequestId INT NOT NULL,
  RequestStatusId INT NOT NULL,
  CustomerNote VARCHAR(254),
  Received TIMESTAMP NOT NULL,
  Completed TIMESTAMP,

  Container ENTITYID NOT NULL,
  CreatedBy USERID,
  Created TIMESTAMP,
  ModifiedBy USERID,
  Modified TIMESTAMP,

  CONSTRAINT PK_RequestResult PRIMARY KEY (RequestId),
  CONSTRAINT FK_RequestResult_InboundRequest FOREIGN KEY (RequestId) REFERENCES hdrl.InboundRequest(RequestId) ON DELETE CASCADE,
  CONSTRAINT FK_RequestResult_Status FOREIGN KEY (RequestStatusId) REFERENCES hdrl.RequestStatus(RowId)
);

CREATE TABLE hdrl.SpecimenResult
(
  SpecimenId INT NOT NULL,
  RequestStatusId INT NOT NULL,
  Received TIMESTAMP NOT NULL,
  Completed TIMESTAMP,
  SampleIntegrity VARCHAR(80),
  TestResult VARCHAR(254),
  CustomerCode VARCHAR(80),
  ModifiedResultFlag CHAR DEFAULT 'F',

  Container ENTITYID NOT NULL,
  CreatedBy USERID,
  Created TIMESTAMP,
  ModifiedBy USERID,
  Modified TIMESTAMP,
  RequestId INT NOT NULL,
    ReportFileName VARCHAR(20),

  CONSTRAINT PK_SpecimenResult PRIMARY KEY (SpecimenId),
  CONSTRAINT FK_SpecimenResult_InboundSpecimen FOREIGN KEY (SpecimenId) REFERENCES hdrl.InboundSpecimen(RowId) ON DELETE CASCADE,
  CONSTRAINT FK_SpecimenResult_Status FOREIGN KEY (RequestStatusId) REFERENCES hdrl.RequestStatus(RowId)

);

ALTER TABLE hdrl.specimenResult ADD CONSTRAINT FK_SpecimenResult_InboundRequest FOREIGN KEY (RequestId) REFERENCES hdrl.InboundRequest(RequestId) ON DELETE CASCADE;

CREATE TABLE hdrl.labwareOutboundRequests
(
  batch_id INT NOT NULL,
  hdrl_status VARCHAR(20),
  customer_note VARCHAR(254),
  date_received DATE NOT NULL,
  date_completed DATE,
  date_modified DATE NOT NULL,
  CONSTRAINT PK_LabwareOutboundRequests PRIMARY KEY (batch_id),
  CONSTRAINT FK_LabwareOutboundRequests_InboundRequest FOREIGN KEY (batch_id) REFERENCES hdrl.InboundRequest (RequestId) ON DELETE CASCADE
);

CREATE TABLE hdrl.labwareOutboundSpecimens
(
  test_request_id INT NOT NULL,
  batch_id INT NOT NULL,
  date_received DATE NOT NULL,
  date_completed DATE,
  sample_integrity VARCHAR(80),
  test_result VARCHAR(254),
  customer_code VARCHAR(80),
  hdrl_status VARCHAR(20),
  date_modified DATE NOT NULL,
  modified_result_flag VARCHAR(1),
  report_file_name VARCHAR(20),

  CONSTRAINT PK_LabwareOutboundSpecimens PRIMARY KEY (test_request_id),
  CONSTRAINT FK_LabwareOutboundSpecimens_LabwareOutboundRequests FOREIGN KEY (batch_id) REFERENCES hdrl.labwareOutboundRequests (batch_id) ON DELETE CASCADE,
  CONSTRAINT FK_LabwareOutboundSpecimens_InboundSpecimen FOREIGN KEY (test_request_id) REFERENCES hdrl.InboundSpecimen (RowId) ON DELETE CASCADE
);

/* hdrl-15.30-16.10.sql */

ALTER TABLE hdrl.labwareOutboundSpecimens DROP CONSTRAINT FK_LabwareOutboundSpecimens_LabwareOutboundRequests;

/* hdrl-16.10-16.20.sql */

ALTER TABLE hdrl.requestResult DROP COLUMN Container;
ALTER TABLE hdrl.specimenResult DROP COLUMN Container;

ALTER TABLE hdrl.labwareoutboundrequests ALTER COLUMN date_received TYPE timestamp;
ALTER TABLE hdrl.labwareoutboundrequests ALTER COLUMN date_completed TYPE timestamp;
ALTER TABLE hdrl.labwareoutboundrequests ALTER COLUMN date_modified TYPE timestamp;
ALTER TABLE hdrl.labwareoutboundspecimens ALTER COLUMN date_received TYPE timestamp;
ALTER TABLE hdrl.labwareoutboundspecimens ALTER COLUMN date_completed TYPE timestamp;
ALTER TABLE hdrl.labwareoutboundspecimens ALTER COLUMN date_modified TYPE timestamp;