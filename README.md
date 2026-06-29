# Flipkart Logistics SQL Analytics

## Project Overview

This project analyzes Flipkart's logistics operations using SQL to identify delivery bottlenecks, optimize transportation routes, evaluate warehouse efficiency, measure delivery agent performance, and generate business-focused operational insights.

The analysis simulates real-world logistics analytics performed by operations and supply chain teams to improve delivery performance and customer satisfaction.

---

## Business Problem

As order volumes continue to increase across India, logistics operations become increasingly complex.

The business needed answers to questions such as:

- Which delivery routes experience the highest delays?
- Which warehouses are causing shipment bottlenecks?
- Are delivery delays caused by agents or by operational issues?
- What are the major causes of shipment delays?
- Which regions require operational improvements?
- How can delivery efficiency be improved using data?

---

## Objectives

- Perform logistics data cleaning and validation
- Analyze delivery delays across routes
- Measure route efficiency
- Evaluate warehouse performance
- Analyze delivery agent productivity
- Track shipment movements
- Generate operational KPIs
- Recommend improvements for logistics optimization

---

## Dataset

The project uses five relational datasets:

- Orders
- Routes
- Warehouses
- Delivery Agents
- Shipment Tracking

The datasets were analyzed using SQL joins, aggregations, Common Table Expressions (CTEs), window functions, subqueries, and analytical queries.

---

## Tools & Technologies

- SQL (MySQL)
- Microsoft Excel
- Relational Database Concepts

---

## SQL Concepts Used

- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- CASE Statements
- Aggregate Functions
- Window Functions
- ROW_NUMBER()
- RANK()
- Common Table Expressions (CTEs)
- Subqueries
- Date Functions
- Conditional Logic

---

# Project Workflow

### 1. Data Cleaning

- Duplicate detection
- Null value validation
- Date validation
- Delivery date consistency checks

---

### 2. Delivery Delay Analysis

- Delay calculation per order
- Top delayed routes
- Warehouse delay ranking
- Delay trend analysis

---

### 3. Route Optimization

- Route efficiency calculation
- Distance-to-time ratio
- Worst-performing routes
- Delay percentage analysis
- Route optimization recommendations

---

### 4. Warehouse Performance

- Processing time analysis
- Delayed shipment comparison
- Warehouse bottleneck detection
- On-time delivery ranking

---

### 5. Delivery Agent Analysis

- Agent ranking
- Underperforming agents
- Speed comparison
- Workload balancing recommendations

---

### 6. Shipment Tracking

- Latest shipment checkpoints
- Delay reason analysis
- Multi-stage shipment disruptions

---

### 7. KPI Dashboard

Generated operational KPIs including:

- Average Delivery Delay
- Route Efficiency
- On-Time Delivery Percentage
- Warehouse Performance
- Regional Delay Analysis
- Traffic Delay Analysis

---

# Key Findings

- Overall on-time delivery rate was **72.67%**, below the industry benchmark of 85–90%.
- Route **RT_13** showed the highest average delay, lowest efficiency ratio, and highest delay percentage.
- **WH_10 (Chennai)** was identified as the largest warehouse bottleneck due to high processing times.
- Nearly **40%** of shipments experienced delays at more than two checkpoints.
- Traffic congestion accounted for over half of all shipment delays.
- Delivery delays were influenced more by route conditions and operational bottlenecks than by delivery agent speed.

---

# Business Recommendations

- Redesign high-delay delivery routes.
- Improve warehouse processing efficiency.
- Implement dynamic route optimization.
- Redistribute delivery agents based on route congestion.
- Monitor high-risk routes using KPI dashboards.
- Improve shipment tracking for proactive delay management.

---

# Skills Demonstrated

- SQL
- Relational Database Design
- Data Cleaning
- Data Validation
- Business Analytics
- Logistics Analytics
- KPI Reporting
- Window Functions
- CTEs
- Performance Analysis
- Supply Chain Analytics
- Operational Reporting

---

## Repository Structure

```text
logistics-optimization-analysis/
│
├── data/
│   ├── Flipkart_DeliveryAgents.xlsx
│   ├── Flipkart_Orders.xlsx
│   ├── Flipkart_Routes.xlsx
│   ├── Flipkart_ShipmentTracking.xlsx
│   └── Flipkart_Warehouses.xlsx
│
├── docs/
│   ├── Presentation_Report.pptx
│   ├── Project_Objective.pdf
│   └── problem_Statement.pdf
│
├── images/
│   ├── Top3_worst_efficiency_routes.png
│   ├── Top5_vs_bottom5_performing_agents.png
│   ├── most_common_delay_reason.png
│   ├── on-time_delivery_percentage.png
│   ├── top10_delayed_routes.png
│   └── total_vs_delayed_shipments.png
│
├── solution/
│   └── Logistics_Optimization_Analysis.sql
│
└── README.md
```

---

# Project Outcome

This project demonstrates how SQL can be applied to solve real-world logistics and supply chain challenges by transforming raw operational data into actionable business insights. Through advanced querying techniques and KPI reporting, the analysis identifies delivery inefficiencies, operational bottlenecks, and opportunities to improve customer satisfaction and overall logistics performance.

---

## Author

**Ananthakrishna Nair**

