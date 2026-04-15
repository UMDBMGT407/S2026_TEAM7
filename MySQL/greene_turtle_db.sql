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
(4,'Clover‚Äôs Cheeseburger',13.75,'Seasonal','active'),
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

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;

INSERT INTO `order_items` (`OrderItemID`, `OrderID`, `menu_item_id`, `Quantity`) VALUES
(1,1,7,2),
(2,1,10,1),
(3,2,8,1),
(4,2,10,2),
(5,3,9,1),
(6,3,10,1),
(7,4,12,2),
(8,4,13,1),
(9,5,11,1),
(10,5,10,1),
(11,6,7,1),
(12,6,13,2),
(13,7,8,2),
(14,7,10,1),
(15,8,9,2),
(16,8,12,1),
(17,9,7,1),
(18,9,10,2),
(19,10,8,1),
(20,10,13,1),
(21,11,12,2),
(22,11,10,1),
(23,12,9,1),
(24,12,13,2),
(25,13,11,2),
(26,13,10,1),
(27,14,7,2),
(28,14,12,1),
(29,15,8,1),
(30,15,10,2),
(31,16,9,2),
(32,16,13,1),
(33,17,7,1),
(34,17,10,1),
(35,18,8,2),
(36,18,12,1),
(37,19,11,1),
(38,19,13,2),
(39,20,9,2),
(40,20,10,1),
(41,21,7,2),
(42,21,13,1),
(43,22,8,1),
(44,22,10,2),
(45,23,12,2),
(46,23,13,1),
(47,24,9,1),
(48,24,10,1),
(49,25,11,2),
(50,25,12,1),
(51,26,7,1),
(52,26,10,2),
(53,27,8,2),
(54,27,13,1),
(55,28,9,1),
(56,28,10,1),
(57,29,12,2),
(58,29,13,2),
(59,30,7,2),
(60,30,10,1),
(61,31,8,1),
(62,31,12,1),
(63,32,11,2),
(64,32,10,2),
(65,33,9,2),
(66,33,13,1),
(67,34,7,1),
(68,34,10,1),
(69,35,8,2),
(70,35,13,2),
(71,36,12,1),
(72,36,10,2),
(73,37,9,2),
(74,37,12,1),
(75,38,11,1),
(76,38,10,1),
(77,39,7,2),
(78,39,13,1),
(79,40,8,1),
(80,40,10,2),
(81,41,9,1),
(82,41,12,2),
(83,42,7,2),
(84,42,10,1),
(85,43,8,2),
(86,43,13,1),
(87,44,11,1),
(88,44,10,2),
(89,45,12,2),
(90,45,13,1),
(91,46,9,1),
(92,46,10,1),
(93,47,7,2),
(94,47,12,1),
(95,48,8,1),
(96,48,10,2),
(97,49,11,2),
(98,49,13,1),
(99,50,9,2),
(100,50,10,1),
(101,51,7,1),
(102,51,13,2),
(103,52,8,2),
(104,52,10,1),
(105,53,12,1),
(106,53,13,2),
(107,54,9,2),
(108,54,10,1),
(109,55,11,1),
(110,55,12,1),
(111,56,7,2),
(112,56,10,2),
(113,57,8,1),
(114,57,13,1),
(115,58,9,2),
(116,58,12,1),
(117,59,7,1),
(118,59,10,1),
(119,60,8,2),
(120,60,13,2),
(121,61,11,2),
(122,61,10,1),
(123,62,12,1),
(124,62,13,1),
(125,63,9,2),
(126,63,10,2),
(127,64,7,2),
(128,64,12,1),
(129,65,8,1),
(130,65,10,1),
(131,66,11,1),
(132,66,13,2),
(133,67,9,2),
(134,67,10,1),
(135,68,12,2),
(136,68,13,1),
(137,69,7,1),
(138,69,10,2),
(139,70,8,2),
(140,70,12,1),
(141,71,11,2),
(142,71,13,1),
(143,72,9,1),
(144,72,10,1),
(145,73,7,2),
(146,73,13,1),
(147,74,8,1),
(148,74,10,2),
(149,75,12,2),
(150,75,10,1),
(151,76,9,2),
(152,76,13,1),
(153,77,11,1),
(154,77,12,2),
(155,78,7,2),
(156,78,10,1),
(157,79,8,1),
(158,79,13,2),
(159,80,9,2),
(160,80,10,1),
(161,81,7,1),
(162,81,12,1),
(163,82,8,2),
(164,82,10,2),
(165,83,11,2),
(166,83,13,1),
(167,84,12,1),
(168,84,10,1),
(169,85,9,2),
(170,85,13,2),
(171,86,7,2),
(172,86,10,1),
(173,87,8,1),
(174,87,12,1),
(175,88,11,1),
(176,88,10,2),
(177,89,9,2),
(178,89,13,1),
(179,90,12,2),
(180,90,10,1),
(181,91,7,1),
(182,91,13,2),
(183,92,8,2),
(184,92,10,1),
(185,93,11,2),
(186,93,12,1),
(187,94,9,1),
(188,94,10,2),
(189,95,7,2),
(190,95,13,1),
(191,96,8,1),
(192,96,10,1),
(193,97,12,2),
(194,97,13,2),
(195,98,11,1),
(196,98,10,1),
(197,99,9,2),
(198,99,12,1),
(199,100,7,1),
(200,100,10,2),
(201,101,8,2),
(202,101,13,1),
(203,102,9,1),
(204,102,10,1),
(205,103,11,2),
(206,103,12,1),
(207,104,7,2),
(208,104,13,1),
(209,105,8,1),
(210,105,10,2),
(211,106,12,2),
(212,106,10,1),
(213,107,9,2),
(214,107,13,1),
(215,108,11,1),
(216,108,10,1),
(217,109,7,2),
(218,109,12,1),
(219,110,8,1),
(220,110,13,2),
(221,111,9,2),
(222,111,10,1),
(223,112,7,1),
(224,112,10,2),
(225,113,8,2),
(226,113,12,1),
(227,114,11,2),
(228,114,13,1),
(229,115,9,1),
(230,115,10,1),
(231,116,12,2),
(232,116,13,1),
(233,117,7,2),
(234,117,10,1),
(235,118,8,1),
(236,118,12,1),
(237,119,11,1),
(238,119,13,2),
(239,120,9,2),
(240,120,10,1),
(241,121,7,1),
(242,121,13,2),
(243,122,8,2),
(244,122,10,1),
(245,123,12,1),
(246,123,13,2),
(247,124,9,2),
(248,124,10,1),
(249,125,11,1),
(250,125,12,1),
(251,126,7,2),
(252,126,10,2),
(253,127,8,1),
(254,127,13,1),
(255,128,9,2),
(256,128,12,1),
(257,129,7,1),
(258,129,10,1),
(259,130,8,2),
(260,130,13,2),
(261,131,11,2),
(262,131,10,1),
(263,132,12,1),
(264,132,13,1),
(265,133,9,2),
(266,133,10,2),
(267,134,7,2),
(268,134,12,1),
(269,135,8,1),
(270,135,10,1),
(271,136,11,1),
(272,136,13,2),
(273,137,9,2),
(274,137,10,1),
(275,138,12,2),
(276,138,13,1),
(277,139,7,1),
(278,139,10,2),
(279,140,8,2),
(280,140,12,1),
(281,141,11,2),
(282,141,13,1),
(283,142,9,1),
(284,142,10,1),
(285,143,7,2),
(286,143,13,1),
(287,144,8,1),
(288,144,10,2),
(289,145,12,2),
(290,145,10,1),
(291,146,9,2),
(292,146,13,1),
(293,147,11,1),
(294,147,12,2),
(295,148,7,2),
(296,148,10,1),
(297,149,8,1),
(298,149,13,2),
(299,150,9,2),
(300,150,10,1),
(301,151,7,1),
(302,151,12,1),
(303,152,8,2),
(304,152,10,2),
(305,153,11,2),
(306,153,13,1),
(307,154,12,1),
(308,154,10,1),
(309,155,9,2),
(310,155,13,2),
(311,156,7,2),
(312,156,10,1),
(313,157,8,1),
(314,157,12,1),
(315,158,11,1),
(316,158,10,2),
(317,159,9,2),
(318,159,13,1),
(319,160,12,2),
(320,160,10,1),
(321,161,7,1),
(322,161,13,2),
(323,162,8,2),
(324,162,10,1),
(325,163,11,2),
(326,163,12,1),
(327,164,9,1),
(328,164,10,2),
(329,165,7,2),
(330,165,13,1),
(331,166,8,1),
(332,166,10,1),
(333,167,12,2),
(334,167,13,2),
(335,168,11,1),
(336,168,10,1),
(337,169,9,2),
(338,169,12,1),
(339,170,7,1),
(340,170,10,2),
(341,171,8,2),
(342,171,13,1),
(343,172,9,1),
(344,172,10,1),
(345,173,11,2),
(346,173,12,1),
(347,174,7,2),
(348,174,13,1),
(349,175,8,1),
(350,175,10,2),
(351,176,12,2),
(352,176,10,1),
(353,177,9,2),
(354,177,13,1),
(355,178,11,1),
(356,178,10,1),
(357,179,7,2),
(358,179,12,1),
(359,180,8,1),
(360,180,13,2),
(361,181,9,2),
(362,181,10,1),
(363,182,7,1),
(364,182,10,2),
(365,183,8,2),
(366,183,12,1),
(367,184,11,2),
(368,184,13,1),
(369,185,9,1),
(370,185,10,1),
(371,186,12,2),
(372,186,13,1),
(373,187,7,2),
(374,187,10,1),
(375,188,8,1),
(376,188,12,1),
(377,189,11,1),
(378,189,13,2),
(379,190,9,2),
(380,190,10,1),
(381,191,7,1),
(382,191,13,2),
(383,192,8,2),
(384,192,10,1),
(385,193,12,1),
(386,193,13,2),
(387,194,9,2),
(388,194,10,1),
(389,195,11,1),
(390,195,12,1),
(391,196,7,2),
(392,196,10,2),
(393,197,8,1),
(394,197,13,1),
(395,198,9,2),
(396,198,12,1),
(397,199,7,1),
(398,199,10,1),
(399,200,8,2),
(400,200,13,2),
(401,201,11,2),
(402,201,10,1),
(403,202,12,1),
(404,202,13,1),
(405,203,9,2),
(406,203,10,2),
(407,204,7,2),
(408,204,12,1),
(409,205,8,1),
(410,205,10,1),
(411,206,11,1),
(412,206,13,2),
(413,207,9,2),
(414,207,10,1),
(415,208,12,2),
(416,208,13,1),
(417,209,7,1),
(418,209,10,2),
(419,210,8,2),
(420,210,12,1);

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

INSERT INTO `orders` 
(`OrderID`, `TransactionDate`, `TransactionTime`, `PaymentMethod`)
VALUES
(1,'2026-04-01','12:15:22','Credit Card'),
(2,'2026-04-01','12:45:10','Cash'),
(3,'2026-04-01','13:05:33','Debit Card'),
(4,'2026-04-01','18:20:11','Credit Card'),
(5,'2026-04-02','11:05:44','Mobile Pay'),
(6,'2026-04-02','12:30:55','Cash'),
(7,'2026-04-02','13:45:12','Credit Card'),
(8,'2026-04-02','19:10:08','Debit Card'),
(9,'2026-04-03','12:10:19','Credit Card'),
(10,'2026-04-03','13:55:22','Mobile Pay'),
(11,'2026-04-03','17:35:41','Cash'),
(12,'2026-04-03','20:05:14','Credit Card'),
(13,'2026-04-04','11:50:33','Debit Card'),
(14,'2026-04-04','12:40:27','Credit Card'),
(15,'2026-04-04','14:15:09','Mobile Pay'),
(16,'2026-04-04','18:55:45','Cash'),
(17,'2026-04-05','12:05:12','Credit Card'),
(18,'2026-04-05','13:25:30','Debit Card'),
(19,'2026-04-05','15:10:44','Mobile Pay'),
(20,'2026-04-05','19:45:01','Credit Card'),
(21,'2026-04-06','11:30:21','Cash'),
(22,'2026-04-06','12:55:33','Credit Card'),
(23,'2026-04-06','14:40:50','Debit Card'),
(24,'2026-04-06','20:15:18','Mobile Pay'),
(25,'2026-04-07','12:20:05','Credit Card'),
(26,'2026-04-07','13:35:44','Cash'),
(27,'2026-04-07','16:10:29','Debit Card'),
(28,'2026-04-07','18:45:56','Mobile Pay'),
(29,'2026-04-08','11:55:14','Credit Card'),
(30,'2026-04-08','12:50:32','Cash'),
(31,'2026-04-08','14:25:47','Debit Card'),
(32,'2026-04-08','19:35:20','Credit Card'),
(33,'2026-04-09','12:05:33','Mobile Pay'),
(34,'2026-04-09','13:15:22','Cash'),
(35,'2026-04-09','17:50:44','Credit Card'),
(36,'2026-04-09','20:10:11','Debit Card'),
(37,'2026-04-10','11:40:25','Credit Card'),
(38,'2026-04-10','12:35:39','Mobile Pay'),
(39,'2026-04-10','14:55:02','Cash'),
(40,'2026-04-10','19:20:18','Debit Card');

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
-- Table structure for table `supplier_availability`
--

DROP TABLE IF EXISTS `supplier_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier_availability` (
  `availability_id` int NOT NULL AUTO_INCREMENT,
  `SupplierID` int NOT NULL,
  `submission_date` date DEFAULT (CURRENT_DATE),
  `submission_time` time DEFAULT (CURRENT_TIME),
  `selected_date` date NOT NULL,
  `selected_time` time NOT NULL,
  PRIMARY KEY (`availability_id`),
  KEY `SupplierID` (`SupplierID`),
  CONSTRAINT `supplier_availability_ibfk_1` 
    FOREIGN KEY (`SupplierID`) 
    REFERENCES `suppliers` (`SupplierID`) 
    ON DELETE CASCADE
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

