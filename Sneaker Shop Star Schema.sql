CREATE DATABASE SneakerStore_DB
GO

USE SneakerStore_DB

--CREATE DIM TABLES

--customer info
CREATE TABLE Dim_Customer (
Customer_ID INT PRIMARY KEY,
Age INT,
Gender VARCHAR(25),
Email VARCHAR(255),
Address VARCHAR(255)
)

CREATE TABLE Dim_Date (
Date_ID DATE PRIMARY KEY,
Year INT,
Month INT,
Day INT,
Is_Holiday INT,
Season VARCHAR(255)
)

--employee info
CREATE TABLE Dim_SalesPerson (
SalesPerson_ID INT PRIMARY KEY,
FullName VARCHAR(255),
Commission_Rate DECIMAL(2),
Hourly_Rate DECIMAL(2),
Sales_Role VARCHAR(255)
)
--Store_ID INT

--product info
CREATE TABLE Dim_Product (
Product_ID INT PRIMARY KEY,
Name VARCHAR(255),
Brand VARCHAR(255),
Colourway VARCHAR(255),
Size INT,
Cost DECIMAL(2),
Price DECIMAL(2)
)

--location and store info
CREATE TABLE Dim_Store (
Store_ID INT PRIMARY KEY,
Country VARCHAR(255),
Province VARCHAR(255),
City VARCHAR(255),
Zipcode INT,
Store_Size INT
)

--how was order/sale placed
CREATE TABLE Dim_Channel(
Channel_ID INT PRIMARY KEY,
Type VARCHAR(255),
Device_Type VARCHAR(255))

CREATE TABLE Dim_Fulfilment(
Fulfilment_ID INT PRIMARY KEY,
Method VARCHAR(255),
Carrier VARCHAR(255),
Tracking_number INT,
Delivery_status VARCHAR(255)
--Shipped_Date DATE,
--Estimated_Date DATE,
--Delivery_Date DATE
)

---- Role-playing FK references into dim_date
--    shipped_date_id         INT            REFERENCES dim_date(date_id),
--    promised_date_id        INT            REFERENCES dim_date(date_id),
--    delivered_date_id       INT            REFERENCES dim_date(date_id),  -- nullable until confirmed


CREATE TABLE fact_sales (
sales_id INT PRIMARY KEY,
 
-- Dim foreign keys
Customer_ID    INT REFERENCES Dim_Customer(Customer_ID),  -- nullable for guest checkout
Date_ID        date NOT NULL REFERENCES Dim_Date(Date_ID),
Store_ID       INT NOT NULL  REFERENCES Dim_Store(Store_ID),
Product_ID     INT NOT NULL  REFERENCES Dim_Product(Product_ID),
Channel_ID     INT NOT NULL  REFERENCES Dim_Channel(Channel_ID),
Fulfilment_ID  INT NOT NULL  REFERENCES Dim_Fulfilment(Fulfilment_ID),
SalesPerson_ID INT NOT NULL  REFERENCES Dim_SalesPerson(SalesPerson_ID),
Unit_price     DECIMAL(2),
Quantity       INT,
Discount	   DECIMAL(2)
)