# 🏡 Prello – City Prioritisation Dashboard for Second-Home Investments

**Capstone Project – Data Analytics Bootcamp**  
**Team Lead**: David de la Mora 
**Collaborators**: Paulina Marie Ekrod, Beliz Kuyumcuoglu, Louise Gilbert  
**Tools**: Python, BigQuery, dbt, Google Colab, Looker Studio, Power BI, Scikit-Learn

> ⚠️ *Disclaimer*: This project was developed solely for educational purposes and is not intended for commercial use or affiliated with Prello.

---

##  Project Overview

We developed a data-driven City Prioritisation Dashboard to support Prello’s expansion strategy into the French second-home market. By integrating real estate, socio-economic, and tourism KPIs, we ranked 300+ municipalities and built a scoring model tailored to different investor personas.  

**David de la Mora** led the project coordination, KPI selection, clustering model development, and Looker dashboard planning.

---

##  Objectives

- Rank municipalities using a custom **City Opportunity Score**
- Support city recommendations for **three investor personas**
- Build interactive dashboards for business users
- Use **KMeans Clustering** to segment cities by investment potential

---

##  Data Exploration & EDA

- Conducted descriptive stats in Google Colab on a joined BigQuery export  
- Audited nulls, outliers, and distributions  
- Visualized histograms and KPI correlations  
- Sample size: 30.000+ municipalities  
- Guided data cleaning and normalization strategy

---

##  KPIs Used

| KPI | Description |
|-----|-------------|
| `rental_yield` | ROI proxy from median rent / price per m² |
| `establishment_score` | Weighted count of tourism-related businesses |
| `poi_density` | POI count normalized by population |
| `housing_stress_index` | Indicates local housing demand tension |
| `second_home_ratio` | % of second homes in housing stock |
| `vacancy_rate` | % of empty housing units |
| `population_growth` | 5-year growth from INSEE |
| `sales_price_m2` | Median real estate price |
| `avg_net_salary` | Excluded from scoring (missingness) |

KPIs were **normalized**, cleaned, and analyzed for redundancy and correlation before modeling.

---

##  Clustering Model (Google Colab)

- Used `StandardScaler` + `KMeans` (n=4)  
- Elbow method used to determine optimal clusters  
- Segment labels:
  - 🟣 Affluent Urban Growth
  - 🔵 Tourist Zones, Past Peak
  - 🟢 Balanced Local Towns *(not considered in dashboard scoring due to limited second-home interest)*
  - 🟠 High-Yield, Declining Areas  
- Visualized clusters with Plotly and seaborn

---

##  Dashboard (Looker Studio)

- City heatmap with Opportunity Score  
- Persona-based recommendation filters  
- Interactive KPI comparisons  
- Exportable ranking tables  

---

##  Datasets Used (BigQuery)

- `real_estate_info_by_municipality`
- `housing_stock`
- `POI_tourist_establishments`
- `POI_touristic_sites_by_municipality`
- `Intensite_tension_immo`
- `Population_by_municipality`
- `average_salary_by_municipality`

---

##  Team Roles

| Member | Responsibilities |
|--------|------------------|
| **David (Lead)** | EDA, KPI framework, clustering, model pipeline, coordination |
| Paulina Marie Ekrod | POI metrics, dashboard UI |
| Beliz Kuyumcuoglu | Real estate KPIs, scoring logic |
| Louise Gilbert | Data sourcing, report insights |

---

##  License / Disclaimer

This project was built as part of a 9-week bootcamp and is intended solely for **educational** purposes. It is not for commercial use or distribution.

