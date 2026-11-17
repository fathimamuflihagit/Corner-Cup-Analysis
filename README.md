# ☕ The Corner Cup Coffee Chain: Store Performance Analysis

> **Group Work 1, Math59854: Statistics and Predictive Analytics for Decision-Making**
> Instructor: Susanna Spektor · Group 5 · November 2026

Twelve coffee shops, one owner, three big questions. Which shops should Maya grow? Which ones need help? Where should the next shop go?

This project answers those questions with data. We analysed the performance of all 12 Corner Cup shops using **three tools, each with its own job**: Excel for descriptive statistics, Python for visualisation and correlation, and R for regression and probability.

---

## 📌 At a Glance

| | |
|---|---|
| **Client** | Maya Chen, owner of The Corner Cup (7 urban + 5 suburban shops) |
| **Data** | 12 shops × 8 variables, no missing values |
| **Tools** | Microsoft Excel · Python (Google Colab) · R (RStudio) |
| **Deliverables** | Excel workbook · Jupyter notebook · R script · 11-page report |
| **Headline finding** | Foot traffic drives revenue. Daily customers explain **77%** of the revenue differences between shops |

---

## 👥 Team

| Member |
|---|
| Fathima Mufliha Kottaparamban |
| Aaliya Kaunain Mustafa Baig |
| Shubhangi Dubey |
| Shruti Chalke |
| Azra Lokhandwala |

---

## 📁 Repository Structure

```
.
├── CornerCup_Analysis.xlsx    # Part A: Excel (sheets A1, A2, A3 + raw data)
├── CornerCup_Python.ipynb     # Part B: Python notebook (charts + correlation)
├── CornerCup_R.R              # Part C: R script (regression + probability)
├── Group_Report.docx          # Final report with all results and recommendations
└── README.md                  # You are here
```

---

## 🗂️ The Data

Each row is one shop. Revenue is recorded in **thousands of dollars** (78.9 = $78,900).

| Variable | Type | Description |
|---|---|---|
| `Shop_Name` | Text | Name of the shop |
| `Location_Type` | Category | Urban or Suburban |
| `Floor_Size_sqft` | Number | Floor area in square feet |
| `Num_Staff` | Number | Number of employees |
| `Daily_Customers` | Number | Average customers per day |
| `Avg_Spend_per_Customer` | Number | Average spend per visit ($) |
| `Monthly_Revenue_000` | Number | Monthly revenue ($000) |
| `Customer_Satisfaction_Score` | Number | Average rating out of 5 |

---

## 🔍 What We Did

### Part A: Descriptive Statistics (Excel)
| Sheet | Task | Key functions |
|---|---|---|
| **A1** | Frequency distribution of location type + bar chart | `COUNTIF` |
| **A2** | Mean, median, SD, min, max (+ coefficient of variation) for 4 variables | `AVERAGE`, `MEDIAN`, `STDEV.S`, `MIN`, `MAX` |
| **A3** | Urban vs Suburban comparison + side-by-side chart + significance test | `AVERAGEIF`, `T.TEST`, `FILTER` |

### Part B: Visualisation & Correlation (Python)
| Section | Task | Output |
|---|---|---|
| **B1** | Load and explore the data | `head()`, `info()`, `describe()` |
| **B2** | Three visualisations | Histogram (6 bins), scatter plot by location, box plot |
| **B3** | Correlation analysis | Correlation matrix, heat map, ranked pairs |

### Part C: Regression & Probability (R)
| Section | Task | Method |
|---|---|---|
| **C1** | Predict revenue from daily customers | `lm()`, `summary()`, `predict()` |
| **C2 Q1** | Chance a shop earns over $80K | Empirical probability |
| **C2 Q2** | Success of 5 new suburban shops | Binomial (`dbinom`, `pbinom`) |
| **C2 Q3** | Airport Terminal customers per hour | Poisson (`dpois`, `ppois`) |

---

## 📊 Key Results

### The numbers that matter

| Measure | Result |
|---|---|
| Urban vs Suburban mean revenue | **$83.3K vs $54.9K** (gap not significant, t-test p = 0.071) |
| Correlation: daily customers ↔ revenue | **r = 0.877** (strongest revenue driver) |
| Regression equation | **Revenue = −2.785 + 0.276 × Daily Customers** |
| R² | **0.768**: customers explain about 77% of revenue differences |
| Predicted revenue at 300 customers/day | **$80,016 / month** (95% interval: $47.3K to $112.7K) |
| P(shop earns > $80K) | **4 / 12 = 33.3%** |
| 5 new shops (p = 0.40): expected successes | **2 shops**, P(at least 1) = **92.2%** |
| Airport Terminal: P(25+ customers in an hour) | **6.8%**, about 1.6 busy hours a day |

### Three findings in plain English

1. **Busy shops make the most money.** Every extra daily customer adds about **$276** to monthly revenue.
2. **City shops earn more, but only because they are busier.** Customers spend about the same ($8.84 vs $8.58) and are just as happy (4.04 vs 4.02) in both locations.
3. **Performance is uneven.** Revenue ranges from **$32.3K** (Eastgate Centre) to **$131K** (Harbour View), about four times as much.

---

## 💡 Recommendations for Maya

| # | Recommendation | Why |
|---|---|---|
| **1** | **Choose new sites by foot traffic**, not by the urban/suburban label | Traffic explains 77% of revenue; the urban advantage is not statistically significant |
| **2** | **Lift spend per customer at the Airport Terminal** and add peak-hour staff | Busiest shop, lowest spend ($6.90); +$1 per customer ≈ +$13,000/month |
| **3** | **Open new suburban shops in stages**, busiest sites first | Expect about 2 of 5 to succeed, with a 7.8% chance that none do |

---

## ▶️ How to Run

> **Before you start:** download the course data file **`GW1_CornerCup_Data.csv`**. The notebook and R script also accept `GW1_CornerCup_Data1.csv`.

### Excel (Part A)
1. Open `CornerCup_Analysis.xlsx`.
2. Go to sheets **A1**, **A2** and **A3**. All values are live formulas linked to the `Shop_Data` sheet.
3. The `FILTER` function in A3 needs **Excel 365 or Excel 2021+**.

### Python (Part B)
1. Open [Google Colab](https://colab.research.google.com) → **File → Upload notebook** → `CornerCup_Python.ipynb`.
2. Upload the CSV with the 📁 icon on the left.
3. **Runtime → Run all.** Charts are also saved to a `figures/` folder.

*Works in Jupyter too: `pip install pandas numpy matplotlib scipy`.*

### R (Part C)
1. Put `CornerCup_R.R` and the CSV in the **same folder**.
2. Open the script in RStudio → **Session → Set Working Directory → To Source File Location**.
3. Click **Source**. Results print in the Console; three charts are saved as PNG files.

*Uses base R only. No packages to install.*

---

## 🧰 Tools & Requirements

| Tool | Version used | Purpose |
|---|---|---|
| Microsoft Excel | Microsoft 365 | Descriptive statistics, charts, t-test |
| Python | 3.x (Google Colab) | pandas, NumPy, Matplotlib, SciPy |
| R | 4.6.1 (RStudio) | `lm()`, Binomial and Poisson functions |

---

## ⚠️ Limitations

- **Small sample.** Only 12 shops, so all results are estimates rather than certainties.
- **Correlation ≠ causation.** Regression and correlation show relationships, not proof of cause and effect.
- **Given assumptions.** The probability questions use values set by the brief (p = 0.40, λ = 18).

---

## 📝 Notes

- All three tools give matching results (for example, the Daily Customers mean of 269.08 and SD of 88.35 are the same in Excel and Python).
- The t-test in A3 goes slightly beyond the brief, to answer the question *"Are Urban shops significantly better?"*
- The data is a fictional case study provided for coursework.

---

<p align="center"><i>Made with ☕ by Group 5 · Statistics and Predictive Analytics for Decision-Making · 2026</i></p>
