DROP DATABASE IF EXISTS shop_db;
CREATE DATABASE shop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shop_db;

CREATE TABLE users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  description TEXT,
  price       DECIMAL(10,2) NOT NULL,
  stock       INT NOT NULL DEFAULT 0,
  category    VARCHAR(60) NOT NULL,
  image_url   VARCHAR(255),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_category (category)
);

CREATE TABLE orders (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  total      DECIMAL(10,2) NOT NULL,
  address    VARCHAR(500) NOT NULL,
  status     VARCHAR(30) NOT NULL DEFAULT 'PLACED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  order_id     INT NOT NULL,
  product_id   INT NOT NULL,
  product_name VARCHAR(150) NOT NULL,
  quantity     INT NOT NULL,
  price        DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id)   REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name, description, price, stock, category, image_url) VALUES
('Wireless Headphones', 'Over-ear Bluetooth headphones with noise isolation and 30-hour battery life.', 2499.00, 25, 'Electronics', 'https://img.sanishtech.com/u/6b50e2a33b79c403f65736c3d042acd0.jpg'),
('Smart Watch', 'Fitness tracker with heart-rate monitor, GPS and 7-day battery.', 3999.00, 15, 'Electronics', 'https://img.sanishtech.com/u/dd84cdbbc2a5f26dc5b6f757607f072e.jpg'),
('Bluetooth Speaker', 'Portable waterproof speaker with deep bass and 12-hour playtime.', 1799.00, 40, 'Electronics', 'https://img.sanishtech.com/u/e7d653417867550d0af4036258aa5b16.jpg'),
('Men''s Casual T-Shirt', '100% cotton regular-fit t-shirt, soft and breathable.', 499.00, 100, 'Fashion', 'https://img.sanishtech.com/u/65c5ddc7ebd3476b099e8904dab105af.jpg'),
('Women''s Handbag', 'Stylish faux-leather handbag with multiple compartments.', 1299.00, 30, 'Fashion', 'https://img.sanishtech.com/u/fd1bfcaca0be0142eecc2ef87d9813f3.webp'),
('Running Shoes', 'Lightweight mesh running shoes with cushioned sole.', 2199.00, 50, 'Fashion', 'https://img.sanishtech.com/u/36f8148ee10a510c4ff4269b3cf7c32c.jpg'),
('Non-Stick Cookware Set', '5-piece non-stick cookware set, induction friendly.', 2899.00, 20, 'Home', 'https://img.sanishtech.com/u/9573d0d3f71bea5bd5557d7160743ff6.jpg'),
('LED Desk Lamp', 'Adjustable LED lamp with 3 colour modes and USB charging port.', 899.00, 60, 'Home', 'https://img.sanishtech.com/u/a45d0a691eae31e1e9cf0cf6107576d8.jpg'),
('Yoga Mat', 'Anti-slip 6mm yoga mat with carry strap.', 699.00, 70, 'Sports', 'https://img.sanishtech.com/u/dc13e01b43f0f9de593db1be637124fe.webp'),
('Cricket Bat', 'English willow cricket bat, full size, with grip.', 3499.00, 10, 'Sports', 'https://img.sanishtech.com/u/b34f97f164b32e00af8790c18168e6cd.webp'),
('Programming Book: Java', 'Comprehensive guide to core Java, collections, JDBC and servlets.', 799.00, 45, 'Books', 'https://img.sanishtech.com/u/1901771397de5cf859f745f34f71026b.jpg'),
('Notebook Pack (5)', 'Pack of 5 ruled notebooks, 200 pages each.', 349.00, 120, 'Books', 'https://img.sanishtech.com/u/949eb6d305cdebfb7b60002089a673e2.jpg');
