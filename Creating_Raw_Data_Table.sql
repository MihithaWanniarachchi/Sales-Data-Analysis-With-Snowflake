-- Create and switch to the database
CREATE DATABASE IF NOT EXISTS SALES_DB;
USE DATABASE SALES_DB;

-- Create and switch to the schema
CREATE SCHEMA IF NOT EXISTS STAGING;
USE SCHEMA STAGING;

-- Create table to insert data from the uploaded file in stage
CREATE OR REPLACE TABLE raw_sales_data (
  OrderDate TIMESTAMP_TZ,
  Category STRING,
  City STRING,
  Country STRING,
  CustomerName STRING,
  Discount FLOAT,
  OrderID STRING,
  PostalCode INT,
  ProductName STRING,
  Profit FLOAT,
  Quantity INT,
  Region STRING,
  Sales FLOAT,
  Segment STRING,
  ShipDate TIMESTAMP_TZ,
  ShipMode STRING,
  State STRING,
  Sub_Category STRING,
  DaystoShipActual INT,
  SalesForecast FLOAT,
  ShipStatus STRING,
  DaystoShipScheduled INT,
  OrderProfitable BOOLEAN,
  SalesperCustomer FLOAT,
  ProfitRatio FLOAT,
  SalesaboveTarget FLOAT,
  Latitude FLOAT,
  Longitude FLOAT
);

-- Creating the file format for uploaded file
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  FIELD_DELIMITER = ','
  NULL_IF = ('NULL', 'null', '')
  EMPTY_FIELD_AS_NULL = TRUE
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
  TRIM_SPACE = TRUE;

-- Copy data from the stage
COPY INTO raw_sales_data
FROM @raw_data_stage
FILES = ('df_cleaned.csv')  -- replace with your actual CSV filename
FILE_FORMAT = (format_name = csv_format)
ON_ERROR = 'CONTINUE';

SELECT * FROM raw_sales_data;
