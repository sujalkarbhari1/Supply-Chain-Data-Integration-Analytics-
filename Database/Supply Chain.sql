
CREATE TABLE suppliers (
    supplier_id VARCHAR(5) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_phone BIGINT,
    supplier_email VARCHAR(100),
    supplier_address VARCHAR(255),
    supplier_country VARCHAR(50),
    supplier_rating INT DEFAULT 0 CHECK (supplier_rating BETWEEN 1 AND 5)
);

CREATE TABLE product_categories (
    category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id VARCHAR(3),
    unit_price DECIMAL(10,2),
    unit_cost DECIMAL(10,2),
    supplier_id VARCHAR(5),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE warehouses (
    warehouse_id  VARCHAR(3) PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    warehouse_location VARCHAR(255),
    warehouse_capacity INT   
);

CREATE TABLE inventory (
    inventory_id VARCHAR(5) PRIMARY KEY,
    warehouse_id VARCHAR(5),
    product_id VARCHAR(5),
    quantity_available INT DEFAULT 0,
    reorder_level INT,
    safety_stock INT DEFAULT 0,
    last_restocked_date DATE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_type VARCHAR(50),             -- Retail / Wholesale
    contact_number BIGINT,
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE orders (
    order_id VARCHAR(5) PRIMARY KEY,
    customer_id VARCHAR(5),
    warehouse_id VARCHAR(5),
    order_date DATE NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    payment_status VARCHAR(50) DEFAULT 'Unpaid',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);



CREATE TABLE order_details (
    order_detail_id VARCHAR(5) PRIMARY KEY,
    order_id VARCHAR(5),
    product_id VARCHAR(5),
    quantity_ordered INT NOT NULL,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE carriers (
    carrier_id VARCHAR(5) PRIMARY KEY,
    carrier_name VARCHAR(100) NOT NULL,
    carrier_type VARCHAR(50),              -- Truck, Air, Sea, etc.
    carrier_contact VARCHAR(100),
    carrier_rating SMALLINT DEFAULT 0 CHECK (carrier_rating BETWEEN 1 AND 5)
);

CREATE TABLE shipments (
    shipment_id VARCHAR(5) PRIMARY KEY,
    order_id VARCHAR(5),
    carrier_id VARCHAR(5),
    warehouse_id VARCHAR(5),
    shipment_date DATE,
    expected_delivery_date DATE,
    delivery_date DATE,
    status VARCHAR(50) DEFAULT 'In Transit',
    shipment_cost DECIMAL(12,2),
    tracking_number VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (carrier_id) REFERENCES carriers(carrier_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

ALTER TABLE inventory ADD CONSTRAINT chk_quantity_positive CHECK (quantity_available >= 0);
ALTER TABLE order_details ADD CONSTRAINT chk_ordered_positive CHECK (quantity_ordered > 0);

Select * From products;
Select * From customers;
Select * From warehouses;
Select * From orders;
Select * From order_details;
Select * From shipments;
Select * From suppliers;
Select * From carriers;
Select * From inventory;
Select * From product_categories;




