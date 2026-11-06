DROP TABLE customers;
DROP TABLE order_items;
DROP TABLE order_payment;
DROP TABLE order_review;
DROP TABLE orders;
DROP TABLE products;
DROP TABLE sellers;

CREATE TABLE customers (
	customer_id VARCHAR(255),
	customer_unique_id  VARCHAR(255),
	customer_zip_code_prefix  INT,
	customer_city   VARCHAR(255),
	customer_state VARCHAR(255));

CREATE TABLE order_items (
	order_id   VARCHAR(255),       
    order_item_id INT,         
    product_id VARCHAR(255),        
    seller_id  VARCHAR(255),        
    shipping_limit_date DATETIME,
    price  DECIMAL(10,2),  
    freight_value   DECIMAL(10,2)
);
    
CREATE TABLE order_payment (
	order_id   VARCHAR(255),
    payment_sequential  INT, 
    payment_type  VARCHAR(255), 
    payment_installments INT, 
    payment_value  DECIMAL(10,2)
);

CREATE TABLE order_review (
	review_id    VARCHAR(255),
    order_id    VARCHAR(255),
    review_score    INT,
    review_comment_title  VARCHAR(255),
    review_comment_message  TEXT,
    review_creation_date     DATETIME,
    review_answer_timestamp  DATETIME);
    
CREATE TABLE orders(
	order_id   VARCHAR(255),       
   customer_id    VARCHAR(255),        
   order_status     VARCHAR(255),       
   order_purchase_timestamp    DATETIME,
   order_approved_at             DATETIME,
   order_delivered_carrier_date DATETIME,
   order_delivered_customer_date DATETIME,
   order_estimated_delivery_date  DATETIME);
   
CREATE TABLE products(
	product_id   VARCHAR(255),   
    product_name_lenght   FLOAT,
    product_description_lenght   FLOAT,
    product_photos_qty       FLOAT,
    product_weight_g      FLOAT,
    product_length_cm      FLOAT,
    product_height_cm     FLOAT,
    product_width_cm     FLOAT,
    product_category_name   VARCHAR(255)
    );
    
CREATE TABLE sellers (
	seller_id   VARCHAR(255),
    seller_zip_code_prefix  INT,
    seller_city    VARCHAR(255),
    seller_state  VARCHAR(255));

SET GLOBAL local_infile = 1;

-- Change paths

LOAD DATA LOCAL INFILE "/path/to/olist_customers_clean.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/path/to/olist_order_items_clean.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/path/to/olist_order_payment_clean.csv"
INTO TABLE order_payment
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/path/to/olist_order_review_clean.csv"
INTO TABLE order_review
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/path/to/olist_orders_clean.csv"
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/path/to/olist_products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE "/path/to/olist_sellers_clean.csv"
INTO TABLE sellers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;