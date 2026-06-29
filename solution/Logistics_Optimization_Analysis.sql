# TASK 1: Data Cleaning & Preparation

-- Task 1.1: Identify and Delete Duplicate Records
SELECT Order_ID, COUNT(*) AS occurrence_count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Task 1.2: Replace NULL Traffic_Delay_Min with Route Average
-- Step 1: Check for NULLs
SELECT Route_ID, Traffic_Delay_Min
FROM Routes
WHERE Traffic_Delay_Min IS NULL;
-- Step 2: Replace NULLs with average ( the data has none, but still doing the update)
UPDATE Routes r
JOIN (
    SELECT Route_ID, AVG(Traffic_Delay_Min) AS avg_delay
    FROM Routes
    WHERE Traffic_Delay_Min IS NOT NULL
    GROUP BY Route_ID
) AS avg_table ON r.Route_ID = avg_table.Route_ID
SET r.Traffic_Delay_Min = avg_table.avg_delay
WHERE r.Traffic_Delay_Min IS NULL;

-- Task 1.3: Checking for the correct data format
SELECT 
    Order_ID,
    DATE_FORMAT(Order_Date, '%Y-%m-%d') AS Order_Date,
    DATE_FORMAT(Expected_Delivery_Date, '%Y-%m-%d') AS Expected_Delivery_Date,
    DATE_FORMAT(Actual_Delivery_Date, '%Y-%m-%d') AS Actual_Delivery_Date
FROM Orders
LIMIT 10;

-- Task 1.4: Flaging Records Where Actual_Delivery_Date is Before Order_Date
SELECT 
    Order_ID,
    Order_Date,
    Actual_Delivery_Date,
    'Invalid: Delivered Before Ordered' AS Flag
FROM Orders
WHERE Actual_Delivery_Date < Order_Date;

#TASK 2: Delivery Delay Analysis

-- Task 2.1: Calculate Delivery Delay for Each Order
SELECT 
    Order_ID,
    Warehouse_ID,
    Route_ID,
    Order_Date,
    Expected_Delivery_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date,
            Expected_Delivery_Date) AS Delay_Days
FROM
    Orders
ORDER BY Delay_Days DESC;

-- Task 2.2: Top 10 Delayed Routes Based on Average Delay Days
SELECT 
    Route_ID,
    ROUND(AVG(DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)), 2) AS Avg_Delay_Days
FROM Orders
GROUP BY Route_ID
ORDER BY Avg_Delay_Days DESC
LIMIT 10;

-- Task 2.3: Rank All Orders by Delay Within Each Warehouse (Window Function)
SELECT 
    Order_ID,
    Warehouse_ID,
    Route_ID,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Delay_Days,
    RANK() OVER (
        PARTITION BY Warehouse_ID 
        ORDER BY DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) DESC
    ) AS Delay_Rank
FROM Orders
ORDER BY Warehouse_ID, Delay_Rank;

# TASK 3: Route Optimization Insights

-- Task 3.1: Per-Route Metrics: Avg Delivery Time, Avg Traffic Delay & Efficiency Ratio
SELECT 
    o.Route_ID,
    ROUND(AVG(DATEDIFF(o.Actual_Delivery_Date, o.Order_Date)), 2) AS Avg_Delivery_Time_Days,
    ROUND(AVG(rt.Traffic_Delay_Min), 2) AS Avg_Traffic_Delay_Min,
    ROUND(rt.Distance_KM / rt.Average_Travel_Time_Min, 4) AS Efficiency_Ratio
FROM Orders o
JOIN Routes rt ON o.Route_ID = rt.Route_ID
GROUP BY o.Route_ID, rt.Distance_KM, rt.Average_Travel_Time_Min
ORDER BY Efficiency_Ratio ASC;

-- Task 3.2: Identify 3 Routes with the Worst Efficiency Ratio
SELECT 
    o.Route_ID,
    ROUND(AVG(DATEDIFF(o.Actual_Delivery_Date, o.Order_Date)), 2) AS Avg_Delivery_Time_Days,
    ROUND(AVG(rt.Traffic_Delay_Min), 2) AS Avg_Traffic_Delay_Min,
    ROUND(rt.Distance_KM / rt.Average_Travel_Time_Min, 4) AS Efficiency_Ratio
FROM Orders o
JOIN Routes rt ON o.Route_ID = rt.Route_ID
GROUP BY o.Route_ID, rt.Distance_KM, rt.Average_Travel_Time_Min
ORDER BY Efficiency_Ratio ASC
LIMIT 3;

-- Task 3.3 Routes with More Than 20% Delayed Shipments
SELECT 
    Route_ID,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Actual_Delivery_Date > Expected_Delivery_Date THEN 1 ELSE 0 END) AS Delayed_Orders,
    ROUND(
        100.0 * SUM(CASE WHEN Actual_Delivery_Date > Expected_Delivery_Date THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS Delay_Percentage
FROM Orders
GROUP BY Route_ID
HAVING Delay_Percentage > 20
ORDER BY Delay_Percentage DESC;

# TASK 4: Warehouse Performance

-- Task 4.1: Top 3 Warehouses with Highest Average Processing Time
SELECT 
    Warehouse_ID,
    Warehouse_Name,
    City,
    Average_Processing_Time_Min
FROM Warehouses
ORDER BY Average_Processing_Time_Min DESC
LIMIT 3;

-- Task 4.2: Total vs. Delayed Shipments for Each Warehouse
SELECT 
    o.Warehouse_ID,
    COUNT(*) AS Total_Shipments,
    SUM(CASE WHEN Actual_Delivery_Date > Expected_Delivery_Date THEN 1 ELSE 0 END) AS Delayed_Shipments,
    COUNT(*) - SUM(CASE WHEN Actual_Delivery_Date > Expected_Delivery_Date THEN 1 ELSE 0 END) AS OnTime_Shipments
FROM Orders o
GROUP BY o.Warehouse_ID
ORDER BY Delayed_Shipments DESC;

-- Task 4.3: CTE to Find Bottleneck Warehouses (Processing Time > Global Average)
WITH GlobalAvg AS (
    SELECT AVG(Average_Processing_Time_Min) AS Avg_Processing_Time
    FROM Warehouses
)
SELECT 
    w.Warehouse_ID,
    w.Warehouse_Name,
    w.City,
    w.Average_Processing_Time_Min,
    ROUND(g.Avg_Processing_Time, 2) AS Global_Avg_Processing_Time
FROM Warehouses w, GlobalAvg g
WHERE w.Average_Processing_Time_Min > g.Avg_Processing_Time
ORDER BY w.Average_Processing_Time_Min DESC;

-- Task 4.2: Ranking Warehouses by On-Time Delivery Percentage
SELECT 
    o.Warehouse_ID,
    COUNT(*) AS Total_Shipments,
    SUM(CASE WHEN Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) AS OnTime_Shipments,
    ROUND(
        100.0 * SUM(CASE WHEN Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS OnTime_Pct,
    RANK() OVER (
        ORDER BY ROUND(
            100.0 * SUM(CASE WHEN Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) 
            / COUNT(*), 2
        ) DESC
    ) AS Warehouse_Rank
FROM Orders o
GROUP BY o.Warehouse_ID
ORDER BY Warehouse_Rank;

# TASK 5: Delivery Agent Performance

-- Task 5.1: Rank Agents (Per Route) by On-Time Delivery Percentage
SELECT 
    Agent_ID,
    Agent_Name,
    Route_ID,
    On_Time_Delivery_Percentage,
    RANK() OVER (
        PARTITION BY Route_ID 
        ORDER BY On_Time_Delivery_Percentage DESC
    ) AS Route_Rank
FROM DeliveryAgents
ORDER BY Route_ID, Route_Rank;

-- Task 5.2: Find Agents with On-Time Delivery percentage < 80%
SELECT 
    Agent_ID,
    Agent_Name,
    Route_ID,
    On_Time_Delivery_Percentage,
    Avg_Speed_KMPH,
    Experience_Years
FROM DeliveryAgents
WHERE On_Time_Delivery_Percentage < 80
ORDER BY On_Time_Delivery_Percentage ASC;

-- Task 5.3: Comparing the Avg Speed of Top 5 vs Bottom 5 Agents (Subquery
SELECT 
    (SELECT ROUND(AVG(Avg_Speed_KMPH), 2)
     FROM (
         SELECT Avg_Speed_KMPH 
         FROM DeliveryAgents 
         ORDER BY On_Time_Delivery_Percentage DESC 
         LIMIT 5
     ) AS top5
    ) AS Top5_Avg_Speed_KMPH,

    (SELECT ROUND(AVG(Avg_Speed_KMPH), 2)
     FROM (
         SELECT Avg_Speed_KMPH 
         FROM DeliveryAgents 
         ORDER BY On_Time_Delivery_Percentage ASC 
         LIMIT 5
     ) AS bottom5
    ) AS Bottom5_Avg_Speed_KMPH;

# TASK 6: Shipment Tracking Analytics

-- Task 6.1: Last Checkpoint and Time for Each Order
SELECT 
    Order_ID,
    Checkpoint,
    Checkpoint_Time
FROM ShipmentTracking
WHERE (Order_ID, Checkpoint_Time) IN (
    SELECT Order_ID, MAX(Checkpoint_Time)
    FROM ShipmentTracking
    GROUP BY Order_ID
)
ORDER BY Order_ID;

-- Task 6.2: Most Common Delay Reasons (Excluding None)
SELECT 
    Delay_Reason,
    COUNT(*) AS Frequency
FROM ShipmentTracking
WHERE Delay_Reason IS NOT NULL 
  AND Delay_Reason != 'None'
GROUP BY Delay_Reason
ORDER BY Frequency DESC;

-- Task 6.3: Identifying Orders with More Than 2 Delayed Checkpoints
SELECT 
    Order_ID,
    COUNT(*) AS Delayed_Checkpoints
FROM ShipmentTracking
WHERE Delay_Minutes > 0
GROUP BY Order_ID
HAVING Delayed_Checkpoints > 2
ORDER BY Delayed_Checkpoints DESC;

# TASK 7: Advanced KPI Reporting

-- Task 7.1: Average Delivery Delay per Region based on Start_Location 
SELECT 
    rt.Start_Location AS Region,
    COUNT(o.Order_ID) AS Total_Orders,
    ROUND(AVG(DATEDIFF(o.Actual_Delivery_Date, o.Expected_Delivery_Date)), 2) AS Avg_Delivery_Delay_Days
FROM Orders o
JOIN Routes rt ON o.Route_ID = rt.Route_ID
GROUP BY rt.Start_Location
ORDER BY Avg_Delivery_Delay_Days DESC;

-- Task 7.2: Overall On-Time Delivery Percentage
SELECT 
    COUNT(*) AS Total_Deliveries,
    SUM(CASE WHEN Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) AS OnTime_Deliveries,
    ROUND(
        100.0 * SUM(CASE WHEN Actual_Delivery_Date <= Expected_Delivery_Date THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS OnTime_Delivery_Pct
FROM Orders;

-- Task 7.3: Average Traffic Delay per Route
SELECT 
    Route_ID,
    Start_Location,
    End_Location,
    Traffic_Delay_Min AS Avg_Traffic_Delay_Min
FROM Routes
ORDER BY Traffic_Delay_Min DESC;

