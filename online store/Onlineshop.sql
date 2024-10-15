-- 1. Create Tables

-- Products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,              -- Auto-incrementing primary key
    product_name VARCHAR(100),          -- Name of the product
    price DECIMAL(10, 2),               -- Price of the product
    stock_quantity INT                   -- Current stock level of the product
);

-- Customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,               -- Auto-incrementing primary key
    first_name VARCHAR(50),              -- Customer's first name
    last_name VARCHAR(50),               -- Customer's last name
    email VARCHAR(100) UNIQUE             -- Customer's email
);

-- Orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,               -- Auto-incrementing primary key
    customer_id INT REFERENCES customers(id), -- Foreign key referencing customers
    order_date DATE                      -- Date when the order was placed
);

-- Order items table (composite primary key)
CREATE TABLE order_items (
    order_id INT REFERENCES orders(id),   -- Foreign key referencing orders
    product_id INT REFERENCES products(id), -- Foreign key referencing products
    quantity INT,                         -- Quantity of the product in the order
    PRIMARY KEY (order_id, product_id)   -- Composite primary key
);

-- 2. Insert Data

-- Insert Products
INSERT INTO products (product_name, price, stock_quantity) VALUES
('Laptop', 999.99, 10),
('Headphones', 199.99, 15),
('Smartphone', 699.99, 20),
('Tablet', 499.99, 5),
('Smartwatch', 299.99, 8);

-- Insert Customers
INSERT INTO customers (first_name, last_name, email) VALUES
('Alice', 'Smith', 'alice.smith@example.com'),
('Bob', 'Johnson', 'bob.johnson@example.com'),
('Charlie', 'Williams', 'charlie.williams@example.com'),
('Diana', 'Brown', 'diana.brown@example.com');

-- Insert Orders
INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-10-01'),  -- Order by Alice
(2, '2024-10-02'),  -- Order by Bob
(1, '2024-10-03'),  -- Another order by Alice
(3, '2024-10-04'),  -- Order by Charlie
(4, '2024-10-05');  -- Order by Diana

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),   -- Order 1: 1 Laptop
(1, 2, 1),   -- Order 1: 1 Headphones
(2, 3, 1),   -- Order 2: 1 Smartphone
(2, 4, 2),   -- Order 2: 2 Tablets
(3, 5, 1),   -- Order 3: 1 Smartwatch
(3, 1, 1),   -- Order 3: 1 Laptop
(4, 2, 2),   -- Order 4: 2 Headphones
(4, 4, 1);   -- Order 4: 1 Tablet

-- 3. SQL Queries

-- a. Retrieve the names and stock quantities of all products
SELECT product_name, stock_quantity FROM products;

-- b. Retrieve the product names and quantities for order_id = 1
SELECT p.product_name, oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;  -- Example order_id

-- c. Retrieve all orders placed by customer_id = 1
SELECT o.id AS order_id, oi.product_id, oi.quantity
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.customer_id = 1;  -- Example customer_id

-- 4. Update Data

-- a. Reduce stock quantities after customer 1 places order 1
UPDATE products p
SET stock_quantity = stock_quantity - oi.quantity
FROM order_items oi
WHERE p.id = oi.product_id
AND oi.order_id = 1;  -- Example order_id

-- 5. Delete Data

-- a. Remove order 1 and associated order items
DELETE FROM order_items WHERE order_id = 1;  -- Delete associated order items first
DELETE FROM orders WHERE id = 1;              -- Then delete the order

-- b. Final check of stock quantities
SELECT product_name, stock_quantity FROM products;