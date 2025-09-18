# 🚗 Car Showroom Analytics (SQL Project)

## 📌 Project Overview
This project explores **used car market insights** using **SQL queries**.  
The dataset contains over **8,000 cars across 2,000+ models**, with detailed attributes such as price, mileage, fuel type, transmission, year, and ownership.  
The goal is to answer **business-critical questions** for a car showroom, such as:
- Which cars perform best and worst?
- What are the trends in fuel, transmission, and ownership?
- Which models are most stable in value?
- What are the market sweet spots for pricing?

---

## ⚙️ Features & Analysis
The project delivers a **dashboard of statistics directly from SQL** (no visualization tools used).  
Key outputs include:

### ✅ Market Statistics
- Total cars, unique models, fuel, transmission, and seller types.
- Average, minimum, and maximum seats.
- Average year, oldest, and newest cars.
- Average selling price, cheapest, and most expensive cars.

### ✅ Performance Insights
- **Best performing car:** Volvo XC90 T8 Excellence BSIV (₹1 Cr).  
- **Worst performing car:** Maruti 800 AC (₹29,999).  
- **Most stable cars:** Ambassador series (0 price variation).  

### ✅ Fuel & Transmission Analysis
- Electric cars dominate with the **highest average price**.  
- Diesel cars average **₹7.9L**, petrol cars **₹4.6L**.  
- Automatic cars average **4x higher price** than manual.  

### ✅ Mileage & Usage
- **Top mileage car:** Volvo XC90 T8 Excellence BSIV (42 km/l).  
- **Workhorse model:** Maruti Swift Dzire VDI (94 lakh km driven).  
- Family-efficient cars like **Ertiga & KUV100** excel in >5 seats segment.  

### ✅ Sales & Price Trends
- Market sweet spot: cars within **±10% of average price (~₹6.4L)**.  
- **Luxury cars (Audi, BMW, Volvo)** show faster depreciation.  
- Cumulative sales show **Audi & BMW** as top contributors.

### ✅ Risk & Opportunity
- Cars above average price but below average mileage → **low value segment**.  
- Stable cars with low price variation → **safe investment choices**.  

---

## 📊 Example Queries
```sql
-- Best Performing Car
SELECT name, MAX(selling_price) AS max_price
FROM cars;

-- Fuel Type Price Distribution
SELECT fuel, ROUND(AVG(selling_price),2) AS avg_price
FROM cars
GROUP BY fuel
ORDER BY avg_price DESC;

-- Highest Mileage Cars
SELECT name, MAX(mileage) AS max_mileage
FROM cars
GROUP BY name
ORDER BY max_mileage DESC
LIMIT 5;
