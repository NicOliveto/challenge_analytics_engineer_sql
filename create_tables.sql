--Customer Table
CREATE TABLE ecommerce.Customer (
    customer_id INT64 NOT NULL,
    email STRING NOT NULL,
    first_name STRING NOT NULL,
    last_name STRING NOT NULL,
    gender STRING NOT NULL,
    birth_date DATE NOT NULL,
    address STRING,
    phone_number STRING,
    CONSTRAINT pk_customer PRIMARY KEY (customer_id) NOT ENFORCED,
    CONSTRAINT uq_email UNIQUE (email) NOT ENFORCED
);

--Category Table
CREATE TABLE ecommerce.Category (
    category_id INT64 NOT NULL,
    category_desc STRING NOT NULL,
    path STRING NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY (category_id) NOT ENFORCED,
);

--Item Table
CREATE TABLE ecommerce.Item (
    item_id INT64 NOT NULL,
    item_name STRING NOT NULL,
    item_desc STRING,
    item_status STRING NOT NULL,
    item_price NUMERIC NOT NULL,
    item_creation_dt DATE NOT NULL,
    item_end_dt DATE,
    seller_id INT64 NOT NULL,
    category_id INT64 NOT NULL,
    CONSTRAINT pk_item PRIMARY KEY (item_id) NOT ENFORCED,
    CONSTRAINT fk_item_seller FOREIGN KEY (seller_id) REFERENCES ecommerce.Customer(customer_id) NOT ENFORCED,
    CONSTRAINT fk_item_category FOREIGN KEY (category_id) REFERENCES ecommerce.Category(category_id) NOT ENFORCED
);

--Order Table
CREATE TABLE ecommerce.Order (
    order_id INT64 NOT NULL,
    item_id INT64 NOT NULL,
    buyer_id INT64 NOT NULL,
    order_datetime TIMESTAMP NOT NULL,
    item_qty NUMERIC NOT NULL,
    item_unit_price NUMERIC NOT NULL,
    CONSTRAINT pk_order PRIMARY KEY (order_id) NOT ENFORCED,
    CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES ecommerce.Item(item_id) NOT ENFORCED,
    CONSTRAINT fk_buyer FOREIGN KEY (buyer_id) REFERENCES ecommerce.Customer(customer_id) NOT ENFORCED
);

--Item History Table
CREATE TABLE ecommerce.Item_History (
    item_history_id INT64 NOT NULL,
    item_history_dt DATE NOT NULL,
    item_id INT64 NOT NULL,
    item_price NUMERIC NOT NULL,
    item_status STRING NOT NULL,
    CONSTRAINT pk_item_history PRIMARY KEY (item_history_id) NOT ENFORCED,
    CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES ecommerce.Item(item_id) NOT ENFORCED,
)