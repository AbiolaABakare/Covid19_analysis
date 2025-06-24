# 🦠 COVID-19 Data Exploration Project

**Author:** Abiola Bakare
**Stack:** Microsoft SQL Server
**Skills Used:** Joins · CTEs · Temp Tables · Window Functions · Aggregates · Views · Data Type Conversion
**Theme:** Exploring global COVID-19 trends using SQL

---

## 📌 Overview

This project explores real-world COVID-19 data using SQL to analyze pandemic trends across time, geography, and population. It combines two datasets — COVID deaths and vaccinations — to derive insights such as infection and death rates, vaccination trends, and comparative analysis by location and continent.

---

## 📊 Key Analyses & Queries

### 1. **Initial Data Audit**

* Filters out non-country entries (e.g., aggregates) using `WHERE continent IS NOT NULL`
* Ensures analysis is location-specific and data-clean

### 2. **Case Fatality Analysis**

* Calculates death rate per total cases

  ```sql
  (total_deaths / total_cases) * 100 AS Death_Percentage
  ```

### 3. **Infection Penetration**

* Calculates what percentage of a country’s population has been infected

  ```sql
  (total_cases / population) * 100 AS InfectedPopulation %
  ```

### 4. **Top Countries by Impact**

* Identifies countries with:

  * Highest case rate per population
  * Highest total deaths
    Using `MAX()` and grouped statistics.

### 5. **Continent-Level Aggregation**

* Summarizes death toll per continent

  * Enables high-level geographic insights

### 6. **Global Daily Tracking**

* Aggregates global new cases and deaths by day
* Calculates global death percentage

### 7. **Vaccination Progress**

* Merges death and vaccination datasets via `JOIN`
* Uses window function:

  ```sql
  SUM(new_vaccinations) OVER (PARTITION BY location ORDER BY date)
  ```

  to compute a rolling count of vaccinated individuals

### 8. **Common Table Expression (CTE)**

* `WITH` clause to simplify rolling vaccination percentage calculation

### 9. **Temporary Table Usage**

* Stores intermediate results for later queries on vaccination vs population

### 10. **View Creation**

* Creates persistent SQL View `VaccincatedPopulationPercent` for use in external BI tools (e.g., Tableau, Power BI)

---

## 📁 Data Sources

* `coviddeath` – Cumulative and daily COVID cases and deaths per location
* `CovidsVacinations` – Daily vaccination data per location

> *Note:* Assumes both datasets are part of `SQLPortfolioProject.dbo` schema

---

## 🧠 Insights Generated

* Some countries had disproportionately high death-to-case ratios
* Developed countries showed faster vaccine rollouts but with varying penetration
* Continent-level death counts highlight global inequality in pandemic response
* Rolling vaccination trends offer a lens into the effectiveness of public health strategies

---

## 🛠️ Next Steps (Optional)

* Visualize the view in Tableau or Power BI
* Build dashboards on infection spread and vaccination coverage
* Integrate machine learning models for trend forecasting

---

## 💡 Author's Note

This project showcases my ability to handle relational datasets, perform multi-step transformations, and derive real-world insights using SQL — with a global and data-driven lens. I’m particularly interested in how data infrastructure supports public health outcomes in both developed and emerging economies.

---
