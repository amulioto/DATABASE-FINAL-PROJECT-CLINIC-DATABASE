-- Database: nakuru_county_hospital
-- Create the database
CREATE DATABASE IF NOT EXISTS nakuru_county_hospital;
-- Use the database
USE nakuru_county_hospital;
-- Table: Patients
CREATE TABLE IF NOT EXISTS Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE,
    Gender VARCHAR(10),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20) UNIQUE,
    RegistrationDate DATE NOT NULL
);
-- Table: Departments
CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) UNIQUE NOT NULL
);
-- Table: Doctors
CREATE TABLE IF NOT EXISTS Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Specialization VARCHAR(100),
    PhoneNumber VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX (LastName)
);
-- Table: Nurses
CREATE TABLE IF NOT EXISTS Nurses (
    NurseID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT,
    PhoneNumber VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX (LastName)
);
-- Table: Wards
CREATE TABLE IF NOT EXISTS Wards (
    WardID INT PRIMARY KEY AUTO_INCREMENT,
    WardName VARCHAR(100) UNIQUE NOT NULL,
    Capacity INT NOT NULL
);
-- Table: Beds
CREATE TABLE IF NOT EXISTS Beds (
    BedID INT PRIMARY KEY AUTO_INCREMENT,
    WardID INT NOT NULL,
    BedNumber VARCHAR(10) NOT NULL,
    IsOccupied BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (WardID) REFERENCES Wards(WardID) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (WardID, BedNumber),
    INDEX (WardID),
    INDEX (IsOccupied)
);
-- Table: Admissions
CREATE TABLE IF NOT EXISTS Admissions (
    AdmissionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    WardID INT NOT NULL,
    BedID INT NOT NULL,
    AdmissionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DischargeDate DATETIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (WardID) REFERENCES Wards(WardID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (BedID) REFERENCES Beds(BedID) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX (PatientID),
    INDEX (WardID),
    INDEX (BedID),
    INDEX (AdmissionDate)
);
-- Table: Appointments
CREATE TABLE IF NOT EXISTS Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDateTime DATETIME NOT NULL,
    Reason VARCHAR(255),
    Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled', -- e.g., Scheduled, Confirmed, Cancelled, Completed
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX (PatientID),
    INDEX (DoctorID),
    INDEX (AppointmentDateTime)
);
-- Table: Prescriptions
CREATE TABLE IF NOT EXISTS Prescriptions (
    PrescriptionID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    MedicationName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(50),
    Frequency VARCHAR(50),
    PrescriptionDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX (PatientID),
    INDEX (DoctorID),
    INDEX (PrescriptionDate)
);
-- Table: Diagnoses
CREATE TABLE IF NOT EXISTS Diagnoses (
    DiagnosisID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    DiagnosisName VARCHAR(255) NOT NULL,
    DiagnosisDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX (PatientID),
    INDEX (DoctorID),
    INDEX (DiagnosisDate)
);
-- Table: Tests
CREATE TABLE IF NOT EXISTS Tests (
    TestID INT PRIMARY KEY AUTO_INCREMENT,
    TestName VARCHAR(100) UNIQUE NOT NULL,
    Description TEXT
);
-- Table: TestResults
CREATE TABLE IF NOT EXISTS TestResults (
    ResultID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    TestID INT NOT NULL,
    DoctorID INT NOT NULL,
    TestDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ResultValue VARCHAR(255),
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (TestID) REFERENCES Tests(TestID) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX (PatientID),
    INDEX (TestID),
    INDEX (DoctorID),
    INDEX (TestDate)
);
-- filling
-- Database: nakuru_county_hospital
-- Use the nakuru_county_hospital database
USE nakuru_county_hospital;

-- Inserting data into Departments
INSERT INTO Departments (DepartmentName) VALUES
('Cardiology'),
('Maternity'),
('Pediatrics'),
('General Medicine'),
('Surgery'),
('Emergency');

-- Inserting data into Wards
INSERT INTO Wards (WardName, Capacity) VALUES
('General Ward A', 30),
('Maternity Ward', 20),
('Pediatric Ward', 15),
('Surgical Ward', 25),
('Emergency Room', 10);

-- Inserting data into Doctors
INSERT INTO Doctors (FirstName, LastName, DepartmentID, Specialization, PhoneNumber, Email) VALUES
('Dr.', 'Wanjiru', 1, 'Cardiologist', '0712345678', 'wanjiru.kamau@nch.go.ke'), -- Kikuyu
('Dr.', 'Oluoch', 2, 'Obstetrician', '0798765432', 'oluoch.odera@nch.go.ke'),   -- Luo
('Dr.', 'Chepkoech', 3, 'Pediatrician', '0722113344', 'chepkoech.rotich@nch.go.ke'), -- Kalenjin
('Dr.', 'Mwangi', 4, 'General Physician', '0733557799', 'mwangi.kariuki@nch.go.ke'), -- Kikuyu
('Dr.', 'Adhiambo', 5, 'General Surgeon', '0700112233', 'adhiambo.oyoo@nch.go.ke');  -- Luo

-- Inserting data into Nurses
INSERT INTO Nurses (FirstName, LastName, DepartmentID, PhoneNumber, Email) VALUES
('Sister', 'Njeri', 1, '0744556677', 'njeri.wambui@nch.go.ke'),      -- Kikuyu
('Nurse', 'Otieno', 2, '0755889900', 'otieno.juma@nch.go.ke'),      -- Luo
('Nurse', 'Kigen', 3, '0766112233', 'kigen.arap@nch.go.ke'),       -- Kalenjin
('Nurse', 'Wairimu', 4, '0788334455', 'wairimu.muriithi@nch.go.ke'), -- Kikuyu
('Nurse', 'Amina', 5, '0799667788', 'amina.mohamed@nch.go.ke');     -- Swahili/Muslim

-- Inserting data into Beds
INSERT INTO Beds (WardID, BedNumber, IsOccupied) VALUES
(1, 'A1', FALSE), (1, 'A2', TRUE), (1, 'A3', FALSE), (1, 'B1', FALSE), (1, 'B2', FALSE),
(2, 'M1', FALSE), (2, 'M2', FALSE), (2, 'M3', TRUE),
(3, 'P1', FALSE), (3, 'P2', FALSE),
(4, 'S1', TRUE), (4, 'S2', FALSE),
(5, 'E1', FALSE), (5, 'E2', TRUE);

-- Inserting data into Patients
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, Address, PhoneNumber, RegistrationDate) VALUES
('Karanja', 'Maina', '1988-05-20', 'Male', 'Kiamunyi, Nakuru', '0711223344', '2025-05-01'),     -- Kikuyu
('Okoth', 'Onyango', '1992-10-15', 'Male', 'Kondele, Kisumu', '0722334455', '2025-05-01'),     -- Luo
('Chemutai', 'Kiprotich', '2003-02-01', 'Female', 'Kabarnet, Baringo', '0733445566', '2025-05-02'), -- Kalenjin
('Wambui', 'Njoroge', '1975-12-25', 'Female', 'Nakuru Town East', '0744556677', '2025-05-03'),  -- Kikuyu
('Ali', 'Hassan', '1980-07-01', 'Male', 'Bondeni, Nakuru', '0755667788', '2025-05-04');      -- Swahili/Muslim

-- Inserting data into Admissions
INSERT INTO Admissions (PatientID, WardID, BedID, AdmissionDate) VALUES
(1, 1, 1, '2025-05-01 08:00:00'),
(2, 2, 3, '2025-05-02 14:30:00'),
(3, 3, 10, '2025-05-03 10:15:00'),
(4, 1, 2, '2025-05-04 16:00:00');

-- Inserting data into Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDateTime, Reason, Status) VALUES
(5, 4, '2025-05-08 09:30:00', 'General Checkup', 'Scheduled'),
(1, 1, '2025-05-09 11:00:00', 'Cardiology Follow-up', 'Scheduled'),
(3, 3, '2025-05-10 14:00:00', 'Pediatric Consultation', 'Scheduled');

-- Inserting data into Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicationName, Dosage, Frequency) VALUES
(1, 1, 'Aspirin', '100mg', 'Once daily'),
(2, 2, 'Paracetamol', '500mg', 'Every 6 hours as needed'),
(3, 3, 'Amoxicillin', '250mg', 'Three times a day');

-- Inserting data into Diagnoses
INSERT INTO Diagnoses (PatientID, DoctorID, DiagnosisName, DiagnosisDate) VALUES
(1, 1, 'Hypertension', '2025-05-01 08:30:00'),
(2, 2, 'Common Cold', '2025-05-02 15:00:00'),
(3, 3, 'Fever', '2025-05-03 10:45:00');

-- Inserting data into Tests
INSERT INTO Tests (TestName, Description) VALUES
('Blood Pressure Measurement', 'Standard blood pressure reading'),
('Full Blood Count', 'Comprehensive blood cell analysis'),
('Malaria Test', 'Test for malaria parasites');

-- Inserting data into TestResults
INSERT INTO TestResults (PatientID, TestID, DoctorID, TestDate, ResultValue) VALUES
(1, 1, 1, '2025-05-01 08:45:00', '140/90 mmHg'),
(2, 2, 4, '2025-05-02 16:00:00', 'Normal range'),
(3, 3, 3, '2025-05-03 11:30:00', 'Negative');