# Sales Data Warehouse & Mining Project

This project demonstrates the end-to-end process of building a data warehouse using Snowflake and performing data mining tasks with Python.

## 📊 Project Overview

A comprehensive data analysis solution was implemented based on a retail dataset of 9,994 records across 28 features. This includes:

- Data cleaning and preprocessing
- Star schema data warehouse design and implementation in Snowflake
- Data mining tasks using machine learning models
- Power BI dashboard for data visualization

---

## 🧾 Dataset Description

The dataset includes attributes such as:

- OrderDate, ShipDate, Category, Sub_Category, Sales, Profit, Quantity, Discount
- CustomerName, Segment, Region, City, State, Country, Latitude, Longitude
- OrderID, PostalCode, ShipMode, ShipStatus
- Sales Forecast, Profit Ratio, Days to Ship, Order Profitability, etc.

---

## 🛠️ Implementation Steps

### 1. Data Preprocessing
Performed in Google Colab. The cleaned dataset is available in `df_cleaned.csv`.

🔗 [Colab Notebook - Data Cleaning](https://colab.research.google.com/drive/1bGq3R-qnbQyDfj-8lw8_BIp-OUWgYFgg?usp=sharing)

### 2. Schema Design
A **Star Schema** was selected for better performance and dimensional analysis.
![image](https://github.com/user-attachments/assets/723bc125-f2cb-4c31-bc11-95b8700194ac)


#### Star Schema Includes:
- **FactSales** (central fact table)
- **DimCustomer**
- **DimProduct**
- **DimDate**
- **DimShipping**
- **DimLocation**

### 3. Data Warehouse in Snowflake
- Created staging and star schema tables
- Loaded cleaned data from CSV
- Inserted data using SQL transformations and joins

### 4. Data Mining Tasks

Executed in Python using `scikit-learn` and `matplotlib`. Included:

- 📦 **Shipment Status Prediction**
- 📈 **Sales Forecasting**
- 💰 **Order Profitability Prediction**
- 🧠 **Customer Clustering**

📘 Notebook: `Project_Data_Mining.ipynb`

---

## 📊 Visualization

A Power BI dashboard was created to provide interactive data insights.

🔗 [Power BI Dashboard (Org Access Required)](https://app.powerbi.com/links/_T0yPQXjdH?ctid=aa232db2-7a78-4414-a529-33db9124cba7)
![image](https://github.com/user-attachments/assets/8e497438-510a-428b-a596-3359b8235c58)


---


