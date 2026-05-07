# Olist E-commerce Data Warehouse and Dashboard Project

> English version below

---

## Opis projektu

### O projekcie
Projekt obejmuje budowę hurtowni danych oraz interaktywnego dashboardu analitycznego opartego na danych e-commerce brazylijskiego marketplace’u Olist. Celem projektu było przekształcenie surowych danych relacyjnych w model typu Star Schema (Schemat Gwiazdy), co zoptymalizowało wydajność zapytań i umożliwiło stworzenie czytelnych raportów biznesowych.

Dane obejmują ponad 100 000 zamówień z lat 2016-2018, zawierając szczegółowe informacje o produktach, płatnościach, logistyce oraz lokalizacji klientów i sprzedawców.

### Wykorzystane technologie
* Baza danych: Microsoft SQL Server (T-SQL)
* Narzędzie ETL: Skrypty SQL (procedury transformacji i ładowania)
* Wizualizacja danych: Power BI
* Modelowanie: Star Schema

### Architektura Danych (Star Schema)
Model danych został zaprojektowany w celu ułatwienia analizy Business Intelligence. Centralna tabela faktów jest połączona z tabelami wymiarów, co pozwala na szybkie filtrowanie i agregację danych.

Główne komponenty modelu:
* Tabela Faktów: Fact_orders - zawiera miary takie jak cena, koszt transportu, wartość całkowita oraz klucze obce do wymiarów.
* Tabele Wymiarów:
    * Dim_products: szczegóły o kategoriach, wadze i wymiarach produktów.
    * Dim_customers i Dim_sellers: dane geograficzne oraz lokalizacja stron transakcji.
    * Dim_payments: typy płatności i liczba rat.
    * Dim_date: dedykowany wymiar czasu generowany skryptem SQL, obsługujący analizy rok-do-roku i weekendy.

### Proces ETL i SQL
Projekt zawiera trzy główne skrypty SQL odpowiedzialne za przetwarzanie danych:
1. 01_create_schema.sql: Definicja DDL dla wszystkich tabel oraz automatyczne generowanie wymiaru czasu.
2. 02_load_dimensions.sql: Czyszczenie i ładowanie danych do wymiarów, w tym użycie funkcji ROW_NUMBER() do usuwania duplikatów klientów.
3. 03_load_fact.sql: Zaawansowane ładowanie tabeli faktów, uwzględniające logikę wyboru dominującej metody płatności dla zamówienia oraz walidację sum kontrolnych po załadowaniu.

### Dashboard Analityczny
Raport Power BI składa się z trzech kluczowych obszarów:
* Wyniki Finansowe
* Logistyka
* Produkty i Kategorie

---

## Project Description

### Overview
This project involves building a data warehouse and an interactive analytical dashboard using e-commerce data from Olist, a major Brazilian marketplace. The primary goal was to transform raw relational data into a Star Schema model, optimizing query performance and enabling business intelligence reporting.

The dataset contains over 100,000 orders from 2016 to 2018, featuring details on products, payments, logistics, and geographic information for both customers and sellers.

### Tech Stack
* Database: Microsoft SQL Server (T-SQL)
* ETL Tool: SQL Scripts (Transformation and Loading procedures)
* Data Visualization: Power BI
* Data Modeling: Star Schema

### Data Architecture (Star Schema)
The data model is designed for efficient BI analysis. A central fact table is linked to several dimension tables to support rapid data filtering and aggregation.

Key Components:
* Fact Table: Fact_orders - stores measures such as price, freight value, total value, and dimensional keys.
* Dimension Tables:
    * Dim_products: Product category details, weight, and dimensions.
    * Dim_customers and Dim_sellers: Geographic data for transaction parties.
    * Dim_payments: Payment types and installment counts.
    * Dim_date: A custom time dimension generated via SQL script for temporal analysis.

### ETL Process and SQL
The project includes three main SQL scripts for data processing:
1. 01_create_schema.sql: DDL definitions for all tables and automatic time dimension generation.
2. 02_load_dimensions.sql: Data cleansing and dimension loading, utilizing ROW_NUMBER() to handle customer record duplicates.
3. 03_load_fact.sql: Advanced fact table loading that handles multiple payments per order and includes checksum validation against raw datasets.

### Analytical Dashboard
The Power BI report focuses on three performance areas:
* Financial Performance
* Deliveries (Logistics)
* Products and Categories

---

### How to Run
1. Set up a Microsoft SQL Server instance.
2. Execute the scripts in order: 01_create_schema.sql, 02_load_dimensions.sql, and finally 03_load_fact.sql.
3. Open the Power BI file and connect it to your SQL Server database to view the dashboard.
