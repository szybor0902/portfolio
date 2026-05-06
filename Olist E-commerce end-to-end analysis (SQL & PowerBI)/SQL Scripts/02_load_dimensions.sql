
INSERT INTO Dim_products (ProductId, CategoryNameEnglish, ProductWeightG, ProductLengthCm, ProductHeightCm, ProductWidthCm, ProductVolCm3)
SELECT DISTINCT p.product_id, c.product_category_name_english, p.product_weight_g, p.product_length_cm,	p.product_height_cm, p.product_width_cm,
CAST(p.product_length_cm AS INT)*p.product_height_cm*p.product_width_cm
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation c
ON p.product_category_name = c.product_category_name



INSERT INTO Dim_payments (PaymentType, PaymentInstallments)
SELECT DISTINCT payment_type, payment_installments
FROM olist_order_payments_dataset
ORDER BY payment_type, payment_installments



WITH UniqueCustomers AS (
    SELECT 
        customer_unique_id, 
        customer_state, 
        customer_city,
        ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY customer_city DESC) AS rn
    FROM olist_customers_dataset
)
INSERT INTO Dim_customers (CustomerUniqueId, CustomerState, CustomerCity)
SELECT customer_unique_id, customer_state, customer_city
FROM UniqueCustomers
WHERE rn = 1;



INSERT INTO Dim_sellers (SellerId, SellerCity, SellerState)
SELECT DISTINCT seller_id, seller_city, seller_state
FROM olist_sellers_dataset

SELECT * FROM Dim_sellers

