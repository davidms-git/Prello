{% docs __overview__ %}

# 🏡 Prello – City Prioritisation Dashboard for Second-Home Investments

**Project Type**: Educational / Capstone (Data Analytics Bootcamp)  
**Team Lead**: David de la Mora
**Collaborators**: Paulina Marie Ekrod, Beliz Kuyumcuoglu, Louise Gilbert  
**Tools Used**: dbt, BigQuery, Python, Google Colab, Looker Studio, Power BI
**Looker Dashboard**: https://lookerstudio.google.com/reporting/f2bf0226-ddd6-4b6e-9d66-62d0fe224e5c
**GitHub repository**: https://github.com/davidms-git/Prello


> ⚠️ _Disclaimer_: This project is for educational purposes only and is not intended for commercial use or affiliated with Prello.

---

##  Project Summary

This project aims to build an intuitive and interactive dashboard to help **real estate managers** and **property hunters** prioritize which out of more than 30000 cities in France to target for real estate scouting. The prioritization is based on three data-driven **investor profiles**:

- Vacation Seeker
- Yield Investor
- Luxury Buyer

These profiles were identified using a combination of **KMeans clustering** and **domain expertise**, enabling us to model realistic investment behaviors based on city-level features.

---

##  Objectives

- Build a composite **City Opportunity Score** for ranking municipalities
- Identify investment clusters using **KMeans** unsupervised learning
- Support **investor persona-based** city recommendations
- Build an **interactive Looker Studio dashboard** for stakeholder insights

---

## How to Use the dbt Documentation

The dbt documentation interface allows you to explore the data pipeline behind this project.

- On the **left sidebar**, you'll see two main folders:
  - Under `sources`, look for the folder named **`prello_france`**, which contains the **raw source tables** used in the analysis.
  - Below that, you'll find another folder named **`prello_project`**, which contains the **transformation models**, including:
    - `staging` models (cleaning and renaming source fields)
    - `intermediate` models (data enrichment and joins)
    - `mart` models (final KPI and score outputs used for analysis)

- At the **bottom-right corner**, there’s a **"Lineage Graph"** button that opens an interactive view of the full data pipeline. You can visually explore how raw source tables are transformed through the different model layers and how they feed into the final dashboard outputs.

This documentation serves as a live, visual guide to understanding how data flows and is transformed across the project.

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

From these tables, we computed a set of **key performance indicators (KPIs)** per city:

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

Each KPI was **weighted differently** per investor profile:

- **Yield Investors** favor high `rental_yield` and low `vacancy_rate`
- **Vacation Seekers** prefer cities with high `poi_density` and `tourism_poi`
- **Luxury Buyers** prioritize `income`, `business_density`, and population scale

These weighted KPIs were used to compute **investor scores** per city.

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

## Dashboard & Visualization

The final dashboard was built in **Looker Studio**. Key features include:

- A dynamic **heatmap** showing the top 100 cities per investor type
- Global filters to toggle between **Yield**, **Vacation**, and **Luxury** scores
- The ability to explore scores for over **34,000 municipalities** in France

This tool is designed to support strategic decision-making for scouting real estate opportunities across the country.

**Looker Dashboard**: https://lookerstudio.google.com/reporting/f2bf0226-ddd6-4b6e-9d66-62d0fe224e5c

---

## ✅ Outcome

The project delivered a modular and scalable analytics solution that enables city ranking, investor matching, and cluster-based strategy for second-home acquisition. The entire pipeline was developed using dbt + BigQuery and visualized via Looker Studio.

{% enddocs %}