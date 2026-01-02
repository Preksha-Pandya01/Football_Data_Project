# ⚽ Global Football Data Analytics Platform

An end-to-end **data engineering & analytics project** that ingests, cleans, validates, migrates, and analyzes large-scale football datasets to generate actionable insights using **PostgreSQL, Snowflake, AWS, dbt, and Power BI**.

---

## 📌 Project Overview

This project demonstrates a **complete modern data engineering pipeline** built around football data such as:

- Players
- Teams
- Performances
- Transfers
- Market values
- Injuries
- National team appearances
- children team
- teams competitions

The pipeline starts with **raw data ingestion**, applies **robust validation and transformation**, migrates schemas using **SnowConvert AI**, and ends with **interactive Power BI dashboards** that support data-driven decision-making in the football ecosystem.

---

## 🎯 Project Objectives

- Design a **relational data model** capturing key football entities with proper PK–FK relationships
- Implement **Raw → Intermediate → Final layered architecture**
- Perform **data cleansing & standardization**
- Migrate PostgreSQL schemas to **Snowflake using SnowConvert**
- Validate data using **YAML-driven rules with AWS Lambda**
- Track historical changes using **dbt snapshots**
- Build **business-ready KPIs and dashboards** in Power BI

---

## 🧱 High-Level Architecture


---

### 🔄 Pipeline Explanation

- **S3 (Raw Files)**  
  Stores raw football datasets as received from the source.

- **PostgreSQL – Raw Schema**  
  Stores validated data in its original structure for traceability and auditing.

- **PostgreSQL – Intermediate Schema**  
  Applies data cleansing, standardization, deduplication, and business logic.

- **PostgreSQL – Final Schema**  
  For deriving the KPIs as per the need

- **SnowConvert (Schema Migration)**  
  Migrates PostgreSQL schema and logic into Snowflake using SnowConvert AI.

- **AWS Lambda + SQS (Validation)**  
  Event-driven validation using YAML rules to ensure schema integrity, data quality, and business constraints.



---

## 🗂️ Repository Structure


---

## 📁 Folder Description

| Folder | Description |
|------|-------------|
| `football_postgres/` | PostgreSQL schemas, tables, procedures |
| `snowconvert/` | SnowConvert migration outputs & reports |
| `snowflake/` | Snowflake DDLs, views, procedures |
| `validation_rules/` | YAML-based data validation rules |
| `lambda_validation.py` | AWS Lambda validation logic |
| `README.md` | Project documentation |

---

## 🧩 Core Data Tables

### Player Profile
Stores biographical, contractual, and career details.

### Player Performance
Player statistics by **season × competition × team**  
(goals, assists, minutes, cards, etc.)

### Player Market Value
Historical market value tracking over time.

### Transfer History
Tracks player transfers across seasons with fees and values.

### Player Injuries
Injury types, duration, and matches missed per season.

### National Team Performance
International appearances and goals.

### Player Teammates Played With
Co-performance metrics between player pairs.

### Teams Children
Parent–child relationships (U17, U19, reserve teams).

### Teams Competition Season
Maps which team played in which competition in a season.

### Team Details
Club metadata such as country, division, and competition.

---

## 🧪 Data Validation (AWS Lambda + YAML)

Before data enters Snowflake, each dataset is validated using **YAML-based rules**.

### Validation Checks
- Schema validation
- Datatype checks
- Null checks
- Allowed value checks
- Min/Max constraints
- Uniqueness checks

### Validation Flow
1. File uploaded to S3  
2. S3 event triggers SQS  
3. SQS invokes AWS Lambda  
4. Lambda validates data  
5. ✔ Valid → `validated/` bucket  
6. ❌ Invalid → `quarantine/` bucket with error logs  

All logs are captured in **CloudWatch Logs**.

---

## 🧬 Schema Layering Strategy

### 🔹 Raw Schema
- Stores data **as received** from the validated folder of s3 bucket
- No transformations
- Audit-friendly

### 🔹 Intermediate Schema
- Data cleansing
- Type casting
- Null handling
- Deduplication
- Business rule application

### 🔹 Final Schema
- Analytics-ready views
- KPI-focused datasets
- Optimized for Power BI performance

---

## 📊 Final Views & KPIs (Snowflake)

| View | Description |
|----|------------|
| `vw_highest_transfer_per_season` | Highest transfer fee per season |
| `vw_top_scorers_per_season` | Top goal scorers per season |
| `vw_top_assists_per_season` | Top assist providers per season |
| `vw_player_market_value_growth_rate` | Market value growth (%) |
| `vw_injury_type_trends` | Injury trends and days missed |
| `vw_injury_burden_per_team_per_season` | Team-wise injury impact |

---

## 🧠 Historical Tracking with dbt Snapshots

dbt snapshots are used to track **slowly changing dimensions**, such as:

- Player nationality
- Club changes
- Agent changes

Snapshot metadata includes:
- `dbt_scd_id`
- `dbt_updated_at`
- `dbt_valid_from`
- `dbt_valid_to`

This enables **time-based analysis and auditing**.

---

## 📈 Power BI Dashboards

### Dashboards Built
- Player Insights
- Team Insights
- Transfer Market Analytics
- Injury Analysis
- Market Value Trends

### Key KPIs
- Overall Player Performance Index
- Top Performing Player
- Player Market Value Growth %
- Injury Burden by Team
- Transfer Expenditure by Club
- Player Mobility Index

---

## 🛠️ Tools & Technologies

- **Databases**: PostgreSQL (AWS RDS), Snowflake
- **Cloud**: AWS S3, Lambda, SQS, CloudWatch
- **Migration**: SnowConvert AI
- **Transformation**: SQL, dbt Core
- **Visualization**: Power BI
- **Version Control**: GitHub

---

## 🚀 Why This Project Stands Out

- ✅ End-to-end real-world data pipeline
- ✅ Strong data modeling & governance
- ✅ Automated validation framework
- ✅ Cloud-native & scalable architecture
- ✅ Analytics-ready design
- ✅ Recruiter & interview friendly

---

## 📌 Future Enhancements

- Streaming ingestion support
- Incremental loading strategies
- Advanced player performance metrics
- ML-based player ranking & prediction models


- **Snowflake (Raw → Intermediate → Final)**  
  Houses analytics-ready data optimized for reporting and KPI calculations.

- **Power BI Dashboards**  
  Interactive dashboards for player, team, transfer, and injury insights.

