# 👟 SneakerStore_DB — Data Warehouse Project

![Status](https://img.shields.io/badge/Status-Ongoing-brightgreen)
![Database](https://img.shields.io/badge/Database-SQL%20Server-blue)
![Schema](https://img.shields.io/badge/Schema-Star%20Schema-purple)
![Location](https://img.shields.io/badge/Market-South%20Africa-green)
![Data](https://img.shields.io/badge/Simulated%20Data-Yes-orange)

> A fully structured data warehouse for a South African sneaker retail business operating across **in-store**, **online**, and **delivery** channels — built on a star schema and designed for analytical querying and business intelligence reporting.

---

## 📌 Project Overview

**SneakerStore_DB** is an ongoing data warehousing project that models the sales operations of a multi-channel sneaker retailer based in South Africa. The project covers the full data pipeline from schema design through to simulated transactional data, and is being progressively expanded to include reporting queries, BI dashboards, and performance analytics.

The warehouse is built on a **star schema** — a widely adopted dimensional modelling approach that separates measurable business facts (sales transactions) from descriptive context (customers, products, stores, dates). This structure is optimised for fast analytical queries and intuitive reporting.

---

## 🏗️ Schema Design

### Star Schema Architecture

```
                        Dim_Date
                           |
   Dim_Product      Fact_Sales      Dim_Store
         \          /    |    \          /
          \        /     |     \        /
        Dim_Customer  Dim_Channel  Dim_Fulfilment
                           |
                     Dim_SalesPerson
```

The central **Fact_Sales** table records every sales transaction and links outward to seven dimension tables via foreign keys.

---

## 📂 Table Descriptions

### 🔵 Fact Table

#### `Fact_Sales`
The core of the warehouse. Each row represents a single line-item sale.

| Column | Type | Description |
|---|---|---|
| Sales_ID | INT | Primary key |
| Customer_ID | INT | FK → Dim_Customer |
| Date_ID | DATE | FK → Dim_Date |
| Store_ID | INT | FK → Dim_Store |
| Product_ID | INT | FK → Dim_Product |
| Channel_ID | INT | FK → Dim_Channel |
| Fulfilment_ID | INT | FK → Dim_Fulfilment |
| SalesPerson_ID | INT | FK → Dim_SalesPerson |
| Unit_Price | DECIMAL | Sale price in ZAR |
| Quantity | INT | Units sold |
| Discount | DECIMAL | Discount applied in ZAR |

---

### 🟣 Dimension Tables

#### `Dim_Customer`
Profiles of customers who have made purchases, including guest checkouts.

| Column | Description |
|---|---|
| Customer_ID | Primary key |
| Age | Customer age |
| Gender | Male / Female |
| Email | Contact email |
| Address | Physical address |

---

#### `Dim_Date`
A fully populated date dimension covering the 2024 calendar year, tailored for the South African market.

| Column | Description |
|---|---|
| Date_ID | Primary key (DATE) |
| Year / Month / Day | Calendar breakdowns |
| Is_Holiday | 1 if SA public holiday, 0 otherwise |
| Season | Southern hemisphere seasons (Summer, Autumn, Winter, Spring) |

> **SA Public Holidays included:** New Year's Day, Human Rights Day, Good Friday, Family Day, Freedom Day, Workers' Day, Election Day, Youth Day, National Women's Day, Heritage Day, Day of Reconciliation, Christmas Day, Day of Goodwill.

---

#### `Dim_Product`
The sneaker product catalogue with cost and retail pricing in ZAR.

| Column | Description |
|---|---|
| Product_ID | Primary key |
| Name | Model name (e.g. Air Max 90, Ultra Boost) |
| Brand | e.g. Nike, Adidas, New Balance, Jordan |
| Colourway | e.g. White/Black, Triple Black |
| Size | UK/US shoe size |
| Cost | Wholesale cost (ZAR) |
| Price | Retail price (ZAR) |

---

#### `Dim_Store`
All physical and virtual store locations — currently all based in South Africa.

| Column | Description |
|---|---|
| Store_ID | Primary key |
| Country | South Africa |
| Province | e.g. Gauteng, Western Cape, KwaZulu-Natal |
| City | e.g. Johannesburg, Cape Town, Durban |
| Zipcode | SA postal code |
| Store_Size | Floor area in square metres |

> **Current stores:** Johannesburg, Pretoria, Sandton, Cape Town, Durban, Port Elizabeth, Bloemfontein, Nelspruit.

---

#### `Dim_Channel`
How the order was placed by the customer.

| Channel | Device |
|---|---|
| In-store | — |
| Online | Desktop |
| Online | Mobile |
| App | Mobile |

---

#### `Dim_Fulfilment`
How the customer received their order. Independent of channel — an online order can result in either delivery or pickup.

| Method | Carrier |
|---|---|
| Walk-out | — |
| Delivery | The Courier Guy |
| Delivery | Aramex SA |
| Delivery | DHL Express |
| Pickup | — |

---

#### `Dim_SalesPerson`
Staff members who assisted with in-store and assisted-channel sales.

| Column | Description |
|---|---|
| SalesPerson_ID | Primary key |
| FullName | Staff member's full name |
| Commission_Rate | Commission percentage (decimal) |
| Hourly_Rate | Hourly wage in ZAR |
| Sales_Role | Associate / Senior Associate / Store Manager |

---

## 📁 Repository Structure

```
SneakerStore_DB/
│
├── schema/
│   └── sneaker_store_star_schema.sql     # CREATE TABLE statements for all tables
│
├── data/
│   ├── sneaker_full_inserts.sql          # INSERT statements — all tables in correct order
│   ├── sneaker_delete.sql                # DELETE statements — safe teardown order
│   └── csvs/
│       ├── Dim_Customer.csv
│       ├── Dim_Date.csv
│       ├── Dim_SalesPerson.csv
│       ├── Dim_Product.csv
│       ├── Dim_Store.csv
│       ├── Dim_Channel.csv
│       ├── Dim_Fulfilment.csv
│       └── Fact_Sales.csv
│
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- Microsoft SQL Server (2016 or later recommended)
- SQL Server Management Studio (SSMS) or Azure Data Studio

### Setup Instructions

**1. Create the database**
```sql
CREATE DATABASE SneakerStore_DB;
USE SneakerStore_DB;
```

**2. Run the schema script**
```
Execute: schema/sneaker_store_star_schema.sql
```
This creates all 7 dimension tables and the fact table with their constraints and foreign keys.

**3. Load the data**
```
Execute: data/sneaker_full_inserts.sql
```
Inserts all dimension data first, then the fact table — run the full script in one go.

**4. To reset and reload**
```
Execute: data/sneaker_delete.sql   -- clears all tables in safe order
Execute: data/sneaker_full_inserts.sql  -- reloads everything fresh
```

> ⚠️ Always run the delete script before re-inserting to avoid primary key conflicts. `Fact_Sales` must always be deleted before the dimension tables.

---

## 📊 Sample Analytical Queries

Once loaded, the schema supports queries such as:

```sql
-- Total revenue by store
SELECT s.City, SUM(f.Unit_Price * f.Quantity - f.Discount) AS Net_Revenue
FROM Fact_Sales f
JOIN Dim_Store s ON f.Store_ID = s.Store_ID
GROUP BY s.City
ORDER BY Net_Revenue DESC;

-- Sales by channel and fulfilment method
SELECT c.Type AS Channel, fu.Method AS Fulfilment, COUNT(*) AS Transactions
FROM Fact_Sales f
JOIN Dim_Channel c    ON f.Channel_ID    = c.Channel_ID
JOIN Dim_Fulfilment fu ON f.Fulfilment_ID = fu.Fulfilment_ID
GROUP BY c.Type, fu.Method;

-- Top performing salesperson by revenue
SELECT sp.FullName, sp.Sales_Role,
       SUM(f.Unit_Price * f.Quantity) AS Gross_Revenue
FROM Fact_Sales f
JOIN Dim_SalesPerson sp ON f.SalesPerson_ID = sp.SalesPerson_ID
GROUP BY sp.FullName, sp.Sales_Role
ORDER BY Gross_Revenue DESC;

-- Sales on SA public holidays vs regular days
SELECT d.Is_Holiday,
       COUNT(*) AS Transactions,
       SUM(f.Unit_Price * f.Quantity) AS Total_Revenue
FROM Fact_Sales f
JOIN Dim_Date d ON f.Date_ID = d.Date_ID
GROUP BY d.Is_Holiday;
```

---

## 🔄 Project Roadmap

This is an **ongoing project** actively being developed. Planned additions include:

- [ ] Stored procedures for common reporting queries
- [ ] Views for pre-aggregated KPIs (monthly revenue, top products, store performance)
- [ ] Power BI / Tableau dashboard connected to the warehouse
- [ ] Expanded product catalogue with real SA sneaker retail pricing
- [ ] Customer segmentation analysis (RFM — Recency, Frequency, Monetary)
- [ ] Inventory dimension (`Dim_Inventory`) to track stock levels per store
- [ ] Returns and refunds fact table (`Fact_Returns`)
- [ ] Expanding to additional South African cities and store locations
- [ ] Performance indexing and query optimisation documentation

---

## 🌍 Data Context

All simulated data is localised to **South Africa**:
- Customer names reflect SA's multicultural demographics (Zulu, Xhosa, Sotho, Afrikaans, Indian, Cape Malay)
- Prices are in **ZAR (South African Rand)**
- Seasons follow the **southern hemisphere calendar**
- Public holidays follow the **official SA 2024 calendar**
- Delivery carriers are SA-based: The Courier Guy, Aramex SA, DHL Express
- Store locations span major SA metros across Gauteng, Western Cape, KwaZulu-Natal, Eastern Cape, Free State, and Mpumalanga

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Microsoft SQL Server | Database engine |
| SSMS / Azure Data Studio | Query execution and management |
| Python | Simulated data generation |
| Git / GitHub | Version control |

---

## 📝 Notes on Schema Design

- **Channel vs Fulfilment are separate dimensions** — a customer can order online and choose either delivery or in-store pickup. These are independent axes and keeping them separate avoids data redundancy and allows cleaner cross-channel analysis.
- **`SalesPerson_ID` is NOT NULL** — all transactions are attributed to a staff member. Online transactions are assigned to a designated online team member.
- **`Dim_Date` uses southern hemisphere seasons** — Summer spans December–February, Winter spans June–August, aligning with the SA climate calendar.
- **Star schema was chosen over snowflake** — to prioritise query simplicity and BI tool compatibility. All dimensions are flat with no child dimension tables.

---

## 👤 Author

> Project by [Remofilwe Mamabolo]
> Built as part of a data warehousing and business intelligence learning journey.
> Contributions, suggestions, and feedback welcome — feel free to open an issue or pull request.

---

*This project is ongoing. Star the repo to follow along as new features are added.* ⭐
