# Insurance-Risk-Scorecard
Insurance Risk Scorecard built using SQL, Python, and Tableau. Includes data pipeline, risk scoring, NTILE tiers, and dashboard.


Below is the **final complete README.md** you can copy–paste **directly into GitHub**.

It is rewritten cleanly, professionally, and optimized for a **portfolio project**.
Just go to:

**Repo → README.md → Edit (pencil icon) → Paste → Commit.**

---

# ✅ **COPY–PASTE THIS ENTIRE README.md INTO GITHUB**

```markdown
# Insurance Risk Scorecard — SQL + Python + Tableau

This project builds an **Insurance Risk Scorecard** that ranks policies by risk based on **severity**, **frequency**, and **fraud probability**. It demonstrates an end-to-end analytics workflow combining **Python**, **MySQL**, and **Tableau**.  

The final output includes:
- A complete **risk score** for each policy  
- **Low / Medium / High** risk tiers (NTILE-based)  
- A Tableau dashboard with heatmaps, bar charts, and drilldowns  
- SQL scripts and a reproducible data pipeline

---

## 🎯 Project Objective

Insurance companies require a unified way to compare risks across millions of policies.  
This project answers:

> *“Which policies carry the highest expected risk and should be prioritized for pricing review, fraud investigation, or claims management?”*

The scorecard compresses three risk dimensions into a single `Final_Score`:

```

Final_Score = 0.4×Severity  +  0.3×Frequency  +  0.3×Fraud_Risk

```

Policies are then categorized into:
- **Tier 1 — Low Risk**
- **Tier 2 — Medium Risk**
- **Tier 3 — High Risk**

---

## 📁 Repository Structure

```

insurance-risk-scorecard/
├── README.md
├── data/
│   ├── policy_metrics.csv
│   ├── policy_risk_scores.csv
│   └── top100_high_risk.csv
├── notebook/
│   └── scoring.ipynb
├── sql/
│   ├── create_policy_metrics.sql
│   └── ntile_tiers.sql
├── dashboard/
│   └── screenshots/
│       ├── dashboard_full.png
│       ├── heatmap.png
│       └── top100_table.png

````

---

## 🧩 Data Pipeline Overview

### **1. Raw Data (freMTPL2 Motor Insurance Dataset)**  
Two CSVs were used:
- `freMTPL2freq.csv` — policy × claim frequency  
- `freMTPL2sev.csv` — policy × average claim severity  

### **2. Python Processing (Jupyter Notebook)**
Steps completed in `scoring.ipynb`:
- Load & merge both CSVs on `policy_id`  
- Fill missing values  
- Create a fraud indicator (1/0)  
- Min–max normalization  
- Compute `Severity_Score`, `Frequency_Score`, `Fraud_Score`  
- Compute weighted `Final_Score`  
- Create percentile-based risk tiers  
- Export:
  - `policy_metrics.csv`
  - `policy_risk_scores.csv`

### **3. SQL Processing (MySQL)**
SQL scripts located in `/sql` perform:

#### **3.1 Aggregation to one row per policy**
```sql
CREATE TABLE policy_metrics_agg AS
SELECT policy_id,
       SUM(frequency) AS frequency,
       AVG(severity) AS severity,
       MAX(is_fraud) AS is_fraud
FROM policy_metrics
GROUP BY policy_id;
````

#### **3.2 Normalized & Scoring Views**

`vw_policy_scores_agg` adds normalized fields.
`vw_risk_tiers_agg` adds `final_score`.

#### **3.3 NTILE(3) Tiers**

```sql
CREATE VIEW vw_tier_ntile_agg AS
SELECT *,
       NTILE(3) OVER (ORDER BY final_score) AS tier_bucket
FROM vw_risk_tiers_agg;
```

### **4. SQL Export of Top High-Risk Policies**

A command-line export retrieves the **top 100 highest-risk policies**:

```
top100_high_risk.csv
```

This is used in Tableau as a drill-down table.

---

## 📊 Tableau Dashboard

The Tableau dashboard consists of:

### **1. Risk Tier Heatmap**

* Rows: Segments or Tiers
* Columns: Regions or Tiers
* Color: Average Final Score
* Action filter → filters other sheets

### **2. Segment Risk Comparison (Bar Chart)**

Shows average final score per tier or per segment.

### **3. High-Risk Policy Drilldown**

A table built from `top100_high_risk.csv`:

* policy_id
* final_score
* severity
* frequency
* is_fraud

### **4. Dashboard Screenshot**

Screenshots of:

* `dashboard_full.png`
* `heatmap.png`
* `top100_table.png`

> If you publish on Tableau Public, add the link here.

---

## 📈 Key Insights (Example Findings)

* Most policies fall into **Low Risk**, but the top ~2–3% contribute disproportionately to severity.
* Policies with repeated claims (high frequency) show strong correlation with fraud indicators.
* Fraud-driven risk is highly concentrated — a small group of policies have both high severity and fraud likelihood.
* NTILE-based segmentation effectively separates risk clusters for Management reporting.

---

## 🚀 How to Reproduce the Project

### ** Run the Jupyter Notebook**

```
notebooks/scoring.ipynb
```

This will generate:

* `policy_metrics.csv`
* `policy_risk_scores.csv`

### ** Load data into MySQL (optional)**

Run:

```
sql/create_policy_metrics.sql
sql/ntile_tiers.sql
```

### ** Build Tableau Dashboard**

Use:

* `policy_risk_scores.csv`
* `top100_high_risk.csv`

---

## 🧰 Tools Used

| Layer           | Tool                     |
| --------------- | ------------------------ |
| Data Processing | Python, Pandas           |
| Storage / SQL   | MySQL                    |
| Visualization   | Tableau Public / Desktop |
| Environment     | Ubuntu, Jupyter Notebook |

---


## 🙋‍♂️ Author

Deepali Sharma
https://www.linkedin.com/in/deepali007

---

```
# END OF README
```
