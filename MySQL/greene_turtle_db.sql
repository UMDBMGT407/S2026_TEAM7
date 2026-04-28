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

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '9f5dd0cc-2926-11f1-b373-9020ee489e3f:1-82,
d6505e96-296d-11f1-9398-2777e1047024:1-101';

--
-- Table structure for table `booked_events`
--

DROP TABLE IF EXISTS `booked_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booked_events` (
  `event_id` int NOT NULL AUTO_INCREMENT,
  `inquiry_id` int DEFAULT NULL,
  `booked_datetime` datetime NOT NULL,
  `event_status` varchar(20) DEFAULT 'booked',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`event_id`),
  KEY `inquiry_id` (`inquiry_id`),
  CONSTRAINT `booked_events_ibfk_1` FOREIGN KEY (`inquiry_id`) REFERENCES `event_inquiries` (`inquiry_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booked_events`
--

LOCK TABLES `booked_events` WRITE;
/*!40000 ALTER TABLE `booked_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `booked_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_inquiries`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_inquiries`
--

LOCK TABLES `event_inquiries` WRITE;
/*!40000 ALTER TABLE `event_inquiries` DISABLE KEYS */;
INSERT INTO `event_inquiries` VALUES (1,'Sarah Mitchell','UMD Marketing Club',60,'sarah.mitchell@gmail.com','301-555-1122','2026-05-20 17:30:00','End of semester celebration with appetizers and drinks','Gold','pending','2026-04-08 18:01:45'),(2,'James Rodriguez','Rodriguez Family',25,'jrodriguez@gmail.com','240-555-3344','2026-06-05 13:00:00','Family birthday party with lunch service','Silver','pending','2026-04-08 18:01:45'),(3,'Olivia Chen','Tech Startup Meetup',80,'olivia.chen@gmail.com','202-555-7788','2026-07-12 18:00:00','Networking event with light catering and presentations','Platinum','pending','2026-04-08 18:01:45'),(4,'Emily Johnson','UMD Alumni Association',75,'emily.johnson@gmail.com','301-555-1234','2026-05-15 18:30:00','Graduation celebration with buffet and drinks','Gold','pending','2026-04-08 18:01:45'),(5,'Michael Carter','Carter Consulting Group',40,'mcarter@gmail.com','240-555-5678','2026-06-10 12:00:00','Corporate luncheon and networking event','Silver','pending','2026-04-08 18:01:45'),(6,'John Smith','ABC Corp',25,'john@gmail.com','555-1234','2026-05-10 18:00:00','Company dinner event','Gold','pending','2026-04-08 18:01:45'),(7,'Sarah Johnson',NULL,10,'sarah@gmail.com','555-5678','2026-05-15 12:00:00','Birthday party','Silver','pending','2026-04-08 18:01:45'),(8,'Mike Brown','Local Club',40,'mike@gmail.com','555-9999','2026-06-01 19:30:00','Fundraising event','Platinum','approved','2026-04-08 18:01:45'),(9,'Alex Turner','College Band',45,'alex.turner@gmail.com','301-555-2001','2026-06-10 18:00:00','Live music event','Gold','pending','2026-04-08 18:01:45'),(10,'Megan Davis','Book Club',15,'megan.davis@gmail.com','301-555-2002','2026-06-12 12:00:00','Brunch meetup','Silver','pending','2026-04-08 18:01:45'),(11,'Chris Evans','Fitness Group',30,'cevans@gmail.com','301-555-2003','2026-06-14 10:00:00','Post workout event','Silver','pending','2026-04-08 18:01:45'),(12,'Natalie Portman','Film Society',50,'natalie.p@gmail.com','301-555-2004','2026-06-15 19:00:00','Film screening','Platinum','pending','2026-04-08 18:01:45'),(13,'Ryan Reynolds','Comedy Club',60,'ryan.r@gmail.com','301-555-2005','2026-06-18 20:00:00','Comedy night','Gold','pending','2026-04-08 18:01:45'),(14,'Sophia Williams','Sorority Event',80,'sophia.w@gmail.com','301-555-2006','2026-06-20 18:30:00','Formal dinner','Platinum','pending','2026-04-08 18:01:45'),(15,'Daniel Kim','Startup Pitch',70,'daniel.kim@gmail.com','301-555-2007','2026-06-22 17:00:00','Pitch event','Gold','pending','2026-04-08 18:01:45'),(16,'Emma Watson','Charity Gala',100,'emma.w@gmail.com','301-555-2008','2026-06-25 19:30:00','Fundraiser','Platinum','pending','2026-04-08 18:01:45'),(17,'Liam Johnson','Birthday Party',20,'liam.j@gmail.com','301-555-2009','2026-06-27 14:00:00','Kids party','Silver','pending','2026-04-08 18:01:45'),(18,'Olivia Brown','Family Reunion',50,'olivia.b@gmail.com','301-555-2010','2026-06-29 13:00:00','Family lunch','Gold','pending','2026-04-08 18:01:45');
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
  CONSTRAINT `event_staff_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `event_inquiries` (`inquiry_id`) ON DELETE CASCADE,
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
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients`
--

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT INTO `ingredients` VALUES (1,'Chicken Breast',1),(2,'Ground Beef',1),(3,'Burger Buns',2),(4,'Hot Dog Buns',2),(5,'Lettuce',3),(6,'Tomatoes',3),(7,'Onions',3),(8,'Cheddar Cheese',4),(9,'Mozzarella Cheese',4),(10,'French Fries',5),(11,'Sweet Potato Fries',5),(12,'Ketchup',6),(13,'Mustard',6),(14,'Mayonnaise',6),(15,'BBQ Sauce',7),(16,'Buffalo Sauce',7),(17,'Ranch Dressing',8),(18,'Blue Cheese Dressing',8),(19,'Chicken Wings',9),(20,'Shrimp',9),(21,'Salmon Fillet',10),(22,'Steak',1),(23,'Eggs',2),(24,'Milk',2),(25,'Butter',3),(26,'Flour',3),(27,'Sugar',4),(28,'Salt',4),(29,'Black Pepper',5),(30,'Garlic Powder',5),(31,'Olive Oil',6),(32,'Vegetable Oil',6),(33,'Pasta',7),(34,'Rice',7),(35,'Tortillas',8),(36,'Nacho Chips',8),(37,'Salsa',9),(38,'Guacamole',9),(39,'Pickles',10),(40,'Jalapenos',10),(41,'Chicken Stock',1),(42,'Spinach',2),(43,'Teriyaki Sauce',3),(44,'Parmesan Cheese',4),(45,'Heavy Cream',5),(46,'Ice Cream',6),(47,'Chocolate Syrup',7),(48,'Whipped Cream',8),(49,'Coffee Beans',9),(50,'Tea Bags',10),(51,'Soda Syrup',1),(52,'Beer',2),(53,'Wine',3),(54,'Lemons',4),(55,'Limes',5),(56,'Mint Leaves',6),(57,'Simple Syrup',7),(58,'Club Soda',8),(59,'Orange Juice',9),(60,'Cranberry Juice',10);
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
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`InventoryID`),
  KEY `IngredientID` (`IngredientID`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`IngredientID`) REFERENCES `ingredients` (`IngredientID`),
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,1,1,'Chicken Breast',120.00,'2026-05-01','2026-04-15','Freezer',50.00,'2026-04-25','lbs',10.00,12,'active'),(2,2,1,'Ground Beef',95.00,'2026-04-28','2026-04-14','Freezer',40.00,'2026-04-24','lbs',10.00,10,'active'),(3,3,2,'Burger Buns',200.00,'2026-04-25','2026-04-18','Dry',100.00,'2026-04-23','units',20.00,10,'active'),(4,4,2,'Hot Dog Buns',150.00,'2026-04-25','2026-04-18','Dry',80.00,'2026-04-23','units',20.00,8,'active'),(5,5,3,'Lettuce',60.00,'2026-04-23','2026-04-20','Refrigerator',30.00,'2026-04-22','heads',10.00,6,'active'),(6,6,3,'Tomatoes',80.00,'2026-04-24','2026-04-19','Refrigerator',40.00,'2026-04-23','lbs',10.00,8,'active'),(7,7,3,'Onions',100.00,'2026-05-10','2026-04-18','Dry',50.00,'2026-04-28','lbs',10.00,10,'active'),(8,8,4,'Cheddar Cheese',75.00,'2026-05-05','2026-04-16','Refrigerator',30.00,'2026-04-27','lbs',5.00,15,'active'),(9,9,4,'Mozzarella Cheese',70.00,'2026-05-05','2026-04-16','Refrigerator',30.00,'2026-04-27','lbs',5.00,14,'active'),(10,10,5,'French Fries',200.00,'2026-06-01','2026-04-10','Freezer',100.00,'2026-04-26','lbs',20.00,10,'active'),(11,11,5,'Sweet Potato Fries',120.00,'2026-06-01','2026-04-10','Freezer',60.00,'2026-04-26','lbs',20.00,6,'active'),(12,12,6,'Ketchup',90.00,'2027-01-01','2026-03-01','Dry',40.00,'2026-05-01','bottles',12.00,8,'active'),(13,13,6,'Mustard',85.00,'2027-01-01','2026-03-01','Dry',40.00,'2026-05-01','bottles',12.00,7,'active'),(14,14,6,'Mayonnaise',70.00,'2026-10-01','2026-03-10','Refrigerator',30.00,'2026-04-30','bottles',12.00,6,'active'),(15,15,7,'BBQ Sauce',65.00,'2027-02-01','2026-03-15','Dry',30.00,'2026-05-05','bottles',12.00,5,'active'),(16,16,7,'Buffalo Sauce',60.00,'2027-02-01','2026-03-15','Dry',30.00,'2026-05-05','bottles',12.00,5,'active'),(17,17,8,'Ranch Dressing',55.00,'2026-09-01','2026-03-20','Refrigerator',25.00,'2026-04-29','bottles',12.00,5,'active'),(18,18,8,'Blue Cheese Dressing',50.00,'2026-09-01','2026-03-20','Refrigerator',25.00,'2026-04-29','bottles',12.00,4,'active'),(19,19,9,'Chicken Wings',180.00,'2026-05-15','2026-04-12','Freezer',90.00,'2026-04-27','lbs',20.00,9,'active'),(20,20,9,'Shrimp',140.00,'2026-05-10','2026-04-11','Freezer',70.00,'2026-04-26','lbs',10.00,14,'active'),(21,21,10,'Salmon Fillet',110.00,'2026-05-08','2026-04-12','Freezer',50.00,'2026-04-26','lbs',10.00,11,'active'),(22,22,1,'Steak',130.00,'2026-05-12','2026-04-13','Freezer',60.00,'2026-04-27','lbs',10.00,13,'active'),(23,23,2,'Eggs',300.00,'2026-05-01','2026-04-17','Refrigerator',150.00,'2026-04-24','units',30.00,10,'active'),(24,24,2,'Milk',100.00,'2026-04-25','2026-04-20','Refrigerator',50.00,'2026-04-23','gallons',5.00,20,'active'),(25,25,3,'Butter',80.00,'2026-05-15','2026-04-14','Refrigerator',40.00,'2026-04-28','lbs',5.00,16,'active'),(26,26,3,'Flour',200.00,'2026-08-01','2026-03-01','Dry',100.00,'2026-05-10','lbs',25.00,8,'active'),(27,27,4,'Sugar',180.00,'2026-08-01','2026-03-01','Dry',90.00,'2026-05-10','lbs',25.00,7,'active'),(28,28,4,'Salt',160.00,'2027-01-01','2026-02-01','Dry',80.00,'2026-05-15','lbs',25.00,6,'active'),(29,29,5,'Black Pepper',120.00,'2027-01-01','2026-02-01','Dry',60.00,'2026-05-15','lbs',10.00,12,'active'),(30,30,5,'Garlic Powder',110.00,'2027-01-01','2026-02-01','Dry',55.00,'2026-05-15','lbs',10.00,11,'active'),(31,31,6,'Olive Oil',90.00,'2027-05-01','2026-01-15','Dry',40.00,'2026-05-20','liters',5.00,18,'active'),(32,32,6,'Vegetable Oil',150.00,'2027-05-01','2026-01-15','Dry',70.00,'2026-05-20','liters',5.00,30,'active'),(33,33,7,'Pasta',170.00,'2026-09-01','2026-02-01','Dry',80.00,'2026-05-10','lbs',20.00,8,'active'),(34,34,7,'Rice',200.00,'2026-09-01','2026-02-01','Dry',100.00,'2026-05-10','lbs',25.00,8,'active'),(35,35,8,'Tortillas',140.00,'2026-05-01','2026-04-18','Refrigerator',60.00,'2026-04-24','units',20.00,7,'active'),(36,36,8,'Nacho Chips',160.00,'2026-07-01','2026-03-10','Dry',80.00,'2026-05-01','lbs',20.00,8,'active'),(37,37,9,'Salsa',130.00,'2026-08-01','2026-03-15','Dry',60.00,'2026-05-05','jars',12.00,10,'active'),(38,38,9,'Guacamole',90.00,'2026-04-24','2026-04-20','Refrigerator',40.00,'2026-04-22','lbs',5.00,18,'active'),(39,39,10,'Pickles',120.00,'2027-01-01','2026-02-01','Dry',60.00,'2026-05-15','jars',12.00,10,'active'),(40,40,10,'Jalapenos',100.00,'2027-01-01','2026-02-01','Dry',50.00,'2026-05-15','jars',12.00,8,'active'),(41,41,1,'Old Chicken Stock',10.00,'2026-04-10','2026-03-01','Freezer',20.00,'2026-04-05','lbs',10.00,1,'inactive'),(42,42,2,'Expired Lettuce',5.00,'2026-04-15','2026-04-10','Refrigerator',10.00,'2026-04-16','heads',5.00,1,'inactive'),(43,43,3,'Discontinued Sauce',20.00,'2026-06-01','2026-02-01','Dry',10.00,'2026-04-20','bottles',12.00,2,'inactive'),(44,44,4,'Old Cheese Batch',15.00,'2026-04-18','2026-03-20','Refrigerator',10.00,'2026-04-19','lbs',5.00,3,'inactive'),(45,45,5,'Spoiled Milk',8.00,'2026-04-20','2026-04-15','Refrigerator',10.00,'2026-04-21','gallons',5.00,2,'inactive'),(46,46,6,'Ice Cream',90.00,'2026-06-15','2026-04-10','Freezer',40.00,'2026-05-01','gallons',5.00,18,'active'),(47,47,7,'Chocolate Syrup',70.00,'2027-01-01','2026-02-01','Dry',30.00,'2026-05-15','bottles',12.00,6,'active'),(48,48,8,'Whipped Cream',60.00,'2026-05-01','2026-04-18','Refrigerator',30.00,'2026-04-25','cans',12.00,5,'active'),(49,49,9,'Coffee Beans',150.00,'2027-02-01','2026-01-15','Dry',70.00,'2026-05-20','lbs',20.00,7,'active'),(50,50,10,'Tea Bags',200.00,'2027-02-01','2026-01-15','Dry',100.00,'2026-05-20','units',50.00,4,'active'),(51,51,1,'Soda Syrup',180.00,'2027-01-01','2026-02-01','Dry',80.00,'2026-05-10','boxes',10.00,18,'active'),(52,52,2,'Beer Kegs',40.00,'2026-06-01','2026-04-10','Refrigerator',20.00,'2026-04-28','kegs',1.00,40,'active'),(53,53,3,'Wine Bottles',120.00,'2028-01-01','2026-01-01','Dry',60.00,'2026-06-01','bottles',12.00,10,'active'),(54,54,4,'Lemons',90.00,'2026-04-25','2026-04-20','Refrigerator',40.00,'2026-04-23','lbs',10.00,9,'active'),(55,55,5,'Limes',85.00,'2026-04-25','2026-04-20','Refrigerator',40.00,'2026-04-23','lbs',10.00,8,'active'),(56,56,6,'Mint Leaves',50.00,'2026-04-23','2026-04-20','Refrigerator',20.00,'2026-04-22','bunches',5.00,10,'active'),(57,57,7,'Simple Syrup',60.00,'2027-01-01','2026-02-01','Dry',30.00,'2026-05-15','liters',5.00,12,'active'),(58,58,8,'Club Soda',140.00,'2027-01-01','2026-02-01','Dry',60.00,'2026-05-15','cans',24.00,6,'active'),(59,59,9,'Orange Juice',100.00,'2026-05-01','2026-04-18','Refrigerator',50.00,'2026-04-25','gallons',5.00,20,'active'),(60,60,10,'Cranberry Juice',95.00,'2026-05-01','2026-04-18','Refrigerator',50.00,'2026-04-25','gallons',5.00,19,'active');
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
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'Hannah','Lee','2003-04-12','hannah.lee@gmail.com','301-555-1111','Email','hannahlee1','scrypt:32768:8:1$MoLNO95gyRYonVPi$8edf71167f06b56d58255cf3b16c68826128012a0c15e1f929414118178a9ad946bb0d8baab70364b2446ffd0c139ec9545144431102b4ef4a197d5ef31cad93',1,'2025-01-15 10:00:00'),(2,'Marcus','Brown','2001-09-23','marcus.brown@gmail.com','240-555-2222','SMS','marcusbrown1','scrypt:32768:8:1$MoLNO95gyRYonVPi$8edf71167f06b56d58255cf3b16c68826128012a0c15e1f929414118178a9ad946bb0d8baab70364b2446ffd0c139ec9545144431102b4ef4a197d5ef31cad93',1,'2025-06-02 14:30:00'),(3,'Sofia','Nguyen','2002-12-05','sofia.nguyen@gmail.com','443-555-3333','Email','sofian1','scrypt:32768:8:1$MoLNO95gyRYonVPi$8edf71167f06b56d58255cf3b16c68826128012a0c15e1f929414118178a9ad946bb0d8baab70364b2446ffd0c139ec9545144431102b4ef4a197d5ef31cad93',0,'2026-02-10 09:15:00'),(10,'Sarah','Sparkhawk','2003-06-26','sarah@gmail.com','1234567890','email','sarah@gmail.com','scrypt:32768:8:1$AQxhXP3eb9GFxAPj$ce8f08b98ebc2b6342514865f92c3b94c3c724feae2a04eb046ad39cca2f17912dd3aeba364c0a56f47e437f464e401a63d266ee84e5ebcd58c22a5811899ff6',1,'2026-04-28 00:25:54');
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
  `active_status` enum('active','inactive') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`menu_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,'Irish Stew',14.99,'Seasonal','active'),(2,'Springy Market Salad',12.50,'Seasonal','active'),(3,'Lucky Charms Bomb',8.00,'Seasonal','active'),(4,'Clover‚Äö√Ñ√¥s Cheeseburger',13.75,'Seasonal','active'),(5,'Corned Beef Handheld',12.75,'Seasonal','active'),(6,'Guinness Float',6.50,'Seasonal','active'),(7,'Burger',12.99,'Entree','active'),(8,'Cheeseburger',10.99,'Entree','active'),(9,'Chicken Wings',12.99,'Appetizer','active'),(10,'Fries',4.99,'Side','active'),(11,'Caesar Salad',8.99,'Salad','active'),(12,'Fish Tacos',11.99,'Entree','active'),(13,'Mozzarella Sticks',7.99,'Appetizer','active'),(14,'Soft Drink',3.99,'Drink','active'),(15,'Lemonade',4.49,'Drink','active'),(16,'Classic Burger',12.99,'Entree','active'),(17,'Cowboy Burger',14.99,'Entree','active'),(18,'Chicken Wrap',11.49,'Handheld','active'),(19,'Crabby Melt',15.99,'Handheld','active'),(20,'Fish and Chips',15.99,'Entree','active'),(21,'Chicken Alfredo',16.99,'Entree','active'),(22,'Shrimp Pasta',17.99,'Entree','active'),(23,'Onion Rings',8.00,'Appetizer','active'),(24,'Legendary Tenders',16.99,'Appetizer','active'),(25,'Chicken Quesadilla',12.00,'Appetizer','active'),(26,'Loaded Tater Tots',12.99,'Appetizer','active'),(27,'Loaded Nachos',11.99,'Appetizer','active'),(28,'Soft Drink',3.99,'Drink','active'),(29,'Lemonade',4.49,'Drink','active'),(30,'Classic Burger',12.99,'Entree','active'),(31,'Cowboy Burger',14.99,'Entree','active'),(32,'Chicken Wrap',11.49,'Handheld','active'),(33,'Crabby Melt',15.99,'Handheld','active'),(34,'Fish and Chips',15.99,'Entree','active'),(35,'Chicken Alfredo',16.99,'Entree','active'),(36,'Shrimp Pasta',17.99,'Entree','active'),(37,'Onion Rings',8.00,'Appetizer','active'),(38,'Legendary Tenders',16.99,'Appetizer','active'),(39,'Chicken Quesadilla',12.00,'Appetizer','active'),(40,'Loaded Tater Tots',12.99,'Appetizer','active'),(41,'Loaded Nachos',11.99,'Appetizer','active');
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
) ENGINE=InnoDB AUTO_INCREMENT=428 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,7,2),(2,1,10,1),(3,2,8,1),(4,2,12,1),(5,3,9,2),(6,3,13,1),(7,4,11,1),(8,4,10,2),(9,5,12,2),(10,5,13,1),(11,6,8,2),(12,6,10,1),(13,7,7,1),(14,7,13,2),(15,8,9,1),(16,8,12,2),(17,9,7,2),(18,9,10,1),(19,10,8,1),(20,10,12,1),(21,11,9,2),(22,11,13,1),(23,12,11,1),(24,12,10,2),(25,13,12,2),(26,13,13,1),(27,14,8,2),(28,14,10,1),(29,15,7,1),(30,15,13,2),(31,16,9,1),(32,16,12,2),(33,17,7,2),(34,17,10,1),(35,18,8,1),(36,18,12,1),(37,19,9,2),(38,19,13,1),(39,20,11,1),(40,20,10,2),(41,21,12,2),(42,21,13,1),(43,22,8,2),(44,22,10,1),(45,23,7,1),(46,23,13,2),(47,24,9,1),(48,24,12,2),(49,25,7,2),(50,25,10,1),(51,26,8,1),(52,26,12,1),(53,27,9,2),(54,27,13,1),(55,28,11,1),(56,28,10,2),(57,29,12,2),(58,29,13,1),(59,30,8,2),(60,30,10,1),(61,31,7,1),(62,31,13,2),(63,32,9,1),(64,32,12,2),(65,33,7,2),(66,33,10,1),(67,34,8,1),(68,34,12,1),(69,35,9,2),(70,35,13,1),(71,36,11,1),(72,36,10,2),(73,37,12,2),(74,37,13,1),(75,38,8,2),(76,38,10,1),(77,39,7,1),(78,39,13,2),(79,40,9,1),(80,40,12,2),(81,46,7,2),(82,46,10,1),(83,47,8,1),(84,47,12,1),(85,48,9,2),(86,48,13,1),(87,49,11,1),(88,49,10,2),(89,50,12,2),(90,50,13,1),(91,51,8,2),(92,51,10,1),(93,52,7,1),(94,52,13,2),(95,53,9,1),(96,53,12,2),(97,54,7,2),(98,54,10,1),(99,55,8,1),(100,55,12,1),(101,56,9,2),(102,56,13,1),(103,57,11,1),(104,57,10,2),(105,58,12,2),(106,58,13,1),(107,59,8,2),(108,59,10,1),(109,60,7,1),(110,60,13,2),(111,61,9,1),(112,61,12,2),(113,62,7,2),(114,62,10,1),(115,63,8,1),(116,63,12,1),(117,64,9,2),(118,64,13,1),(119,65,11,1),(120,65,10,2),(121,66,12,2),(122,66,13,1),(123,67,8,2),(124,67,10,1),(125,68,7,1),(126,68,13,2),(127,69,9,1),(128,69,12,2),(129,70,7,2),(130,70,10,1),(131,71,8,1),(132,71,12,1),(133,72,9,2),(134,72,13,1),(135,73,11,1),(136,73,10,2),(137,74,12,2),(138,74,13,1),(139,75,8,2),(140,75,10,1),(141,76,7,1),(142,76,13,2),(143,77,9,1),(144,77,12,2),(145,78,7,2),(146,78,10,1),(147,79,8,1),(148,79,12,1),(149,80,9,2),(150,80,13,1),(151,81,11,1),(152,81,10,2),(153,82,12,2),(154,82,13,1),(155,83,8,2),(156,83,10,1),(157,84,7,1),(158,84,13,2),(159,85,9,1),(160,85,12,2),(161,86,7,2),(162,86,10,1),(163,87,8,1),(164,87,12,1),(165,88,9,2),(166,88,13,1),(167,89,11,1),(168,89,10,2),(169,90,12,2),(170,90,13,1),(171,91,8,2),(172,91,10,1),(173,92,7,1),(174,92,13,2),(175,93,9,1),(176,93,12,2),(177,94,7,2),(178,94,10,1),(179,95,8,1),(180,95,12,1),(181,96,9,2),(182,96,13,1),(183,97,11,1),(184,97,10,2),(185,98,12,2),(186,98,13,1),(187,99,8,2),(188,99,10,1),(189,100,7,1),(190,100,13,2),(191,101,9,1),(192,101,12,2),(193,102,7,2),(194,102,10,1),(195,103,8,1),(196,103,12,1),(197,104,9,2),(198,104,13,1),(199,105,11,1),(200,105,10,2),(201,106,12,2),(202,106,13,1),(203,107,8,2),(204,107,10,1),(205,108,7,1),(206,108,13,2),(207,109,9,1),(208,109,12,2),(209,110,7,2),(210,110,10,1),(211,111,8,1),(212,111,12,1),(213,112,9,2),(214,112,13,1),(215,113,11,1),(216,113,10,2),(217,114,12,2),(218,114,13,1),(219,115,8,2),(220,115,10,1),(221,116,7,1),(222,116,13,2),(223,117,9,1),(224,117,12,2),(225,118,7,2),(226,118,10,1),(227,119,8,1),(228,119,12,1),(229,120,9,2),(230,120,13,1),(231,121,11,1),(232,121,10,2),(233,122,12,2),(234,122,13,1),(235,123,8,2),(236,123,10,1),(237,124,7,1),(238,124,13,2),(239,125,9,1),(240,125,12,2),(241,126,7,2),(242,126,10,1),(243,127,8,1),(244,127,12,1),(245,128,9,2),(246,128,13,1),(247,129,11,1),(248,129,10,2),(249,130,12,2),(250,130,13,1),(251,131,8,2),(252,131,10,1),(253,132,7,1),(254,132,13,2),(255,133,9,1),(256,133,12,2),(257,134,7,2),(258,134,10,1),(259,135,8,1),(260,135,12,1),(261,136,9,2),(262,136,13,1),(263,137,11,1),(264,137,10,2),(265,138,12,2),(266,138,13,1),(267,139,8,2),(268,139,10,1),(269,140,7,1),(270,140,13,2),(271,141,9,1),(272,141,12,2),(273,142,7,2),(274,142,10,1),(275,143,8,1),(276,143,12,1),(277,144,9,2),(278,144,13,1),(279,145,11,1),(280,145,10,2),(281,146,12,2),(282,146,13,1),(425,147,18,1),(426,147,19,1),(427,147,23,1);
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
  `OrderPrice` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'2026-04-01','12:15:22','Credit Card',24.50),(2,'2026-04-01','12:45:10','Cash',18.75),(3,'2026-04-01','13:05:33','Debit Card',32.10),(4,'2026-04-01','18:20:11','Credit Card',45.20),(5,'2026-04-02','11:05:44','Mobile Pay',15.60),(6,'2026-04-02','12:30:55','Cash',22.40),(7,'2026-04-02','13:45:12','Credit Card',38.90),(8,'2026-04-02','19:10:08','Debit Card',41.25),(9,'2026-04-03','12:10:19','Credit Card',27.80),(10,'2026-04-03','13:55:22','Mobile Pay',19.95),(11,'2026-04-03','17:35:41','Cash',34.60),(12,'2026-04-03','20:05:14','Credit Card',48.75),(13,'2026-04-04','11:50:33','Debit Card',21.30),(14,'2026-04-04','12:40:27','Credit Card',29.40),(15,'2026-04-04','14:15:09','Mobile Pay',17.85),(16,'2026-04-04','18:55:45','Cash',36.90),(17,'2026-04-05','12:05:12','Credit Card',25.60),(18,'2026-04-05','13:25:30','Debit Card',31.75),(19,'2026-04-05','15:10:44','Mobile Pay',20.10),(20,'2026-04-05','19:45:01','Credit Card',52.30),(21,'2026-04-06','11:30:21','Cash',16.45),(22,'2026-04-06','12:55:33','Credit Card',28.90),(23,'2026-04-06','14:40:50','Debit Card',33.20),(24,'2026-04-06','20:15:18','Mobile Pay',44.85),(25,'2026-04-07','12:20:05','Credit Card',26.70),(26,'2026-04-07','13:35:44','Cash',19.80),(27,'2026-04-07','16:10:29','Debit Card',35.40),(28,'2026-04-07','18:45:56','Mobile Pay',42.10),(29,'2026-04-08','11:55:14','Credit Card',23.95),(30,'2026-04-08','12:50:32','Cash',18.20),(31,'2026-04-08','14:25:47','Debit Card',30.75),(32,'2026-04-08','19:35:20','Credit Card',47.60),(33,'2026-04-09','12:05:33','Mobile Pay',21.90),(34,'2026-04-09','13:15:22','Cash',17.50),(35,'2026-04-09','17:50:44','Credit Card',39.85),(36,'2026-04-09','20:10:11','Debit Card',43.70),(37,'2026-04-10','11:40:25','Credit Card',24.30),(38,'2026-04-10','12:35:39','Mobile Pay',19.25),(39,'2026-04-10','14:55:02','Cash',31.60),(40,'2026-04-10','19:20:18','Debit Card',46.90),(46,'2026-04-15','21:54:15','Credit Card',55.25),(47,'2026-04-11','11:25:14','Cash',17.90),(48,'2026-04-11','12:10:33','Credit Card',26.40),(49,'2026-04-11','13:45:55','Debit Card',31.75),(50,'2026-04-11','18:20:10','Mobile Pay',42.60),(51,'2026-04-11','20:05:44','Credit Card',48.25),(52,'2026-04-12','11:05:22','Cash',18.30),(53,'2026-04-12','12:50:11','Credit Card',27.95),(54,'2026-04-12','14:15:39','Debit Card',33.10),(55,'2026-04-12','18:45:20','Mobile Pay',41.85),(56,'2026-04-12','20:30:05','Credit Card',52.40),(57,'2026-04-13','11:15:10','Cash',16.75),(58,'2026-04-13','12:40:22','Credit Card',25.90),(59,'2026-04-13','13:55:41','Debit Card',34.60),(60,'2026-04-13','18:10:33','Mobile Pay',43.25),(61,'2026-04-13','19:55:50','Credit Card',49.90),(62,'2026-04-14','11:30:18','Cash',19.20),(63,'2026-04-14','12:55:45','Credit Card',28.75),(64,'2026-04-14','14:20:09','Debit Card',36.10),(65,'2026-04-14','18:50:27','Mobile Pay',44.90),(66,'2026-04-14','20:15:36','Credit Card',53.70),(67,'2026-04-15','11:10:40','Cash',17.45),(68,'2026-04-15','12:35:28','Credit Card',26.85),(69,'2026-04-15','13:50:17','Debit Card',32.95),(70,'2026-04-15','18:05:59','Mobile Pay',41.60),(71,'2026-04-15','20:25:13','Credit Card',54.30),(72,'2026-04-16','11:20:05','Cash',18.90),(73,'2026-04-16','12:45:12','Credit Card',29.10),(74,'2026-04-16','14:05:36','Debit Card',35.80),(75,'2026-04-16','18:30:21','Mobile Pay',45.25),(76,'2026-04-16','20:50:44','Credit Card',56.10),(77,'2026-04-17','11:35:18','Cash',19.60),(78,'2026-04-17','12:55:09','Credit Card',30.25),(79,'2026-04-17','14:25:50','Debit Card',37.15),(80,'2026-04-17','18:40:33','Mobile Pay',46.80),(81,'2026-04-17','21:05:11','Credit Card',57.25),(82,'2026-04-18','11:10:44','Cash',17.30),(83,'2026-04-18','12:30:12','Credit Card',27.50),(84,'2026-04-18','14:00:28','Debit Card',34.20),(85,'2026-04-18','18:20:15','Mobile Pay',43.70),(86,'2026-04-18','20:45:39','Credit Card',55.90),(87,'2026-04-19','11:25:55','Cash',18.10),(88,'2026-04-19','12:50:33','Credit Card',28.60),(89,'2026-04-19','14:15:49','Debit Card',36.50),(90,'2026-04-19','18:35:10','Mobile Pay',45.40),(91,'2026-04-19','21:00:05','Credit Card',58.30),(92,'2026-04-20','11:05:22','Cash',16.95),(93,'2026-04-20','12:40:11','Credit Card',26.75),(94,'2026-04-20','13:55:44','Debit Card',33.60),(95,'2026-04-20','18:15:27','Mobile Pay',42.90),(96,'2026-04-20','20:35:18','Credit Card',54.80),(97,'2026-04-21','11:30:39','Cash',18.50),(98,'2026-04-21','12:55:20','Credit Card',29.85),(99,'2026-04-21','14:20:07','Debit Card',35.95),(100,'2026-04-21','18:45:52','Mobile Pay',44.70),(101,'2026-04-21','21:10:16','Credit Card',56.40),(102,'2026-04-22','11:15:03','Cash',17.80),(103,'2026-04-22','12:35:29','Credit Card',27.95),(104,'2026-04-22','14:05:41','Debit Card',34.85),(105,'2026-04-22','18:25:36','Mobile Pay',43.60),(106,'2026-04-22','20:50:02','Credit Card',55.10),(107,'2026-04-23','11:40:11','Cash',19.10),(108,'2026-04-23','12:55:58','Credit Card',30.40),(109,'2026-04-23','14:15:35','Debit Card',37.00),(110,'2026-04-23','18:35:49','Mobile Pay',46.20),(111,'2026-04-23','21:05:27','Credit Card',57.80),(112,'2026-04-24','11:10:17','Cash',17.60),(113,'2026-04-24','12:30:44','Credit Card',28.10),(114,'2026-04-24','14:00:50','Debit Card',35.40),(115,'2026-04-24','18:20:12','Mobile Pay',44.10),(116,'2026-04-24','20:45:55','Credit Card',55.75),(117,'2026-04-25','11:25:09','Cash',18.70),(118,'2026-04-25','12:45:38','Credit Card',29.60),(119,'2026-04-25','14:10:21','Debit Card',36.90),(120,'2026-04-25','18:30:47','Mobile Pay',45.50),(121,'2026-04-25','21:00:14','Credit Card',58.90),(122,'2026-04-26','11:05:33','Cash',16.85),(123,'2026-04-26','12:35:12','Credit Card',27.20),(124,'2026-04-26','14:05:58','Debit Card',34.10),(125,'2026-04-26','18:25:45','Mobile Pay',42.75),(126,'2026-04-26','20:50:29','Credit Card',54.60),(127,'2026-04-27','11:20:48','Cash',18.40),(128,'2026-04-27','12:45:36','Credit Card',29.10),(129,'2026-04-27','14:15:17','Debit Card',36.30),(130,'2026-04-27','18:35:54','Mobile Pay',44.85),(131,'2026-04-27','21:10:03','Credit Card',57.00),(132,'2026-04-28','11:35:21','Cash',19.00),(133,'2026-04-28','12:55:47','Credit Card',30.55),(134,'2026-04-28','14:25:33','Debit Card',37.25),(135,'2026-04-28','18:45:10','Mobile Pay',46.90),(136,'2026-04-28','21:05:58','Credit Card',59.20),(137,'2026-04-29','11:10:29','Cash',17.25),(138,'2026-04-29','12:30:18','Credit Card',27.75),(139,'2026-04-29','14:00:41','Debit Card',34.55),(140,'2026-04-29','18:20:36','Mobile Pay',43.35),(141,'2026-04-29','20:45:11','Credit Card',55.60),(142,'2026-04-30','11:25:14','Cash',18.90),(143,'2026-04-30','12:50:39','Credit Card',29.95),(144,'2026-04-30','14:15:28','Debit Card',36.75),(145,'2026-04-30','18:35:42','Mobile Pay',45.10),(146,'2026-04-30','21:00:07','Credit Card',58.50),(147,'2026-04-28','00:15:04','Credit Card',NULL);
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
INSERT INTO `promotion_calendar` VALUES (1,'2026-04-07'),(1,'2026-04-08'),(1,'2026-04-09'),(1,'2026-04-10'),(5,'2026-05-01'),(6,'2026-05-01'),(7,'2026-05-05'),(8,'2026-05-06'),(9,'2026-05-07'),(10,'2026-05-05'),(11,'2026-05-06'),(12,'2026-06-01'),(12,'2026-06-02'),(13,'2026-08-20'),(14,'2026-05-07'),(15,'2026-05-10'),(16,'2026-05-11'),(17,'2026-05-13'),(18,'2026-09-06'),(19,'2026-12-15');
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
INSERT INTO `promotions` VALUES (1,'Happy Hour','Discount','20% off appetizers',20.00,'2026-04-07','2026-04-10','15:00:00','18:00:00',NULL),(2,'Happy Hour','Discount','Half off appetizers',50.00,'2026-04-01','2026-04-30','15:00:00','18:00:00','Friday'),(3,'Wing Night','BOGO','Buy one get one free wings',NULL,'2026-04-01','2026-05-01','17:00:00','21:00:00','Wednesday'),(4,'Lunch Special','Discount','20% off lunch items',20.00,'2026-04-01','2026-06-01','11:00:00','14:00:00','Monday'),(5,'Happy Hour','Discount','25% off appetizers and drinks',25.00,'2026-05-01','2026-06-30','15:00:00','18:00:00','Friday'),(6,'Late Night Bites','Discount','15% off all appetizers after 9PM',15.00,'2026-05-01','2026-07-31','21:00:00','23:59:00',NULL),(7,'Taco Tuesday','Discount','20% off all tacos',20.00,'2026-05-01','2026-12-31','11:00:00','22:00:00','Tuesday'),(8,'Wing Wednesday','BOGO','Buy one get one free wings',NULL,'2026-05-01','2026-12-31','16:00:00','22:00:00','Wednesday'),(9,'Thirsty Thursday','Discount','Half off draft beers',50.00,'2026-05-01','2026-12-31','17:00:00','22:00:00','Thursday'),(10,'Lunch Combo Deal','Discount','10% off lunch combos',10.00,'2026-05-01','2026-08-31','11:00:00','14:00:00',NULL),(11,'Business Lunch Special','Discount','15% off meals for groups of 4+',15.00,'2026-05-01','2026-09-01','11:00:00','14:00:00',NULL),(12,'Summer Kickoff','Discount','20% off entire menu for opening weekend',20.00,'2026-06-01','2026-06-03',NULL,NULL,NULL),(13,'Back to School Special','Discount','15% off for students with ID',15.00,'2026-08-20','2026-09-15',NULL,NULL,NULL),(14,'Family Feast Deal','Discount','25% off orders for groups of 6+',25.00,'2026-05-15','2026-12-31',NULL,NULL,NULL),(15,'Kids Eat Free','BOGO','Free kids meal with adult entr√©e purchase',NULL,'2026-05-01','2026-12-31','17:00:00','20:00:00','Sunday'),(16,'Margarita Monday','Discount','30% off all margaritas',30.00,'2026-05-01','2026-12-31','16:00:00','22:00:00','Monday'),(17,'Wine Down Wednesday','Discount','25% off all wine bottles',25.00,'2026-05-01','2026-12-31','17:00:00','22:00:00','Wednesday'),(18,'Game Day Special','Discount','15% off during game days',15.00,'2026-09-01','2026-12-31',NULL,NULL,NULL),(19,'Holiday Special','Discount','20% off select holiday menu items',20.00,'2026-12-15','2026-12-31',NULL,NULL,NULL);
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
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event_inquiries` (`inquiry_id`) ON DELETE SET NULL
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
  CONSTRAINT `shift_requests_ibfk_1` FOREIGN KEY (`shift_id`) REFERENCES `schedule` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shift_requests_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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
-- Table structure for table `staff_availability`
--

DROP TABLE IF EXISTS `staff_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_availability` (
  `availability_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `day_of_week` varchar(10) NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_unavailable` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`availability_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `staff_availability_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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
-- Table structure for table `supplier_availability`
--

DROP TABLE IF EXISTS `supplier_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_availability` (
  `availability_id` int NOT NULL AUTO_INCREMENT,
  `SupplierID` int NOT NULL,
  `submission_date` date DEFAULT (curdate()),
  `submission_time` time DEFAULT (curtime()),
  `selected_date` date NOT NULL,
  `selected_time` time NOT NULL,
  PRIMARY KEY (`availability_id`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `supplier_availability_ibfk_1` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`SupplierID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_availability`
--

LOCK TABLES `supplier_availability` WRITE;
/*!40000 ALTER TABLE `supplier_availability` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplier_availability` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Fresh Farms Produce','Baltimore','MD','21201','Fresh Vegetables & Fruits'),(2,'Atlantic Seafood Co.','Annapolis','MD','21401','Seafood Supplier'),(3,'Prime Meats Inc.','Washington','DC','20002','Beef & Poultry'),(4,'Dairy Best LLC','Frederick','MD','21701','Milk, Cheese, Eggs'),(5,'Golden Grain Bakery Supply','Rockville','MD','20850','Bread & Baked Goods'),(6,'Spice World Distributors','Arlington','VA','22201','Spices & Seasonings'),(7,'Green Valley Organics','Columbia','MD','21044','Organic Produce'),(8,'Capital Beverage Co.','Silver Spring','MD','20910','Soft Drinks & Beverages'),(9,'Metro Paper Supply','Hyattsville','MD','20781','Packaging & Paper Goods'),(10,'Chesapeake Kitchen Supply','Towson','MD','21204','Kitchen Equipment');
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
  `active_status` enum('active','inactive') NOT NULL DEFAULT 'active',
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
INSERT INTO `users` VALUES (1,'Alyssa','Chen','Alyssa Chen','alyssa@gtstaff.com','alyssa','scrypt:32768:8:1$MoLNO95gyRYonVPi$8edf71167f06b56d58255cf3b16c68826128012a0c15e1f929414118178a9ad946bb0d8baab70364b2446ffd0c139ec9545144431102b4ef4a197d5ef31cad93','staff',NULL,NULL,NULL,0,'2026-04-08 18:01:45',0,'active'),(2,'Matt','Johnson','Matt Johnson','matt@gtstaff.com','matt','scrypt:32768:8:1$eI77fgy54DPo59IQ$e47b007f761834f0890af8da64481f8cefa7e3e82d27c60eb809dfce044749d4e4ea0556b4f29eea43487c7cd3efd170d8baa1adb01b58afb9251a4301e51d55','staff',NULL,NULL,NULL,0,'2026-04-08 18:01:45',0,'active'),(3,'John','Smith','John Smith','john@gtadmin.com','john','scrypt:32768:8:1$2Rx40woPxKqij6T8$badc808adecbfe07fa0cef347b8398da42d8d1a5856936b8c14f8580d32bb68e67704d48628fed9657506246311dbcd58281f69689863229975b32a41dd613bd','admin',NULL,NULL,NULL,0,'2026-04-08 18:15:56',0,'active'),(4,'Grace','Pat','Grace Pat','grace@gtadmin.com','grace','scrypt:32768:8:1$OFEdlCiznMM6K0Wg$4facf7e71b59953813fd32ea881d77d1a2dfc8b71d96aaea0fa7bcad075cd13294a4ad8eb7aaf25cd5459d0584c659f0810969adb84e6d52a6d1146566910dfc','admin',NULL,NULL,NULL,0,'2026-04-08 18:15:56',0,'active');
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

-- Dump completed on 2026-04-28  0:55:59
