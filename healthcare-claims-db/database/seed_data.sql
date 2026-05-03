--------------------------------------------------
-- Insurance Plans
--------------------------------------------------
INSERT INTO insurance_plans (plan_name, coverage_type)
VALUES
('Aetna Basic', 'HMO'),
('Blue Cross Premium', 'PPO'),
('United Healthcare Standard', 'EPO');

--------------------------------------------------
-- Patients
--------------------------------------------------
INSERT INTO patients (first_name, last_name, date_of_birth, gender, state, plan_id)
VALUES
('John', 'Doe', '1985-06-15', 'Male', 'NY', 1),
('Jane', 'Smith', '1990-09-20', 'Female', 'CA', 2),
('Ali', 'Khan', '1978-01-10', 'Male', 'TX', 3),
('Maria', 'Garcia', '2000-12-05', 'Female', 'FL', 1);

--------------------------------------------------
-- Providers
--------------------------------------------------
INSERT INTO providers (provider_name, provider_type, state)
VALUES
('City Hospital', 'Hospital', 'NY'),
('West Coast Clinic', 'Clinic', 'CA'),
('Lone Star Medical', 'Clinic', 'TX');

--------------------------------------------------
-- Data Ingestion Jobs
--------------------------------------------------
INSERT INTO data_ingestion_jobs (source_system, status, file_name)
VALUES
('ClaimsAPI', 'Completed', 'claims_jan.csv'),
('BatchUpload', 'Completed', 'claims_feb.csv');

--------------------------------------------------
-- Claim Batches
--------------------------------------------------
INSERT INTO claim_batches (job_id, batch_date, total_records, processing_status)
VALUES
(1, '2024-01-10', 100, 'Processed'),
(2, '2024-02-15', 150, 'Processed');

--------------------------------------------------
-- Claims
--------------------------------------------------
INSERT INTO claims (patient_id, provider_id, batch_id, claim_date, claim_amount, status)
VALUES
(1, 1, 1, '2024-01-11', 500.00, 'Pending'),
(2, 2, 1, '2024-01-12', 1200.00, 'Approved'),
(3, 3, 2, '2024-02-16', 300.00, 'Denied'),
(4, 1, 2, '2024-02-17', 750.00, 'Pending');

--------------------------------------------------
-- Claim Services
--------------------------------------------------
INSERT INTO claim_services (claim_id, procedure_code, description, cost)
VALUES
(1, 'PROC001', 'X-Ray', 200.00),
(1, 'PROC002', 'Blood Test', 300.00),
(2, 'PROC003', 'MRI Scan', 1200.00),
(3, 'PROC004', 'Consultation', 300.00);

--------------------------------------------------
-- Diagnoses
--------------------------------------------------
INSERT INTO diagnoses (diagnosis_code, description)
VALUES
('D001', 'Flu'),
('D002', 'Fracture'),
('D003', 'Hypertension');

--------------------------------------------------
-- Claim Diagnoses
--------------------------------------------------
INSERT INTO claim_diagnoses (claim_id, diagnosis_id)
VALUES
(1, 1),
(2, 2),
(3, 3);

--------------------------------------------------
-- Claim Status History
--------------------------------------------------
INSERT INTO claim_status_history (claim_id, old_status, new_status)
VALUES
(1, 'New', 'Pending'),
(2, 'Pending', 'Approved'),
(3, 'Pending', 'Denied');