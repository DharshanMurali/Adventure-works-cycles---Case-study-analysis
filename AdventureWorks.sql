create database Adventure_Works;
drop database Adventure_Works;
use Adventure_Works;
select * from DimCustomer;
select * from DimProduct;
select * from DimProductCategory;
select * from DimProductSubCategory;
select * from DimSalesterritory;
select * from Sales;

alter table DimCustomer rename column ï»¿CustomerKey to CustomerKey;
alter table DimProduct rename column ï»¿ProductKey to ProductKey;
alter table DimSalesterritory rename column ï»¿SalesTerritoryKey to SalesTerritoryKey;
alter table DimProductCategory rename column ï»¿ProductCategoryKey to ProductCategoryKey;
alter table DimProductSubCategory rename column ï»¿ProductSubcategoryKey to ProductSubcategoryKey;
alter table Sales rename column ï»¿ProductKey to ProductKey;

-- sales amount by year
SELECT Year, SUM(SalesAmount) AS 'Sales Amount', SUM(TotalProductCost) AS 'Total Product Cost' FROM `Sales` GROUP BY Year;

-- Total profit
SELECT ROUND((SUM(SalesAmount) - SUM(TotalProductCost)), 2) AS 'Total Profit' FROM sales;

-- year wise sales
SELECT 
    Year(Order_Date) AS Sales_Year,
    SUM(SalesAmount) AS TotalSalesAmount
FROM
    Sales
GROUP BY
    Year(Order_Date)
ORDER BY
    Sales_Year;

-- month wise sales
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month_Num,
    MONTHNAME(Order_Date) AS Month_Name,
    SUM(SalesAmount) AS Monthly_Sales
FROM
    Sales
GROUP BY
    Year, Month_Num, Month_Name, Order_Date
ORDER BY
    Year, Month_Num;

-- quarter wise sales
SELECT
    Year,
    Quarter,
    SUM(SalesAmount) AS TotalSales
FROM
    Sales
GROUP BY
    Year, Quarter
ORDER BY
    Year, Quarter;

SELECT
    Quarter,
    SUM(SalesAmount) AS TotalSales
FROM
    Sales
GROUP BY
    Quarter
ORDER BY
    Quarter;
    
-- count of productkey
SELECT COUNT(ProductKey) AS ProductCount
FROM Sales;

-- average yearly income
SELECT AVG(YearlyIncome) AS AverageIncome FROM DimCustomer;

-- count the number of english products in each category
SELECT EnglishProductName, COUNT(*) AS ProductCount
FROM DimProduct
GROUP BY EnglishProductName;

-- top 10 english products names
SELECT EnglishProductName
FROM DimProduct
ORDER BY EnglishProductName
LIMIT 10;

-- count the number of customers in each occupation
SELECT EnglishOccupation, COUNT(*) AS CustomerCount
FROM DimCustomer
GROUP BY EnglishOccupation;

-- average yearly income for english occupation
SELECT EnglishOccupation, AVG(YearlyIncome) AS AverageIncome
FROM Dimcustomer
GROUP BY EnglishOccupation;


-- total sales territory
SELECT SalesTerritoryRegion, COUNT(*) as TotalTerritories
FROM DimSalesterritory
GROUP BY SalesTerritoryRegion;


-- largest sales territory group
SELECT SalesTerritoryGroup
FROM DimSalesterritory
GROUP BY SalesTerritoryGroup
HAVING COUNT(*) = (SELECT MAX(TerritoryCount) FROM (SELECT COUNT(*) as TerritoryCount FROM DimSalesterritory GROUP BY SalesTerritoryGroup) AS Counts);

-- Average sales per customer
SELECT CONCAT(FirstName,' ', LastName) AS `Customer Name`, round(AVG(SalesAmount),1) as `Average Sales`
FROM DimCustomer as C
INNER JOIN Sales as S
ON C.CustomerKey = S.CustomerKey
GROUP BY CONCAT(FirstName,' ', LastName)
ORDER BY `Customer Name`;

-- Top 10 most sale product
SELECT EnglishProductName AS Product, EnglishProductCategoryName AS Category, 
EnglishProductSubcategoryName AS 'Product Subcategory',  ROUND(SUM(SalesAmount), 2) AS Sales 
FROM sales  
JOIN DimProduct USING (ProductKey)  
JOIN DimProductSubcategory USING (ProductSubcategoryKey) 
JOIN DimProductCategory USING (ProductCategoryKey) 
GROUP BY 1, 2, 3 
ORDER BY Sales DESC 
LIMIT 10;

-- Ranking of customers by sales
SELECT CONCAT(FirstName, ' ', LastName) as 'Customer Name', ROUND(SUM(SalesAmount), 2) AS 'Total Sales', 
    CASE 
        WHEN SUM(SalesAmount) > 10000 THEN 'Diamond'
        WHEN SUM(SalesAmount) BETWEEN 5000 AND 9999 THEN 'Gold'
        WHEN SUM(SalesAmount) BETWEEN 1000 AND 4999 THEN 'Silver'
        ELSE 'Bronze'
    END AS Ranking 
FROM Sales 
JOIN DimCustomer USING (CustomerKey) 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 0, 1000;






