--------------------------------------------------
-- 1. View all claims with patient and provider info
--------------------------------------------------
SELECT 
    c.claim_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    pr.provider_name,
    c.claim_amount,
    c.status
FROM claims c
JOIN patients p ON c.patient_id = p.patient_id
JOIN providers pr ON c.provider_id = pr.provider_id;

--------------------------------------------------
-- 2. View services per claim
--------------------------------------------------
SELECT 
    c.claim_id,
    cs.procedure_code,
    cs.description,
    cs.cost
FROM claim_services cs
JOIN claims c ON cs.claim_id = c.claim_id;

--------------------------------------------------
-- 3. View claims with diagnoses
--------------------------------------------------
SELECT 
    c.claim_id,
    d.diagnosis_code,
    d.description
FROM claim_diagnoses cd
JOIN claims c ON cd.claim_id = c.claim_id
JOIN diagnoses d ON cd.diagnosis_id = d.diagnosis_id;