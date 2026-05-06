
CREATE TABLE Dim_products
(
ProductId NVARCHAR(50) PRIMARY KEY,
CategoryNameEnglish VARCHAR(50),
ProductWeightG INT,
ProductLengthCm SMALLINT,
ProductHeightCm SMALLINT,
ProductWidthCm SMALLINT,
ProductVolCm3 INT
)

CREATE TABLE Dim_payments
(
PaymentId TINYINT IDENTITY(1,1) PRIMARY KEY,
PaymentType  NVARCHAR(50),
PaymentInstallments TINYINT
)

CREATE TABLE Dim_customers
(
CustomerUniqueId NVARCHAR(50) PRIMARY KEY,
CustomerState NVARCHAR(50),
CustomerCity NVARCHAR(50)
)

CREATE TABLE Dim_sellers
(
SellerId NVARCHAR(50) PRIMARY KEY,
SellerCity NVARCHAR(50),
SellerState NVARCHAR(50)
)

CREATE TABLE Dim_date
(
    [DateKey] INT PRIMARY KEY, 
    [Date] DATE,
    [DayOfMonth] TINYINT,
    [DayName] NVARCHAR(15),
    [DayOfWeek] TINYINT,
    [Month] TINYINT,
    [MonthName] NVARCHAR(15),
    [Quarter] TINYINT,
    [Year] SMALLINT,
    [MonthYear] CHAR(8),
    [IsWeekend] BIT
)
GO

DECLARE @StartDate DATE = (SELECT MIN(order_purchase_timestamp) FROM olist_orders_dataset)
DECLARE @EndDate DATE = '2020-01-01' --Olist data ends in 2018*

DECLARE @CurrentDate DATE = @StartDate

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO Dim_date
    SELECT
        CONVERT(CHAR(8), @CurrentDate, 112) AS DateKey,
        @CurrentDate,
        DATEPART(DAY, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        DATEPART(WEEKDAY, @CurrentDate),
        DATEPART(MONTH, @CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        DATEPART(YEAR, @CurrentDate),
        LEFT(DATENAME(MONTH, @CurrentDate), 3) + '-' + CAST(DATEPART(YEAR, @CurrentDate) AS CHAR(4)),
        CASE WHEN DATENAME(WEEKDAY, @CurrentDate) IN ('Saturday', 'Sundar') THEN 1 ELSE 0 END

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate)
END


CREATE TABLE Fact_orders
(
OrderId NVARCHAR(50),
OrderItemId TINYINT,
Price NUMERIC(8,2),
FreightValue NUMERIC (8,2),
TotalValue NUMERIC (8,2),
ProductId NVARCHAR(50),
PaymentId TINYINT,
CustomerId NVARCHAR(50),
SellerId NVARCHAR(50),
PurchaseDateId INT,
DeliveredDateId INT,
EstimatedDeliveryDateId INT,


PRIMARY KEY (OrderId, OrderItemId),

CONSTRAINT ProductFk
FOREIGN KEY (ProductId)
REFERENCES Dim_products(ProductId),

CONSTRAINT PaymentFk
FOREIGN KEY (PaymentId)
REFERENCES Dim_payments(PaymentId),

CONSTRAINT CustomerFk
FOREIGN KEY (CustomerId)
REFERENCES Dim_customers(CustomerUniqueId),

CONSTRAINT SellerFk
FOREIGN KEY (SellerId)
REFERENCES Dim_sellers(SellerId),

CONSTRAINT PurchaseDateFk
FOREIGN KEY (PurchaseDateId)
REFERENCES Dim_date(DateKey),

CONSTRAINT DeliveredDateFk
FOREIGN KEY(DeliveredDateId)
REFERENCES Dim_date(DateKey),

CONSTRAINT EstimatedDeliveryDateFk
FOREIGN KEY(EstimatedDeliveryDateId)
REFERENCES Dim_date(DateKey)
)
