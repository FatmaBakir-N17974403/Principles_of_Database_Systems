--------------------------------------------------
-- View 1: Detailed Claims View
--------------------------------------------------
CREATE OR REPLACE VIEW claim_details_view AS
SELECT 
    c.claim_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    pr.provider_name,
    c.claim_amount,
    c.status,
    c.claim_date
FROM claims c
JOIN patients p ON c.patient_id = p.patient_id
JOIN providers pr ON c.provider_id = pr.provider_id;

--------------------------------------------------
-- View 2: Claim Services Summary
--------------------------------------------------
CREATE OR REPLACE VIEW claim_service_summary AS
SELECT 
    c.claim_id,
    SUM(cs.cost) AS total_service_cost
FROM claims c
JOIN claim_services cs ON c.claim_id = cs.claim_id
GROUP BY c.claim_id;
--------------------------------------------------
-- Report 1: Total Claims per Provider
--------------------------------------------------
SELECT 
    pr.provider_name,
    COUNT(c.claim_id) AS total_claims,
    SUM(c.claim_amount) AS total_amount
FROM claims c
JOIN providers pr ON c.provider_id = pr.provider_id
GROUP BY pr.provider_name;

--------------------------------------------------
-- Report 2: Total Cost per Patient
--------------------------------------------------
SELECT 
    p.first_name || ' ' || p.last_name AS patient_name,
    SUM(c.claim_amount) AS total_spent
FROM claims c
JOIN patients p ON c.patient_id = p.patient_id
GROUP BY patient_name;

--------------------------------------------------
-- Report 3: Claims per State
--------------------------------------------------
SELECT 
    p.state,
    COUNT(c.claim_id) AS total_claims
FROM claims c
JOIN patients p ON c.patient_id = p.patient_id
GROUP BY p.state;

--------------------------------------------------
-- Report 4: Average Claim Amount
--------------------------------------------------
SELECT 
    AVG(claim_amount) AS avg_claim_amount
FROM claims;