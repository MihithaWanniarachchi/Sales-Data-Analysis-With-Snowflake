USE SALES_DB;

CREATE SCHEMA IF NOT EXISTS STARSCHEMA;
USE SCHEMA STARSCHEMA;


----------------------------------- Creating Dimension Tables-------------------------------------------
-- Creating DimDate
CREATE OR REPLACE TABLE DimDate (
    DateKey        DATE PRIMARY KEY,
    Year           INTEGER, 
    Quarter        INTEGER,
    Month          INTEGER,
    Day            INTEGER
);

-- Creating DimCustomer
CREATE OR REPLACE TABLE DimCustomer (
    CustomerKey    INTEGER AUTOINCREMENT PRIMARY KEY,
    CustomerName   VARCHAR,
    Segment        VARCHAR
);


-- Creating DimProduct
CREATE OR REPLACE TABLE DimProduct (
    ProductKey     INTEGER AUTOINCREMENT PRIMARY KEY,
    ProductName    VARCHAR,
    Category       VARCHAR,
    SubCategory    VARCHAR
);

-- Creating DimShipping
CREATE OR REPLACE TABLE DimShipping (
    ShipModeKey    INTEGER AUTOINCREMENT PRIMARY KEY,
    ShipMode       VARCHAR,
    ShipStatus     VARCHAR,
    DaystoShipActual    INTEGER,
    DaystoShipScheduled INTEGER
);

-- Creating DimLocation
CREATE OR REPLACE TABLE DimLocation (
    LocationKey    INTEGER AUTOINCREMENT PRIMARY KEY,
    Region         VARCHAR,
    Country        VARCHAR,
    State          VARCHAR,
    City           VARCHAR,
    PostalCode     INTEGER,
    Latitude       FLOAT,
    Longitude      FLOAT
);



----------------------------------- Creating fact Tables-------------------------------------------------
CREATE OR REPLACE TABLE FactSales (
    FactID             INTEGER AUTOINCREMENT PRIMARY KEY,
    OrderID            VARCHAR,

    -- Foreign Keys
    OrderDateKey       DATE REFERENCES DimDate(DateKey),
    ShipDateKey        DATE REFERENCES DimDate(DateKey),
    CustomerKey        INTEGER REFERENCES DimCustomer(CustomerKey),
    ProductKey         INTEGER REFERENCES DimProduct(ProductKey),
    ShipModeKey        INTEGER REFERENCES DimShipping(ShipModeKey),
    LocationKey        INTEGER REFERENCES DimLocation(LocationKey),

    -- Measures
    Sales              FLOAT,
    Quantity           INTEGER,
    Discount           FLOAT,
    Profit             FLOAT,
    SalesForecast      FLOAT,
    OrderProfitable    BOOLEAN,
    SalesperCustomer   FLOAT,
    ProfitRatio        FLOAT,
    SalesaboveTarget   FLOAT
);

----------------------------------- Inserting data from raw_sales_data to star schema tables-------------

-- DimDate 
INSERT INTO DimDate (DateKey, Year, Quarter, Month, Day)
SELECT DISTINCT
    TO_DATE(OrderDate) AS DateKey,
    EXTRACT(YEAR FROM TO_DATE(OrderDate)) AS Year,
    EXTRACT(QUARTER FROM TO_DATE(OrderDate)) AS Quarter,
    EXTRACT(MONTH FROM TO_DATE(OrderDate)) AS Month,
    EXTRACT(DAY FROM TO_DATE(OrderDate)) AS Day
FROM staging.raw_sales_data

UNION

SELECT DISTINCT
    TO_DATE(ShipDate) AS DateKey,
    EXTRACT(YEAR FROM TO_DATE(ShipDate)) AS Year,
    EXTRACT(QUARTER FROM TO_DATE(ShipDate)) AS Quarter,
    EXTRACT(MONTH FROM TO_DATE(ShipDate)) AS Month,
    EXTRACT(DAY FROM TO_DATE(ShipDate)) AS Day
FROM staging.raw_sales_data;

-- DimCustomer
INSERT INTO DimCustomer (CustomerName, Segment)
SELECT DISTINCT
    CustomerName,
    Segment
FROM staging.raw_sales_data;


-- DimProduct
INSERT INTO DimProduct (ProductName, Category, SubCategory)
SELECT DISTINCT
    ProductName,
    Category,
    Sub_Category
FROM staging.raw_sales_data;

-- DimShipping
INSERT INTO DimShipping (ShipMode, ShipStatus, DaystoShipActual, DaystoShipScheduled)
SELECT DISTINCT
    ShipMode,
    ShipStatus,
    DaystoShipActual,
    DaystoShipScheduled
FROM staging.raw_sales_data;

-- DimLocation
INSERT INTO DimLocation (Region, Country, State, City, PostalCode, Latitude, Longitude)
SELECT DISTINCT
    Region,
    Country,
    State,
    City,
    PostalCode,
    Latitude,
    Longitude
FROM staging.raw_sales_data;

--FactSales
INSERT INTO FactSales (
    OrderID,
    OrderDateKey,
    ShipDateKey,
    CustomerKey,
    ProductKey,
    ShipModeKey,
    LocationKey,
    Sales,
    Quantity,
    Discount,
    Profit,
    SalesForecast,
    OrderProfitable,
    SalesperCustomer,
    ProfitRatio,
    SalesaboveTarget
)
SELECT 
    s.OrderID,
    TO_DATE(s.OrderDate),
    TO_DATE(s.ShipDate),

    -- Foreign Keys
    c.CustomerKey,
    p.ProductKey,
    sh.ShipModeKey,
    l.LocationKey,

    -- Measures
    s.Sales,
    s.Quantity,
    s.Discount,
    s.Profit,
    s.SalesForecast,
    s.OrderProfitable,
    s.SalesperCustomer,
    s.ProfitRatio,
    s.SalesaboveTarget

FROM staging.raw_sales_data s

JOIN DimCustomer c
  ON s.CustomerName = c.CustomerName
 AND s.Segment = c.Segment

JOIN DimProduct p
  ON s.ProductName = p.ProductName
 AND s.Category = p.Category
 AND s.Sub_Category = p.SubCategory

JOIN DimShipping sh
  ON s.ShipMode = sh.ShipMode
 AND s.ShipStatus = sh.ShipStatus
 AND s.DaystoShipActual = sh.DaystoShipActual
 AND s.DaystoShipScheduled = sh.DaystoShipScheduled

JOIN DimLocation l
  ON s.Region = l.Region
 AND s.Country = l.Country
 AND s.State = l.State
 AND s.City = l.City
 AND s.PostalCode = l.PostalCode
 AND s.Latitude = l.Latitude
 AND s.Longitude = l.Longitude;

 select * from factsales;

