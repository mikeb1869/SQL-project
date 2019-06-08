DROP TABLE Product;
DROP TABLE Product_Category;
DROP TABLE Customer_Address;
DROP TABLE Customer_Account;
DROP TABLE Customer;
DROP TABLE Customer_Order;
DROP TABLE Tracker;
DROP TABLE Package;
DROP TABLE Shipment;
DROP TABLE Seller_Inv;
DROP TABLE Seller;
DROP TABLE Seller_Account;
DROP TABLE Shipping_Method;

--Aspect 1 SQL code

CREATE TABLE Product(
product_id DECIMAL(12) NOT NULL,
prod_cat_id DECIMAL(12),
product_description VARCHAR(50),
product_name VARCHAR(50),
product_price DECIMAL(10,2),
product_condition VARCHAR (10),
product_qoh DECIMAL(12),
PRIMARY KEY(product_id)
);

CREATE TABLE Product_Category(
prod_cat_id DECIMAL(12) NOT NULL,
category_name VARCHAR(50),
PRIMARY KEY(prod_cat_id)
);

ALTER TABLE Product
ADD CONSTRAINT fk_prod_cat_id
FOREIGN KEY(prod_cat_id)
REFERENCES Product_Category(prod_cat_id);

INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(1,'Electronics');
INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(2,'Computers');
INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(3,'Appliances');
INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(4,'Tools');
INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(5,'Furniture');
INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(6,'Apparel');
INSERT INTO Product_Category(prod_cat_id,category_name)
VALUES(7,'Books');

CREATE PROCEDURE ADD_PRODUCT
	@product_id_arg DECIMAL(12),
	@prod_cat_id_arg DECIMAL(12),
	@product_description_arg VARCHAR(50),
	@product_name_arg VARCHAR(50),
	@product_price_arg DECIMAL(10,2),
	@product_condition_arg VARCHAR(10),
	@product_qoh_arg DECIMAL(12)
AS
BEGIN
	INSERT INTO Product(
	product_id,prod_cat_id,product_description,product_name,
	product_price,product_condition,product_qoh)
	VALUES(@product_id_arg,@prod_cat_id_arg,@product_description_arg,
			@product_name_arg,@product_price_arg,
			@product_condition_arg,@product_qoh_arg);
END;

EXEC ADD_PRODUCT 1,1,'Self-driving camera', 'Canon XD 70', 399.95,New,5;
EXEC ADD_PRODUCT 2,2,'Holographic keyboard','Virtual QWERTY', 29.99,Used,7;
EXEC ADD_PRODUCT 3,1,'Bluetooth Speaker', 'iHome Bass Cannon', 99.95,New,25;
EXEC ADD_PRODUCT 4,1,'Bluetooth Speaker', 'iHome Bass Cannon', 79.95,Used,10;
EXEC ADD_PRODUCT 5,1,'Calculator', 'TI 30x', 29.50,New,75;
EXEC ADD_PRODUCT 6,1,'Calculator', 'TI 30x', 19.50,Used,20;
EXEC ADD_PRODUCT 7,1,'Self-driving vaccuum', 'iRobot Roomba', 299.95,New,25;
EXEC ADD_PRODUCT 8,1,'Self-driving vaccuum', 'iRobot Roomba', 299.95,Used,16;
EXEC ADD_PRODUCT 9,2,'Game Controller', 'XBOX Elite', 69.95,New,13;
EXEC ADD_PRODUCT 10,2,'Game Controller', 'XBOX Elite', 54.99,Used,5;
EXEC ADD_PRODUCT 11,2,'Wireless Mouse','Logitech M385',14.99,New,30;
EXEC ADD_PRODUCT 12,2,'Wireless Mouse','Logitech M385',10.99,Used,10;
EXEC ADD_PRODUCT 13,2,'Laptop Computer','MacBook Pro 15',2549.00,New,10;
EXEC ADD_PRODUCT 14,2,'Laptop Computer','MacBook Pro 15',1900.00,Used,4;

SELECT * FROM Product
WHERE product_price <= 30.00 AND prod_cat_id=1
OR product_price <= 30.00 AND prod_cat_id=2;
------------------------------------------------------------------------
--Aspect 2 SQL code

CREATE TABLE Seller(
seller_id DECIMAL(12) NOT NULL,
seller_name VARCHAR(50),
seller_acct_id DECIMAL(12),
PRIMARY KEY(seller_id)
);

CREATE TABLE Seller_Account(
seller_acct_id DECIMAL(12) NOT NULL,
seller_id DECIMAL(12),
seller_name VARCHAR(50),
PRIMARY KEY(seller_acct_id)
);

ALTER TABLE Seller_Account
ADD CONSTRAINT fk_seller_id
FOREIGN KEY(seller_id)
REFERENCES Seller(seller_id);

CREATE TABLE Seller_Inv(
seller_id DECIMAL(12) NOT NULL,
product_id DECIMAL(12) NOT NULL,
qoh DECIMAL(12),
PRIMARY KEY(seller_id,product_id)
);

ALTER TABLE Seller_Inv
ADD CONSTRAINT fk2_seller_id
FOREIGN KEY(seller_id)
REFERENCES Seller(seller_id);

ALTER TABLE Seller_Inv
ADD CONSTRAINT fk_product_id
FOREIGN KEY(product_id)
REFERENCES Product(product_id);

INSERT INTO Seller(seller_id,seller_name,seller_acct_id)
VALUES(1,'Good Dudes',123);
INSERT INTO Seller(seller_id,seller_name,seller_acct_id)
VALUES(2,'Radio Hut',234);
INSERT INTO Seller(seller_id,seller_name,seller_acct_id)
VALUES(3,'Better Buy',345);
INSERT INTO Seller(seller_id,seller_name,seller_acct_id)
VALUES(4,'E-Shop',456);
INSERT INTO Seller(seller_id,seller_name,seller_acct_id)
VALUES(5,'Gamer''s Paradise',567);

INSERT INTO Seller_Inv(seller_id,product_id,qoh)
VALUES(1,1,5);
INSERT INTO Seller_Inv(seller_id,product_id,qoh)
VALUES(1,2,4);

CREATE PROCEDURE DELIV_PROD
	@product_id_arg DECIMAL(12),
	@product_qoh_arg DECIMAL(12),
	@seller_id_arg DECIMAL(12)
AS
BEGIN
	
	UPDATE Seller_Inv
	SET qoh=qoh - @product_qoh_arg
	WHERE seller_id=@seller_id_arg AND
	product_id=@product_id_arg
	UPDATE Product
	SET product_qoh=product_qoh + @product_qoh_arg
	WHERE product_id=@product_id_arg
END;

EXEC DELIV_PROD 1,4,1;
EXEC DELIV_PROD 2,4,1;

SELECT * FROM Product;
SELECT * FROM Seller_Inv;

SELECT Seller_Inv.seller_id,Seller_Inv.product_id, Product.product_name,Seller_Inv.qoh
FROM Seller_Inv
JOIN Product ON Seller_Inv.product_id = Product.product_id
WHERE Seller_Inv.qoh <= 11;

-------------------------------------------------------------------
--Aspect 3

CREATE TABLE Customer(
cus_id DECIMAL(12) NOT NULL,
f_name VARCHAR(50),
l_name VARCHAR(50),
cus_acct_id DECIMAL(12),
PRIMARY KEY (cus_id)
);

CREATE TABLE Customer_Account(
cus_acct_id DECIMAL(12) NOT NULL,
cus_id DECIMAL(12),
cus_user_name VARCHAR(50),
cus_phone DECIMAL(10),
cus_email VARCHAR(50),
PRIMARY KEY (cus_acct_id)
);

CREATE TABLE Customer_Address(
cus_addr_id DECIMAL(12) NOT NULL,
cus_acct_id DECIMAL(12),
cus_st_num VARCHAR(50),
cus_st_name VARCHAR(50),
cus_zip INT,
PRIMARY KEY (cus_addr_id)
);

ALTER TABLE Customer_Account
ADD CONSTRAINT fk_cus_id
FOREIGN KEY(cus_id)
REFERENCES Customer(cus_id);

ALTER TABLE Customer_Address
ADD CONSTRAINT fk_cus_acct_id
FOREIGN KEY(cus_acct_id)
REFERENCES Customer_Account(cus_acct_id);

CREATE PROCEDURE ADD_CUSTOMER
	@cus_id_arg DECIMAL(12),
	@cus_acct_id_arg DECIMAL(12),
	@cus_addr_id_arg DECIMAL(12),
	@f_name_arg VARCHAR(50),
	@l_name_arg VARCHAR(50),
	@cus_user_name_arg VARCHAR(50),
	@cus_phone_arg DECIMAL(10),
	@cus_email_arg VARCHAR(50),
	@cus_st_num_arg VARCHAR(50),
	@cus_st_name_arg VARCHAR(50),
	@cus_zip_arg INT
AS
BEGIN
	INSERT INTO Customer(
	cus_id,f_name,l_name,cus_acct_id)
	VALUES(@cus_id_arg,@f_name_arg,
	@l_name_arg,@cus_acct_id_arg);
	INSERT INTO Customer_Account(
	cus_acct_id,cus_id,cus_user_name,
	cus_phone,cus_email)
	VALUES(@cus_acct_id_arg,@cus_id_arg,
	@cus_user_name_arg,@cus_phone_arg,@cus_email_arg);
	INSERT INTO Customer_Address(
	cus_addr_id,cus_acct_id,cus_st_num,
	cus_st_name,cus_zip)
	VALUES(@cus_addr_id_arg,@cus_acct_id_arg,
	@cus_st_num_arg,@cus_st_name_arg,@cus_zip_arg);
END;

EXEC ADD_CUSTOMER 1,1,1,'Mary','Letourneau','maryleto',6175552613,'maryleto@bu.edu','One','Silber Way',02215;
EXEC ADD_CUSTOMER 2,2,2,'Mike','Barrera','mikeb5',7025289776,'mikeb5@bu.edu','10524','Headwind Ave.',89129;

EXEC ADD_CUSTOMER 3,3,3,'Tom','Brady','TB12',6175551212,'tb12@patriots.com','12','GOAT Way',12345;
EXEC ADD_CUSTOMER 4,4,4,'Julie','Brady','Tom''s_sis',4155552356,'julesb@yahoo.com','635','Lilac Court',94016;
EXEC ADD_CUSTOMER 5,5,5,'Tom','Brady','Tom''s_dad',4155554802,'The_GOATs_Pop@gmail.com','8390','Bayside Way',94211;
EXEC ADD_CUSTOMER 6,6,6,'Galynn','Brady','Tom''s_mom',4155552613,'tommys_mommy@gmail.com','8390','Bayside Way',94211;
EXEC ADD_CUSTOMER 7,7,7,'Gisele','Bundchen','GB12',6175551011,'super_model1@yahoo.com','12','GOAT Way',12345;
EXEC ADD_CUSTOMER 8,8,8,'Rob','Gronkowski','Gronk87',6175558787,'gronk87@patriots.com','93','5th Street',10229;

SELECT l_name, COUNT (*) as cnt
FROM Customer
GROUP BY l_name
HAVING COUNT(*) > 3;
---------------------------------------------------------------------------------
--Aspect 4

CREATE TABLE Customer_Order(
order_id DECIMAL(12)NOT NULL,
cus_id DECIMAL(12),
package_id DECIMAL(12),
PRIMARY KEY (order_id)
);

CREATE TABLE Package(
package_id DECIMAL(12)NOT NULL,
order_id DECIMAL(12),
tracker_id DECIMAL(12),
PRIMARY KEY (package_id)
);

CREATE TABLE Shipment(
ship_id DECIMAL(12)NOT NULL,
product_id DECIMAL(12),
package_id DECIMAL(12),
ship_method_id DECIMAL(12),
PRIMARY KEY (ship_id)
);

CREATE TABLE Tracker(
tracker_id DECIMAL(12)NOT NULL,
PRIMARY KEY (tracker_id));

CREATE TABLE Shipping_Method(
ship_method_id DECIMAL(12)NOT NULL,
shipping_speed VARCHAR(20),
PRIMARY KEY (ship_method_id));

ALTER TABLE Customer_Order
ADD CONSTRAINT fk2_cus_id
FOREIGN KEY (cus_id)
REFERENCES Customer(cus_id);

ALTER TABLE Package
ADD CONSTRAINT fk_order_id
FOREIGN KEY (order_id)
REFERENCES Customer_Order(order_id);

ALTER TABLE Customer_Order
ADD prod_qty DECIMAL(4);

CREATE PROCEDURE CUST_PURCHASE
		@order_id_arg DECIMAL(12),
		@cus_id_arg DECIMAL(12),
		@package_id_arg DECIMAL(12),
		@prod_qty_arg DECIMAL(4),
		@ship_id_arg DECIMAL(12),
		@product_id_arg DECIMAL(12),
		@ship_method_id__arg DECIMAL(12)
AS
BEGIN
		INSERT INTO Customer_Order(
		order_id,cus_id,package_id,prod_qty)
		VALUES(@order_id_arg,@cus_id_arg,
		@package_id_arg,@prod_qty_arg);
		INSERT INTO Package(
		package_id,order_id)
		VALUES(@package_id_arg,@order_id_arg);
		INSERT INTO Shipment(
		ship_id,product_id,package_id,ship_method_id)
		VALUES(@ship_id_arg,@product_id_arg,@package_id_arg,
		@ship_method_id__arg);
END;


EXEC CUST_PURCHASE 1,1,1,3,1,2,1;
EXEC CUST_PURCHASE 2,2,2,1,2,1,2;
EXEC CUST_PURCHASE 3,3,3,5,3,9,2;
EXEC CUST_PURCHASE 4,1,4,5,4,5,1;
EXEC CUST_PURCHASE 5,3,5,4,5,9,2;
EXEC CUST_PURCHASE 6,4,6,3,6,7,2;
EXEC CUST_PURCHASE 7,1,7,1,7,3,1;
EXEC CUST_PURCHASE 8,4,8,4,8,3,2;
EXEC CUST_PURCHASE 9,5,9,1,9,3,2;
EXEC CUST_PURCHASE 10,6,10,1,10,3,1;
EXEC CUST_PURCHASE 11,7,11,1,11,9,1;



SELECT product_id, 
COUNT (*) as cnt
FROM Shipment
GROUP BY product_id
HAVING COUNT(*) > 2;

SELECT Shipment.product_id,Customer.cus_id,Customer.f_name,Customer.l_name,
Customer_Address.cus_st_num,Customer_Address.cus_st_name,Customer_Address.cus_zip
FROM Shipment
JOIN Package ON Shipment.package_id = Package.package_id
JOIN Customer_Order ON Customer_Order.order_id = Package.order_id
JOIN Customer ON Customer.cus_id = Customer_Order.cus_id
JOIN Customer_Account ON Customer_Account.cus_id = Customer.cus_id
JOIN Customer_Address ON Customer_Address.cus_acct_id = Customer_Account.cus_acct_id
ORDER BY product_id

--------------------------------------------------------------------------------------
--Aspect 5

ALTER TABLE Tracker
ADD order_id DECIMAL(12);

CREATE PROCEDURE TRACK_SHIPMENT
		@tracker_id_arg DECIMAL(12),
		@order_id_arg DECIMAL(12)
AS
BEGIN
		INSERT INTO Tracker(tracker_id,order_id)
		VALUES(@tracker_id_arg,@order_id_arg)
END;

EXEC TRACK_SHIPMENT 101,1;
EXEC TRACK_SHIPMENT 102,2;

EXEC TRACK_SHIPMENT 103,3;
EXEC TRACK_SHIPMENT 104,4;
EXEC TRACK_SHIPMENT 105,5;
EXEC TRACK_SHIPMENT 106,6;
EXEC TRACK_SHIPMENT 107,7;
EXEC TRACK_SHIPMENT 108,8;
EXEC TRACK_SHIPMENT 109,9;
EXEC TRACK_SHIPMENT 110,10;
EXEC TRACK_SHIPMENT 111,11;

CREATE INDEX ttl_qoh
ON Product (product_qoh);

--This index can improve search for product quantities on hand on Amazon's website. Product QOH is sparse and frequently searched.

