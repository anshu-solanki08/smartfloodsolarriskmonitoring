CREATE DATABASE  IF NOT EXISTS `smartflood` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `smartflood`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: smartflood
-- ------------------------------------------------------
-- Server version	8.0.46

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

--
-- Table structure for table `predictions`
--

DROP TABLE IF EXISTS `predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `predictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rainfall` float DEFAULT NULL,
  `temperature` float DEFAULT NULL,
  `humidity` float DEFAULT NULL,
  `water_level` float DEFAULT NULL,
  `soil_moisture` float DEFAULT NULL,
  `cloud_cover` float DEFAULT NULL,
  `waterlogging` float DEFAULT NULL,
  `flood_risk` varchar(50) DEFAULT NULL,
  `solar_risk` varchar(50) DEFAULT NULL,
  `efficiency` float DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `predictions`
--

LOCK TABLES `predictions` WRITE;
/*!40000 ALTER TABLE `predictions` DISABLE KEYS */;
INSERT INTO `predictions` VALUES (1,75,55,9,44,52,12,20,'Low','Low',90,'2026-04-26 09:30:22',NULL,NULL),(2,55,20,20,36,56,45,24,'Medium','Medium',65,'2026-04-26 10:18:49',28.6295,77.225),(3,44,41.18,11,25,36,12,24,'Low','Low',90,'2026-04-26 11:17:08',28.5343,77.3087),(4,55,42.27,13,31,31,90,40,'Low','High',35,'2026-04-26 11:47:59',28.6587,74.0369),(5,12,19.18,40,12,10,0,15,'Low','Low',90,'2026-04-27 11:02:10',48.7157,2.3394),(6,55,42.29,11,42,12,63,12,'Low','High',35,'2026-04-27 11:45:29',27.1636,73.5754),(7,45,13.99,77,24,15,100,26,'Medium','High',35,'2026-04-28 17:20:03',43.6613,-79.3959),(8,44,14.21,77,25,20,100,20,'Medium','High',35,'2026-04-28 17:33:05',43.6717,-79.3785),(9,55,25.47,54,25,20,51,20,'Low','Low',90,'2026-04-28 18:24:53',30.8944,75.8139),(10,55,41.56,7,11,22,0,26,'Low','Low',90,'2026-04-29 11:08:57',27.9344,73.3008),(11,42,41.75,8,22,22,5,22,'Low','Low',90,'2026-04-29 11:14:59',26.1875,75.7617),(12,45,37.03,20,12,12,93,20,'Low','High',35,'2026-04-29 11:37:30',28.2058,79.4312),(13,12,9.67,78,12,12,100,20,'Medium','High',35,'2026-04-29 11:41:37',43.6718,-79.3785),(14,35,40.05,10,10,10,4,12,'Low','Low',90,'2026-04-29 11:52:43',28.0314,74.9268);
/*!40000 ALTER TABLE `predictions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-29 23:54:31
