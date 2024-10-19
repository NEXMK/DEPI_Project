SELECT * FROM Superstore;
--Total Orders
SELECT 
	COUNT(*)AS Total_Orders 
FROM Superstore;

--Total Sales
SELECT
	SUM(Sales)AS Total_Sales
FROM Superstore;

--Query Total sales by Regions
SELECT 
    Region, 
    SUM(Sales) AS TotalSales
FROM Superstore
GROUP BY Region
ORDER BY TotalSales DESC;

--Total Sales by Product Name
SELECT Product_Name,SUM(Sales) AS Total_Sales
FROM Superstore
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

--Query AVG of Shipping Days
ALTER TABLE Superstore    --Create Table for Shipping days
ADD Shipping_By_Days INT

UPDATE Superstore --Count NO of Days for each row
SET Shipping_By_Days=DATEDIFF(DAY, Order_Date, Ship_Date);

SELECT --Now we can Count the average of Shipping by Days
	AVG(Shipping_By_Days)AS AVG_of_Shipping_Days
FROM Superstore;

--PAGE 2

--Analyze Total Sales By Segments
SELECT 
	Segment,
	SUM(Sales)AS TotalSales
FROM Superstore
GROUP BY Segment
ORDER BY TotalSales DESC;

--Query CLV
WITH CustomerSales AS (SELECT  -- هحسب اجمالي المبيعات الاول لكل عميل
        Customer_ID, 
        Customer_Name, 
        SUM(Sales) AS TotalSales,  
        COUNT(Order_ID) AS NumberOfOrders,  -- عدد الطلبات لكل عميل
        MIN(Order_Date) AS FirstOrderDate,  -- أول طلب للعميل
        MAX(Order_Date) AS LastOrderDate  -- آخر طلب للعميل
    FROM 
        Superstore  
    GROUP BY 
        Customer_ID, 
        Customer_Name),
CustomerLifetime AS (SELECT -- حاليا المفروض هحسب فتره بقاء العميل
        Customer_ID, 
        Customer_Name,
        TotalSales,
        NumberOfOrders,
        DATEDIFF(DAY, FirstOrderDate, LastOrderDate) AS CustomerLifetimeDays,  -- فتره بقاء العميل بالأيام
        DATEDIFF(YEAR, FirstOrderDate, LastOrderDate) AS CustomerLifetimeYears  -- فتره بقاء العميل بالسنوات
    FROM CustomerSales)
SELECT -- دلوقتي اقدر احسب CLV
    Customer_ID,
    Customer_Name,
    TotalSales AS CustomerLifetimeValue,  -- إجمالي قيمه العميل
    CustomerLifetimeYears,
    NumberOfOrders,
    CASE 
        WHEN CustomerLifetimeYears = 0 THEN TotalSales  -- إذا كانت الفتره اقل من سنه
        ELSE TotalSales / CustomerLifetimeYears  -- CLV السنوي
    END AS AnnualCLV FROM CustomerLifetime ORDER BY CustomerLifetimeValue DESC;  -- ترتيب العملاء حسب قيمه CLV

--Customer and Sales Summary by City
SELECT 
    City, 
    COUNT(DISTINCT [Customer_ID]) AS Total_Customers,  
    COUNT([Order_ID]) AS Total_Orders,  
    SUM([Sales]) AS Total_Sales  
FROM 
   Superstore  
GROUP BY City  
ORDER BY Total_Sales DESC;


--Total orders by Category and Sub_Category
SELECT 
    Category,  
    Sub_Category,  
    COUNT(Order_ID) AS Total_Orders 
FROM 
    Superstore  
GROUP BY 
    Category,  
    Sub_Category  
ORDER BY 
    Category,  
    Total_Orders DESC; 



    