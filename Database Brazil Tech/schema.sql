CREATE DATABASE brazil_tech;
USE brazil_tech;

CREATE TABLE customer (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    email VARCHAR (200) NOT NULL UNIQUE,
    phone_number VARCHAR (20) NOT NULL,
    date_created DATE
);

CREATE TABLE product (
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    category VARCHAR (50) NOT NULL,
    price DECIMAL (10,2) NOT NULL,
    stock INT DEFAULT 0,
    status VARCHAR (10) DEFAULT 'Active',
    created DATE,
    updateAT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE orders (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE,
    status_orders VARCHAR (10) DEFAULT 'Pending',
    shipping_address VARCHAR (100) NOT NULL,
    updateAT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE order_items (
	order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL (10,2) NOT NULL,
    subtotal DECIMAL (10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE payment (
	payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method VARCHAR (50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
