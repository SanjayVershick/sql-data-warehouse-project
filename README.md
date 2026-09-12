# 📊 Data Warehouse Project

## 📌 Project Overview

![Data Warehouse Architecture](docs/data%20architecture-Page-1.drawio.png)

This project is an end-to-end **Data Warehouse Project** designed to transform raw data into clean, structured, and analytics-ready datasets.

The project follows a **Medallion Architecture** consisting of Bronze, Silver, and Gold layers. The raw source data is ingested into the data warehouse, cleaned and transformed, and finally organized into business-ready tables for analytics and reporting.

The main objective is to demonstrate a practical **Data Engineering pipeline** covering data ingestion, data cleansing, transformation, data modeling, and analytics.

---

## 🏗️ Architecture

```text
                ┌─────────────────────┐
                │   Source CSV Files  │
                │             Data    │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │    Bronze Layer     │
                │   Raw Source Data   │
                └──────────┬──────────┘
                           │
                    Data Cleaning
                    & Transformation
                           │
                           ▼
                ┌─────────────────────┐
                │    Silver Layer     │
                │ Cleaned & Standard  │
                │       Data          │
                └──────────┬──────────┘
                           │
                  Data Integration
                    & Data Modeling
                           │
                           ▼
                ┌─────────────────────┐
                │     Gold Layer      │
                │ Business-Ready Data │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │      Analytics      │
                │ SQL / BI / Reports  │
                └─────────────────────┘
```

---

## 🥉 Bronze Layer

The **Bronze Layer** stores the data in its raw form as received from the source systems.

### Responsibilities

* Store raw source data
* Preserve the original data
* Minimal transformation
* Provide a reliable source for downstream processing

Example:

```text
datasets/
└── source_crm/
    ├── customers.csv
    ├── products.csv
    └── sales.csv
```

---

## 🥈 Silver Layer

The **Silver Layer** contains cleaned and standardized data.

### Transformations include

* Removing duplicates
* Handling NULL values
* Removing unwanted spaces
* Standardizing formats
* Validating dates
* Correcting invalid values
* Standardizing categorical fields
* Data type conversions
* Data quality checks

The goal is to create **consistent and reliable datasets** for analytical processing.

---

## 🥇 Gold Layer

The **Gold Layer** contains business-ready data designed for analytics.

The data is modeled using appropriate **fact and dimension tables** to make querying and reporting easier.

Example:

![Tables Connections](docs/table%20connection%20Diagram.drawio.png)

---

## 🛠️ Technologies Used

* **SQL Server** – Data warehouse and SQL transformations
* **SQL** – Data cleaning, transformation, validation, and analysis
* **Draw.io** – Data architecture and data modeling diagrams
* **Git & GitHub** – Version control and project management

---

## 🔄 Data Pipeline

The overall pipeline follows these steps:

### 1. Data Ingestion

Raw datasets are collected and stored in the source/raw area.

### 2. Bronze Processing

The raw data is loaded without significant transformations to preserve the original source.

### 3. Data Cleaning

The Silver layer processes the Bronze data by applying data quality and standardization rules.

### 4. Data Transformation

The cleaned data is transformed into structures suitable for analytical workloads.

### 5. Data Modeling

The Gold layer organizes the data into fact and dimension tables.

### 6. Analytics

SQL queries can then be used to analyze metrics and generate business insights.

---


```text
CSV Files
    │
    ▼
Silver Data
    │
    ▼
Data Warehouse
    │
    ▼
Gold Layer
    │
    ▼
Analytics
```
---

## 🔍 Data Quality Checks

Several data quality checks are applied throughout the pipeline.

Examples include:

* Duplicate record detection
* NULL validation
* Invalid date detection
* Invalid numerical values
* Primary key validation
* Foreign key validation
* Data consistency checks
* Uniqueness checks

Example SQL check:

```sql
SELECT 
    sls_prd_key,
    COUNT(*) AS record_count
FROM silver.crm_sales_details
GROUP BY sls_prd_key
HAVING COUNT(*) > 1;
```

This identifies product keys that appear multiple times in the dataset.

---

## 📐 Data Modeling

The Gold layer follows a dimensional modeling approach.

### Fact Tables

Fact tables contain measurable business events and metrics.

### Dimension Tables

Dimension tables provide descriptive information.

This structure makes analytical queries easier and more efficient.

---
```

## 🎯 Project Goals

This project demonstrates practical experience with:

* Data Warehousing
* ETL / ELT Pipelines
* Medallion Architecture
* Dimensional Data Modeling
* SQL
* Data Cleaning
* Data Quality
* Git & GitHub

---

## 🚀 Key Learning Outcomes

Through this project, I gained hands-on experience in designing and implementing a complete data engineering workflow, from **raw data ingestion to analytical data modeling**.

The project helped strengthen my understanding of:

1. Building data warehouse layers
2. Writing SQL transformation pipelines
3. Implementing data quality checks
4. Designing fact and dimension tables
5. Converting CSV data into Parquet
6. Managing projects using Git and GitHub
7. Creating scalable and maintainable data pipelines

---

## 👨‍💻 Author

**Sanjay**

This project was created as a hands-on Data Engineering project to demonstrate skills in **SQL, Data Warehousing and Data Modeling**.
