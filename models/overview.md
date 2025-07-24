{% docs __overview__ %}

# 🏡 Prello – City Prioritisation Dashboard for Second-Home Investments

**Project Type**: Educational / Capstone (Data Analytics Bootcamp)  
**Team Lead**: David de la Mora
**Collaborators**: Paulina Marie Ekrod, Beliz Kuyumcuoglu, Louise Gilbert  
**Tools Used**: dbt, BigQuery, Python, Google Colab, Looker Studio, Power BI

> ⚠️ _Disclaimer_: This project is for educational purposes only and is not intended for commercial use or affiliated with Prello.

---

##  Project Summary

This project supports a hypothetical use case for Prello, a second-home property startup. We developed a model to prioritize over 300 French municipalities for second-home investment, combining real estate, tourism, and socio-economic KPIs. The final deliverables included a city scoring model, clustering analysis, and an interactive dashboard to assist Prello’s property hunters in matching cities to investor personas.

---

##  Objectives

- Build a composite **City Opportunity Score** for ranking municipalities
- Identify investment clusters using **KMeans** unsupervised learning
- Support **investor persona-based** city recommendations
- Build an **interactive Looker Studio dashboard** for stakeholder insights

---

##  Key Datasets Used (modeled via dbt)

- `real_estate_info_by_municipality`
- `housing_stock`
- `POI_tourist_establishments`
- `POI_touristic_sites_by_municipality`
- `Intensite_tension_immo`
- `Population_by_municipality`
- `average_salary_by_municipality`

These tables were joined and transformed into the final dataset:  
**`mart_prello_france_joined_kpis_city_normalized_final_version`**

---

##  KPI Definitions

| KPI | Description |
|-----|-------------|
| `rental_yield` | Median rent / price per m² (investment ROI proxy) |
| `establishment_score` | Weighted score of tourism-related businesses |
| `poi_density` | POI count per capita or area |
| `housing_stress_index` | Normalized government index indicating local demand |
| `second_home_ratio` | % of second homes out of total housing |
| `vacancy_rate` | % of vacant housing units |
| `population_growth` | 5-year growth trend |
| `sales_price_m2` | Median real estate sale price |
| `avg_net_salary` | Average net income per municipality (excluded from score) |

All KPIs were normalized and analyzed for missing values, correlation, and outlier handling.

---

##  Clustering Summary

- Used `StandardScaler` and `KMeans` with 4 clusters
- Cluster labels:
  - 🟣 Affluent Urban Growth
  - 🔵 Tourist Zones, Past Peak
  - 🟢 Balanced Local Towns *(excluded from scoring; low second-home relevance)*
  - 🟠 High-Yield, Declining Areas

Clustering informed strategic segmentation and persona-aligned recommendations.

---

##  Dashboard & Output

- Persona filters for Vacation Seeker, ROI Investor, and Luxury Buyer
- Ranked city recommendations with scoring breakdowns
- Interactive Looker Studio dashboard connected to BigQuery
- Exportable insights for stakeholder use

---

##  Team Roles

| Name | Contribution |
|------|--------------|
| **David (Lead)** | KPI framework, clustering, model pipeline, dashboard strategy |
| Paulina | POI and tourism metrics, dashboard UI |
| Beliz | Rental yield, real estate indicators |
| Louise | Data sourcing, documentation, second-home analysis |

---

## ✅ Outcome

The project delivered a modular and scalable analytics solution that enables city ranking, investor matching, and cluster-based strategy for second-home acquisition. The entire pipeline was developed using dbt + BigQuery and visualized via Looker Studio.


{% enddocs %}