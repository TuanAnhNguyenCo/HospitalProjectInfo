drop DATABASE if  exists hospital;
CREATE DATABASE hospital;
\c hospital
-- Account table
create table  Account(
    Id serial primary key,
    username varchar(20) unique not null,
    password varchar(20) not null,
    profile_id int unique
);

-- Profile table
create table   Profile(
    Id 	serial primary key,
    first_name varchar(25) not null,2
    last_name varchar(25) not null,
    sex char not null, 
    address text not null,
    date_of_birth TIMESTAMP not null,
    citizen_identication varchar(12) not null,
    phone_number varchar(10) not null,
    email varchar(50) unique not null,
    job varchar(20) not null,
    ethnic varchar(20) not null,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Role table
create table   Role(
    Id 	serial primary key,
    name varchar(15) unique not null
);

-- Account_Role_Relationship table
create table   Account_Role_Relationship(
    Id 	serial primary key,
    account_id int,
    role_id int,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notify table
create table   Notify(
    Id uuid primary key,
    sender_id int,
    receiver_id int,
    title varchar(100),
    description text ,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clinic table
create table   Clinic(
    Id 	serial primary key,
    name varchar(100),
    address text
);

-- Account_Clinic_Relationship table
create table   Account_Clinic_Relationship(
    Id 	serial primary key,
    account_id int,
    clinic_id int,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clinic history table
create table   ClinicHistory(
    Id 	serial primary key,
    day TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    current_ordinal_number int DEFAULT 0,
    clinic_id int
);

-- MedicalRecords table
create table   MedicalRecords(
    Id uuid primary key,
    profile_id int,
    name text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    end_at TIMESTAMP,
    ordinal_number int,
    clinic_id int,
    health_insurance boolean,
    payment_status boolean,
    verify_status boolean
);

-- DiagnosticResults
create table   DiagnosticResults(
    Id uuid primary key,
    results varchar(300),
    prescription varchar(300),
    medical_records_id uuid unique
);

-- MedicalExaminationSteps
create table   MedicalExaminationSteps(
    Id uuid primary key,
    payment_status boolean,
    results varchar(300),
    medical_records_id uuid
);

-- MedicalExamination
create table   MedicalExamination(
    Id serial primary key,
    name text,
    money decimal(15,2),
    medical_examination_steps_id uuid,
    clinic_id int
);

-- StatusByDay
create table   StatusByDay(
    Id uuid primary key,
    medical_records_id uuid,
    day TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TimeADay
create table   TimeADay(
    Id uuid primary key,
    status_by_day_id uuid,
    examination_at time,
    condition text
);

-- Foreign key

-- Account table


ALTER TABLE Account
ADD CONSTRAINT FK_Account_Profile
FOREIGN KEY (profile_id) REFERENCES Profile(Id);


-- ClinicHistory table

ALTER TABLE ClinicHistory
ADD CONSTRAINT FK_ClinicHistory_Clinic
FOREIGN KEY (clinic_id) REFERENCES Clinic(Id);

-- Account_Role_Relationship table
ALTER TABLE Account_Role_Relationship
ADD CONSTRAINT FK_Account_Role_Relationship_Account
FOREIGN KEY (account_id) REFERENCES Account(Id);

ALTER TABLE Account_Role_Relationship
ADD CONSTRAINT FK_Account_Role_Relationship_Role
FOREIGN KEY (role_id) REFERENCES Role(Id);

-- Notify table
ALTER TABLE Notify
ADD CONSTRAINT FK_Notify_Account_sender
FOREIGN KEY (sender_id) REFERENCES Account(Id);

ALTER TABLE Notify
ADD CONSTRAINT FK_Notify_Account_receiver
FOREIGN KEY (receiver_id) REFERENCES Account(Id);

-- Account_Clinic_Relationship table
ALTER TABLE Account_Clinic_Relationship
ADD CONSTRAINT FK_Account_Clinic_Relationship_Account
FOREIGN KEY (account_id) REFERENCES Account(Id);

ALTER TABLE Account_Clinic_Relationship
ADD CONSTRAINT FK_Account_Clinic_Relationship_Clinic
FOREIGN KEY (clinic_id) REFERENCES Clinic(Id);

-- MedicalRecords table

ALTER TABLE MedicalRecords
ADD CONSTRAINT FK_MedicalRecords_Profile
FOREIGN KEY (profile_id) REFERENCES Profile(id);

ALTER TABLE MedicalRecords
ADD CONSTRAINT FK_MedicalRecords_Clinic
FOREIGN KEY (clinic_id) REFERENCES Clinic(Id);

-- MedicalExaminationSteps table

ALTER TABLE MedicalExaminationSteps
ADD CONSTRAINT FK_MedicalExaminationSteps_MedicalRecords
FOREIGN KEY (medical_records_id) REFERENCES MedicalRecords(Id);

-- MedicalExamination table

ALTER TABLE MedicalExamination
ADD CONSTRAINT FK_MedicalExamination_MedicalExaminationSteps
FOREIGN KEY (medical_examination_steps_id) REFERENCES MedicalExaminationSteps(Id);

ALTER TABLE MedicalExamination
ADD CONSTRAINT FK_MedicalExamination_Clinic
FOREIGN KEY (clinic_id) REFERENCES Clinic(Id);

-- DiagnosticResults table

ALTER TABLE DiagnosticResults
ADD CONSTRAINT FK_DiagnosticResults_MedicalRecords
FOREIGN KEY (medical_records_id) REFERENCES MedicalRecords(Id);

-- StatusByDay table

ALTER TABLE StatusByDay
ADD CONSTRAINT FK_StatusByDay_MedicalRecords
FOREIGN KEY (medical_records_id) REFERENCES MedicalRecords(Id);

-- TimeADay table 

ALTER TABLE TimeADay
ADD CONSTRAINT FK_TimeADay_StatusByDay
FOREIGN KEY (status_by_day_id) REFERENCES StatusByDay(Id);



-- Insert data
insert into Role(name) values
        ('ROLE_USER'),
        ('ROLE_ADMIN');