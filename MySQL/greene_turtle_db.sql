-- MySQL dump 10.13  Distrib 8.0.45, for macos15 (x86_64)
--
-- Host: localhost    Database: greene_turtle_db
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;



DROP TABLE IF EXISTS `event_inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_inquiries` (
  `inquiry_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `organization` varchar(100) DEFAULT NULL,
  `guests` int NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `preferred_datetime` datetime NOT NULL,
  `event_description` text,
  `catering_package` varchar(10) DEFAULT NULL,
  `inquiry_status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`inquiry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_inquiries`
--

LOCK TABLES `event_inquiries` WRITE;
/*!40000 ALTER TABLE `event_inquiries` DISABLE KEYS */;
INSERT INTO `event_inquiries` VALUES (1,'Sarah Mitchell','UMD Marketing Club',60,'sarah.mitchell@example.com','301-555-1122','2026-05-20 17:30:00','End of semester celebration with appetizers and drinks','Gold','pending','2026-04-08 18:01:45'),(2,'James Rodriguez','Rodriguez Family',25,'jrodriguez@example.com','240-555-3344','2026-06-05 13:00:00','Family birthday party with lunch service','Silver','pending','2026-04-08 18:01:45'),(3,'Olivia Chen','Tech Startup Meetup',80,'olivia.chen@example.com','202-555-7788','2026-07-12 18:00:00','Networking event with light catering and presentations','Platinum','pending','2026-04-08 18:01:45'),(4,'Emily Johnson','UMD Alumni Association',75,'emily.johnson@example.com','301-555-1234','2026-05-15 18:30:00','Graduation celebration with buffet and drinks','Gold','pending','2026-04-08 18:01:45'),(5,'Michael Carter','Carter Consulting Group',40,'mcarter@example.com','240-555-5678','2026-06-10 12:00:00','Corporate luncheon and networking event','Silver','pending','2026-04-08 18:01:45'),(6,'John Smith','ABC Corp',25,'john@example.com','555-1234','2026-05-10 18:00:00','Company dinner event','Gold','pending','2026-04-08 18:01:45'),(7,'Sarah Johnson',NULL,10,'sarah@example.com','555-5678','2026-05-15 12:00:00','Birthday party','Silver','pending','2026-04-08 18:01:45'),(8,'Mike Brown','Local Club',40,'mike@example.com','555-9999','2026-06-01 19:30:00','Fundraising event','Platinum','approved','2026-04-08 18:01:45');
/*!40000 ALTER TABLE `event_inquiries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_staff`
--

DROP TABLE IF EXISTS `event_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_staff` (
  `event_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`event_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `event_staff_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `event_staff_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_staff`
--

LOCK TABLES `event_staff` WRITE;
/*!40000 ALTER TABLE `event_staff` DISABLE KEYS */;
INSERT INTO `event_staff` VALUES (1,1),(2,1),(1,2),(2,2),(3,2);
/*!40000 ALTER TABLE `event_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `guests` int NOT NULL,
  `date` date NOT NULL,
  `time` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,'Birthday','Benjamin King','bking@gmail.com',20,'2026-05-07','06:00pm-09:00pm','Birthday party.'),(2,'Graduation Party','Sarah Johnson','sarah@gmail.com',35,'2026-06-06','01:00pm-04:00pm','Graduation celebration for the class of 2026.'),(3,'Anniversary Dinner','The Williams Family','williams@gmail.com',15,'2026-05-20','07:00pm-10:00pm','Anniversary dinner celebration.');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredients` (
  `IngredientID` int NOT NULL AUTO_INCREMENT,
  `IngredientName` varchar(100) DEFAULT NULL,
  `SupplierID` int DEFAULT NULL,
  PRIMARY KEY (`IngredientID`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `ingredients_ibfk_1` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients`
--

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `InventoryID` int NOT NULL AUTO_INCREMENT,
  `IngredientID` int NOT NULL,
  `SupplierID` int DEFAULT NULL,
  `InventoryName` varchar(100) NOT NULL,
  `CurrentStock` decimal(10,2) NOT NULL DEFAULT '0.00',
  `ExpirationDate` date DEFAULT NULL,
  `DateIn` date DEFAULT NULL,
  `StorageType` varchar(20) DEFAULT NULL,
  `ReorderQuantity` decimal(10,2) DEFAULT NULL,
  `ReorderDate` date DEFAULT NULL,
  `UnitsOfMeasure` varchar(20) NOT NULL,
  `UnitsPerPackage` decimal(10,2) DEFAULT NULL,
  `NumberOfPackages` int DEFAULT NULL,
  PRIMARY KEY (`InventoryID`),
  KEY `IngredientID` (`IngredientID`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`IngredientID`) REFERENCES `ingredients` (`IngredientID`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `date_of_birth` date NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `preferred_channel` varchar(20) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `promo_opt_in` tinyint(1) DEFAULT '0',
  `join_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `points` int DEFAULT '0',
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'Hannah','Lee','2003-04-12','hannah.lee@email.com','301-555-1111','Email','hannahlee1','temp123',1,'2025-01-15 10:00:00',1250),(2,'Marcus','Brown','2001-09-23','marcus.brown@email.com','240-555-2222','SMS','marcusbrown1','temp123',1,'2025-06-02 14:30:00',720),(3,'Sofia','Nguyen','2002-12-05','sofia.nguyen@email.com','443-555-3333','Email','sofian1','temp123',0,'2026-02-10 09:15:00',180);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;

CREATE TABLE `menu_items` (
  `menu_item_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `active_status` ENUM('active','inactive') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`menu_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;

INSERT INTO `menu_items`
(`menu_item_id`, `name`, `price`, `category`, `active_status`)
VALUES
(1,'Irish Stew',14.99,'Seasonal','active'),
(2,'Springy Market Salad',12.50,'Seasonal','active'),
(3,'Lucky Charms Bomb',8.00,'Seasonal','active'),
(4,'Clover’s Cheeseburger',13.75,'Seasonal','active'),
(5,'Corned Beef Handheld',12.75,'Seasonal','active'),
(6,'Guinness Float',6.50,'Seasonal','active'),
(7,'Burger',12.99,'Entree','active'),
(8,'Cheeseburger',10.99,'Entree','active'),
(9,'Chicken Wings',12.99,'Appetizer','active'),
(10,'Fries',4.99,'Side','active'),
(11,'Caesar Salad',8.99,'Salad','active'),
(12,'Fish Tacos',11.99,'Entree','active'),
(13,'Mozzarella Sticks',7.99,'Appetizer','active');

/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_recipe`
--

DROP TABLE IF EXISTS `menu_recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_recipe` (
  `MenuRecipeID` int NOT NULL AUTO_INCREMENT,
  `menu_item_id` int DEFAULT NULL,
  `IngredientID` int DEFAULT NULL,
  `QuantityPerServing` decimal(6,2) DEFAULT NULL,
  `Unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`MenuRecipeID`),
  KEY `menu_item_id` (`menu_item_id`),
  KEY `IngredientID` (`IngredientID`),
  CONSTRAINT `menu_recipe_ibfk_1` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`menu_item_id`),
  CONSTRAINT `menu_recipe_ibfk_2` FOREIGN KEY (`IngredientID`) REFERENCES `ingredients` (`IngredientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_recipe`
--

LOCK TABLES `menu_recipe` WRITE;
/*!40000 ALTER TABLE `menu_recipe` DISABLE KEYS */;
/*!40000 ALTER TABLE `menu_recipe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `OrderItemID` int NOT NULL AUTO_INCREMENT,
  `OrderID` int DEFAULT NULL,
  `menu_item_id` int DEFAULT NULL,
  `Quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`OrderItemID`),
  KEY `OrderID` (`OrderID`),
  KEY `menu_item_id` (`menu_item_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`menu_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `OrderID` int NOT NULL AUTO_INCREMENT,
  `TransactionDate` date DEFAULT NULL,
  `TransactionTime` time DEFAULT NULL,
  `PaymentMethod` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_calendar`
--

DROP TABLE IF EXISTS `promotion_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_calendar` (
  `promotion_id` int NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`promotion_id`,`date`),
  CONSTRAINT `promotion_calendar_ibfk_1` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_calendar`
--

LOCK TABLES `promotion_calendar` WRITE;
/*!40000 ALTER TABLE `promotion_calendar` DISABLE KEYS */;
INSERT INTO `promotion_calendar` VALUES (1,'2026-04-07'),(1,'2026-04-08'),(1,'2026-04-09'),(1,'2026-04-10');
/*!40000 ALTER TABLE `promotion_calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotion_items`
--

DROP TABLE IF EXISTS `promotion_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_items` (
  `promotion_id` int NOT NULL,
  `menu_item_id` int NOT NULL,
  PRIMARY KEY (`promotion_id`,`menu_item_id`),
  KEY `menu_item_id` (`menu_item_id`),
  CONSTRAINT `promotion_items_ibfk_1` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`promotion_id`) ON DELETE CASCADE,
  CONSTRAINT `promotion_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`menu_item_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotion_items`
--

LOCK TABLES `promotion_items` WRITE;
/*!40000 ALTER TABLE `promotion_items` DISABLE KEYS */;
INSERT INTO `promotion_items` VALUES (1,1),(3,1),(1,2),(2,2),(3,5),(1,6),(4,8),(1,9),(2,9),(3,9),(4,12),(1,13),(2,13);
/*!40000 ALTER TABLE `promotion_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `promotion_id` int NOT NULL AUTO_INCREMENT,
  `promotion_name` varchar(255) NOT NULL,
  `promotion_type` varchar(100) DEFAULT NULL,
  `description` text,
  `discount` decimal(5,2) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `recurring_day` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`promotion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'Happy Hour','Discount','20% off appetizers',20.00,'2026-04-07','2026-04-10','15:00:00','18:00:00',NULL),(2,'Happy Hour','Discount','Half off appetizers',50.00,'2026-04-01','2026-04-30','15:00:00','18:00:00','Friday'),(3,'Wing Night','BOGO','Buy one get one free wings',NULL,'2026-04-01','2026-05-01','17:00:00','21:00:00','Wednesday'),(4,'Lunch Special','Discount','20% off lunch items',20.00,'2026-04-01','2026-06-01','11:00:00','14:00:00','Monday');
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `date` date NOT NULL,
  `role` varchar(100) NOT NULL,
  `start_hour` decimal(4,2) NOT NULL,
  `end_hour` decimal(4,2) NOT NULL,
  `color` varchar(7) NOT NULL DEFAULT '#204631',
  `event_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `event_id` (`event_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,1,'2026-04-08','Hostess',10.50,15.00,'#204631',NULL),(2,2,'2026-04-08','Server',12.00,18.00,'#36845a',NULL);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift_requests`
--

DROP TABLE IF EXISTS `shift_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `shift_id` int DEFAULT NULL,
  `staff_id` int NOT NULL,
  `request_type` varchar(20) NOT NULL,
  `request_status` varchar(20) DEFAULT 'pending',
  `request_note` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `shift_id` (`shift_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `shift_requests_ibfk_1` FOREIGN KEY (`shift_id`) REFERENCES `staff_shifts` (`shift_id`) ON DELETE SET NULL,
  CONSTRAINT `shift_requests_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift_requests`
--

LOCK TABLES `shift_requests` WRITE;
/*!40000 ALTER TABLE `shift_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `shift_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `employee_code` varchar(20) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  `employment_status` varchar(20) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `weekly_hours` int DEFAULT '0',
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `employee_code` (`employee_code`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_availability`
--

DROP TABLE IF EXISTS `staff_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_availability` (
  `availability_id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `day_of_week` varchar(10) NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_unavailable` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`availability_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `staff_availability_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_availability`
--

LOCK TABLES `staff_availability` WRITE;
/*!40000 ALTER TABLE `staff_availability` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_schedule`
--

DROP TABLE IF EXISTS `staff_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `shift_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `event_title` varchar(100) NOT NULL,
  `display_color` varchar(20) DEFAULT '#204631',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`schedule_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `staff_schedule_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_schedule`
--

LOCK TABLES `staff_schedule` WRITE;
/*!40000 ALTER TABLE `staff_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_shifts`
--

DROP TABLE IF EXISTS `staff_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_shifts` (
  `shift_id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `day_of_week` varchar(10) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `shift_status` varchar(20) DEFAULT 'scheduled',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`shift_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `staff_shifts_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_shifts`
--

LOCK TABLES `staff_shifts` WRITE;
/*!40000 ALTER TABLE `staff_shifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `SupplierID` int NOT NULL AUTO_INCREMENT,
  `SupplierName` varchar(100) NOT NULL,
  `SupplierCity` varchar(50) DEFAULT NULL,
  `SupplierState` varchar(50) DEFAULT NULL,
  `SupplierZipCode` varchar(10) DEFAULT NULL,
  `SupplierSpecialty` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`SupplierID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;

INSERT INTO `suppliers`
(`SupplierID`, `SupplierName`, `SupplierCity`, `SupplierState`, `SupplierZipCode`, `SupplierSpecialty`)
VALUES
(1, 'Fresh Farms Produce', 'Baltimore', 'MD', '21201', 'Fresh Vegetables & Fruits'),
(2, 'Atlantic Seafood Co.', 'Annapolis', 'MD', '21401', 'Seafood Supplier'),
(3, 'Prime Meats Inc.', 'Washington', 'DC', '20002', 'Beef & Poultry'),
(4, 'Dairy Best LLC', 'Frederick', 'MD', '21701', 'Milk, Cheese, Eggs'),
(5, 'Golden Grain Bakery Supply', 'Rockville', 'MD', '20850', 'Bread & Baked Goods'),
(6, 'Spice World Distributors', 'Arlington', 'VA', '22201', 'Spices & Seasonings'),
(7, 'Green Valley Organics', 'Columbia', 'MD', '21044', 'Organic Produce'),
(8, 'Capital Beverage Co.', 'Silver Spring', 'MD', '20910', 'Soft Drinks & Beverages'),
(9, 'Metro Paper Supply', 'Hyattsville', 'MD', '20781', 'Packaging & Paper Goods'),
(10, 'Chesapeake Kitchen Supply', 'Towson', 'MD', '21204', 'Kitchen Equipment');

/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;
--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('customer','staff','admin') NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `preferred_channel` varchar(20) DEFAULT NULL,
  `promo_opt_in` tinyint(1) DEFAULT '0',
  `join_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `points` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Alyssa','Chen','Alyssa Chen','alyssa@gtstaff.com','alyssa','scrypt:32768:8:1$MoLNO95gyRYonVPi$8edf71167f06b56d58255cf3b16c68826128012a0c15e1f929414118178a9ad946bb0d8baab70364b2446ffd0c139ec9545144431102b4ef4a197d5ef31cad93','staff',NULL,NULL,NULL,0,'2026-04-08 18:01:45',0),(2,'Matt','Johnson','Matt Johnson','matt@gtstaff.com','matt','scrypt:32768:8:1$eI77fgy54DPo59IQ$e47b007f761834f0890af8da64481f8cefa7e3e82d27c60eb809dfce044749d4e4ea0556b4f29eea43487c7cd3efd170d8baa1adb01b58afb9251a4301e51d55','staff',NULL,NULL,NULL,0,'2026-04-08 18:01:45',0),(3,'John','Smith','John Smith','john@gtadmin.com','john','scrypt:32768:8:1$2Rx40woPxKqij6T8$badc808adecbfe07fa0cef347b8398da42d8d1a5856936b8c14f8580d32bb68e67704d48628fed9657506246311dbcd58281f69689863229975b32a41dd613bd','admin',NULL,NULL,NULL,0,'2026-04-08 18:15:56',0),(4,'Grace','Pat','Grace Pat','grace@gtadmin.com','grace','scrypt:32768:8:1$OFEdlCiznMM6K0Wg$4facf7e71b59953813fd32ea881d77d1a2dfc8b71d96aaea0fa7bcad075cd13294a4ad8eb7aaf25cd5459d0584c659f0810969adb84e6d52a6d1146566910dfc','admin',NULL,NULL,NULL,0,'2026-04-08 18:15:56',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-08 21:10:35
