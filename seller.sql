
DROP DATABASE IF EXISTS seller_and_inventory_management_system;

CREATE DATABASE seller_and_inventory_management_system;

USE seller_and_inventory_management_system;

CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY AUTO_INCREMENT,
    Seller_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(300),

    CHECK (LENGTH(Phone) >= 10)
);


CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,

    CHECK (Price > 0)
);


CREATE TABLE Inventory (
    Inventory_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_ID INT NOT NULL,
    Seller_ID INT NOT NULL,
    Stock_Quantity INT NOT NULL DEFAULT 0,
    Stock_Status VARCHAR(20) NOT NULL,
    Last_Updated DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (Product_ID)
        REFERENCES Product(Product_ID),

    FOREIGN KEY (Seller_ID)
        REFERENCES Seller(Seller_ID),

    CHECK (Stock_Quantity >= 0),

    CHECK (Stock_Status IN ('Available', 'Out of Stock'))
);



INSERT INTO Seller
(Seller_Name, Email, Phone, Address)
VALUES
('Tech World', 'techworld@gmail.com', '9876543210', 'Chennai'),
('Fashion Hub', 'fashionhub@gmail.com', '9876543211', 'Bangalore'),
('Smart Electronics', 'smartelectronics@gmail.com', '9876543212', 'Mumbai'),
('Style Store', 'stylestore@gmail.com', '9876543213', 'Delhi'),
('Home Needs', 'homeneeds@gmail.com', '9876543214', 'Kochi');



INSERT INTO Product
(Product_Name, Price)
VALUES
('Laptop', 55000.00),
('Smartphone', 25000.00),
('Headphones', 2500.00),
('T-Shirt', 799.00),
('Jeans', 1499.00),
('Face Cream', 599.00),
('Shampoo', 399.00),
('Washing Machine', 35000.00),
('Mixer Grinder', 4500.00),
('Cricket Bat', 2500.00);



INSERT INTO Inventory
(Product_ID, Seller_ID, Stock_Quantity, Stock_Status)
VALUES
(1, 1, 20, 'Available'),
(1, 3, 15, 'Available'),
(2, 1, 30, 'Available'),
(2, 3, 20, 'Available'),
(3, 1, 8, 'Available'),
(4, 2, 60, 'Available'),
(5, 2, 40, 'Available'),
(6, 4, 25, 'Available'),
(7, 4, 15, 'Available'),
(8, 5, 12, 'Available'),
(9, 5, 20, 'Available'),
(10, 2, 30, 'Available');



SELECT * FROM Seller;

SELECT * FROM Product;

SELECT * FROM Inventory;



SELECT
    i.Inventory_ID,
    p.Product_ID,
    p.Product_Name,
    s.Seller_ID,
    s.Seller_Name,
    i.Stock_Quantity,
    i.Stock_Status,
    i.Last_Updated
FROM Inventory i
JOIN Product p
    ON i.Product_ID = p.Product_ID
JOIN Seller s
    ON i.Seller_ID = s.Seller_ID
ORDER BY p.Product_ID;

INSERT INTO Seller
(Seller_Name, Email, Phone, Address)
VALUES
('New Seller', 'newseller@gmail.com', '9876500000', 'Chennai');




SELECT * FROM Seller;


UPDATE Seller
SET
    Phone = '9876511111',
    Address = 'Nagercoil'
WHERE Seller_ID = 6;


-- DELETE SELLER

DELETE FROM Seller
WHERE Seller_ID = 6;

INSERT INTO Inventory
(Product_ID, Seller_ID, Stock_Quantity, Stock_Status)
VALUES
(3, 3, 10, 'Available');



SELECT
    s.Seller_Name,
    p.Product_Name,
    i.Stock_Quantity,
    i.Stock_Status
FROM Seller s
JOIN Inventory i
    ON s.Seller_ID = i.Seller_ID
JOIN Product p
    ON i.Product_ID = p.Product_ID
ORDER BY s.Seller_Name;



SELECT
    s.Seller_Name,
    COUNT(DISTINCT i.Product_ID) AS Number_of_Products
FROM Seller s
LEFT JOIN Inventory i
    ON s.Seller_ID = i.Seller_ID
GROUP BY
    s.Seller_ID,
    s.Seller_Name
ORDER BY s.Seller_Name;


SELECT
    p.Product_ID,
    p.Product_Name,
    i.Stock_Quantity,
    i.Stock_Status
FROM Product p
JOIN Inventory i
    ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity > 0;



SELECT
    p.Product_ID,
    p.Product_Name,
    i.Stock_Quantity,
    i.Stock_Status
FROM Product p
JOIN Inventory i
    ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity = 0;




SELECT
    p.Product_ID,
    p.Product_Name,
    i.Stock_Quantity,
    i.Stock_Status
FROM Product p
JOIN Inventory i
    ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity < 10;



UPDATE Inventory
SET
    Stock_Quantity = Stock_Quantity + 20,
    Stock_Status = 'Available',
    Last_Updated = CURRENT_TIMESTAMP
WHERE Product_ID = 3
AND Seller_ID = 1;




SELECT *
FROM Inventory
WHERE Product_ID = 3
AND Seller_ID = 1;


DELETE FROM Inventory
WHERE Product_ID = 10
AND Seller_ID = 2;

SELECT
    s.Seller_Name,
    COUNT(DISTINCT i.Product_ID) AS Number_of_Products,
    COALESCE(SUM(i.Stock_Quantity), 0) AS Available_Stock
FROM Seller s
LEFT JOIN Inventory i
    ON s.Seller_ID = i.Seller_ID
GROUP BY
    s.Seller_ID,
    s.Seller_Name
ORDER BY s.Seller_Name;

SELECT
    p.Product_Name,
    i.Stock_Quantity,
    i.Stock_Status
FROM Product p
JOIN Inventory i
    ON p.Product_ID = i.Product_ID
ORDER BY p.Product_Name;


SELECT
    COUNT(DISTINCT Product_ID) AS Total_Products_Available
FROM Inventory
WHERE Stock_Quantity > 0;

SELECT
    COUNT(DISTINCT Product_ID) AS Products_Out_of_Stock
FROM Inventory
WHERE Stock_Quantity = 0;

SELECT
    p.Product_ID,
    p.Product_Name,
    i.Stock_Quantity
FROM Product p
JOIN Inventory i
    ON p.Product_ID = i.Product_ID
ORDER BY i.Stock_Quantity DESC
LIMIT 1;


-- =====================================================
-- REPORT 6: AVERAGE INVENTORY QUANTITY
-- =====================================================

SELECT
    ROUND(AVG(Stock_Quantity), 2)
    AS Average_Inventory_Quantity
FROM Inventory;


SELECT

    COUNT(DISTINCT CASE
        WHEN Stock_Quantity > 0
        THEN Product_ID
    END) AS Total_Products_Available,

    COUNT(DISTINCT CASE
        WHEN Stock_Quantity = 0
        THEN Product_ID
    END) AS Products_Out_of_Stock,

    MAX(Stock_Quantity)
    AS Highest_Stock_Quantity,

    ROUND(AVG(Stock_Quantity), 2)
    AS Average_Inventory_Quantity

FROM Inventory;