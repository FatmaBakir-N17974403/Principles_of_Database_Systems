# Healthcare Claims Processing System

## Overview

This project is a **Healthcare Claims Processing Database System** that models real-world insurance claim workflows. It includes a fully normalized PostgreSQL database, backend logic using Flask, reporting queries, and a web-based UI deployed on AWS EC2.

The system tracks patients, providers, claims, services, diagnoses, ingestion jobs, and claim batches. It demonstrates a complete database lifecycle including **design, implementation, querying, and deployment**.

---

## Technologies Used

- PostgreSQL (Relational Database)
- Python (Flask)
- psycopg2 (Database Connector)
- HTML (Frontend Templates)
- AWS EC2 (Ubuntu Deployment)

---

## Project Structure
healthcare-claims-db/
│
├── app/
│ ├── app.py
│ └── templates/
│ ├── home.html
│ ├── patients.html
│ ├── claims.html
│ └── reports.html
│
├── database/
│ ├── schema.sql
│ ├── seed_data.sql
│ ├── queries.sql
│ └── reports.sql
│
├── diagrams/
│ └── er_diagram.png
│
├── requirements.txt
└── README.md

## Database
Includes **10 tables**:
- patients, providers, insurance_plans  
- claims, claim_services  
- diagnoses, claim_diagnoses  
- data_ingestion_jobs, claim_batches  
- claim_status_history  

### Relationships
- Patient → Claims (1:M)  
- Provider → Claims (1:M)  
- Claim → Services (1:M)  
- Claim ↔ Diagnosis (M:N)  

---

## Features
- Insert and view patients & claims (UI)  
- Aggregation reports (SQL)  
- Views for simplified queries  
- Function (calculate claim cost)  
- Procedure (process claims)  
- Trigger (log status changes)  