
/* There are multiple orders with more than one payment, therefore in the Fact table the PaymentId
will reffer to the payment type with the highest value */


WITH UniquePayments AS
(
SELECT order_id, payment_type, payment_installments, ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY payment_value DESC) AS PaymentNumber
FROM olist_order_payments_dataset
),

PreparedData AS
(
SELECT o.order_id AS OrderId, oi.order_item_id AS OrderItemId,
CAST(oi.price AS NUMERIC(8,2)) AS Price, 
CAST(oi.freight_value AS NUMERIC(8,2)) AS FreightValue, 
CAST(oi.price AS NUMERIC(8,2)) + CAST(oi.freight_value AS NUMERIC(8,2)) AS TotalValue,
oi.product_id AS ProductId,
dp.PaymentId AS PaymentId, dc.CustomerUniqueId AS CustomerUniqueId, oi.seller_id AS SellerId, 
CAST(CONVERT(CHAR(8), o.order_purchase_timestamp, 112) AS INT) AS PurchaseDateId,
CAST(CONVERT(CHAR(8), o.order_delivered_customer_date, 112) AS INT) AS DeliveredDateId,
CAST(CONVERT(CHAR(8), o.order_estimated_delivery_date, 112) AS INT) AS EstimatedDeliveryDateId
FROM olist_orders_dataset o
INNER JOIN olist_order_items_dataset oi ON 
	o.order_id = oi.order_id
LEFT JOIN UniquePayments up ON
	o.order_id = up.order_id AND up.PaymentNumber = 1
LEFT JOIN Dim_payments dp ON
	up.payment_type = dp.PaymentType AND
	up.payment_installments = dp.PaymentInstallments
LEFT JOIN olist_customers_dataset c ON
	o.customer_id = c.customer_id
LEFT JOIN Dim_customers dc ON
	c.customer_unique_id = dc.CustomerUniqueId
)

INSERT INTO Fact_orders (OrderId, OrderItemId, Price, FreightValue, TotalValue, ProductId, PaymentId, CustomerId, SellerId,
PurchaseDateId, DeliveredDateId, EstimatedDeliveryDateId)
SELECT * FROM PreparedData

SELECT * FROM Fact_orders

--check

SELECT 
    SUM(Price) AS SumaCena,
    SUM(FreightValue) AS SumaTransport,
    SUM(TotalValue) AS SumaTotal
FROM Fact_orders

UNION ALL

SELECT 
    SUM(TRY_CAST(price AS NUMERIC(8,2))) AS SumaCena,
    SUM(TRY_CAST(freight_value AS NUMERIC(8,2))) AS SumaTransport,
    SUM(TRY_CAST(price AS NUMERIC(8,2)) + TRY_CAST(freight_value AS NUMERIC(8,2))) AS SumaTotal
FROM olist_order_items_dataset;

