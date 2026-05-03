-- Drop tables if they exist (for easy re-run)
DROP TABLE IF EXISTS claim_status_history CASCADE;
DROP TABLE IF EXISTS claim_diagnoses CASCADE;
DROP TABLE IF EXISTS claim_services CASCADE;
DROP TABLE IF EXISTS claims CASCADE;
DROP TABLE IF EXISTS claim_batches CASCADE;
DROP TABLE IF EXISTS data_ingestion_jobs CASCADE;
DROP TABLE IF EXISTS diagnoses CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS providers CASCADE;
DROP TABLE IF EXISTS insurance_plans CASCADE;

--------------------------------------------------
-- 1. Insurance Plans
--------------------------------------------------
CREATE TABLE insurance_plans (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    coverage_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------
-- 2. Patients
--------------------------------------------------
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    state VARCHAR(50),
    plan_id INT,
    FOREIGN KEY (plan_id) REFERENCES insurance_plans(plan_id)
);

--------------------------------------------------
-- 3. Providers
--------------------------------------------------
CREATE TABLE providers (
    provider_id SERIAL PRIMARY KEY,
    provider_name VARCHAR(100),
    provider_type VARCHAR(50),
    state VARCHAR(50)
);

--------------------------------------------------
-- 4. Data Ingestion Jobs
--------------------------------------------------
CREATE TABLE data_ingestion_jobs (
    job_id SERIAL PRIMARY KEY,
    source_system VARCHAR(100),
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    file_name VARCHAR(100)
);

--------------------------------------------------
-- 5. Claim Batches
--------------------------------------------------
CREATE TABLE claim_batches (
    batch_id SERIAL PRIMARY KEY,
    job_id INT,
    batch_date DATE,
    total_records INT,
    processing_status VARCHAR(50),
    FOREIGN KEY (job_id) REFERENCES data_ingestion_jobs(job_id)
);

--------------------------------------------------
-- 6. Claims
--------------------------------------------------
CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    batch_id INT,
    claim_date DATE,
    claim_amount DECIMAL(10,2),
    status VARCHAR(50),

    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),
    FOREIGN KEY (batch_id) REFERENCES claim_batches(batch_id)
);

--------------------------------------------------
-- 7. Claim Services
--------------------------------------------------
CREATE TABLE claim_services (
    service_id SERIAL PRIMARY KEY,
    claim_id INT,
    procedure_code VARCHAR(50),
    description TEXT,
    cost DECIMAL(10,2),

    FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
);

--------------------------------------------------
-- 8. Diagnoses
--------------------------------------------------
CREATE TABLE diagnoses (
    diagnosis_id SERIAL PRIMARY KEY,
    diagnosis_code VARCHAR(50),
    description TEXT
);

--------------------------------------------------
-- 9. Claim Diagnoses (Many-to-Many)
--------------------------------------------------
CREATE TABLE claim_diagnoses (
    claim_id INT,
    diagnosis_id INT,
    PRIMARY KEY (claim_id, diagnosis_id),

    FOREIGN KEY (claim_id) REFERENCES claims(claim_id),
    FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(diagnosis_id)
);

--------------------------------------------------
-- 10. Claim Status History (for trigger)
--------------------------------------------------
CREATE TABLE claim_status_history (
    history_id SERIAL PRIMARY KEY,
    claim_id INT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (claim_id) REFERENCES claims(claim_id)
);
--------------------------------------------------
-- Function: Get total cost of a claim
--------------------------------------------------
CREATE OR REPLACE FUNCTION get_total_claim_cost(claim_id_input INT)
RETURNS DECIMAL AS $$
DECLARE
    total_cost DECIMAL;
BEGIN
    SELECT SUM(cost)
    INTO total_cost
    FROM claim_services
    WHERE claim_id = claim_id_input;

    RETURN COALESCE(total_cost, 0);
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------
-- Procedure: Process claim (approve/deny)
--------------------------------------------------
CREATE OR REPLACE PROCEDURE process_claim(p_claim_id INT, p_status VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE claims
    SET status = p_status
    WHERE claim_id = p_claim_id;
END;
$$;

--------------------------------------------------
-- Trigger Function: Log claim status changes
--------------------------------------------------
CREATE OR REPLACE FUNCTION log_claim_status_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status <> OLD.status THEN
        INSERT INTO claim_status_history (claim_id, old_status, new_status)
        VALUES (OLD.claim_id, OLD.status, NEW.status);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------
-- Trigger: fires when claim status updates
--------------------------------------------------
CREATE TRIGGER claim_status_trigger
AFTER UPDATE ON claims
FOR EACH ROW
EXECUTE FUNCTION log_claim_status_change();
