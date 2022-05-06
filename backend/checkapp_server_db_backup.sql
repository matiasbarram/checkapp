-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: localhost    Database: checkapp
-- ------------------------------------------------------
-- Server version	8.0.28-0ubuntu0.20.04.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `event_type` enum('CHECK_IN','CHECK_OUT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `confirmed` tinyint(1) NOT NULL DEFAULT '0',
  `comments` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expected_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES (99,2,'CHECK_IN','2022-04-25 10:09:42','-39.8195014,-73.246174',1,'','09:00:00'),(100,2,'CHECK_OUT','2022-04-25 16:05:30','-39.8195245,-73.2461709',1,'','17:30:00'),(101,2,'CHECK_IN','2022-04-26 10:24:16','-39.8339254,-73.246011',1,'','09:00:00'),(102,2,'CHECK_OUT','2022-04-26 17:41:04','-39.8328193,-73.2510354',1,'','17:30:00'),(103,2,'CHECK_IN','2022-04-27 11:46:59','-39.8195185,-73.2463128',1,'','09:00:00');
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'Asiendo Software','-39.83181839213899, -73.24469505831748'),(2,'tetasion','-40.064054017974485, -72.86893421240293');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `device` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `registered_at` datetime NOT NULL,
  `secret_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
INSERT INTO `device` VALUES (1,'sansun','android 12','2022-04-15 15:51:21','asdfb');
/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qr`
--

DROP TABLE IF EXISTS `qr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qr` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `content` blob NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_id` (`company_id`),
  CONSTRAINT `qr_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qr`
--

LOCK TABLES `qr` WRITE;
/*!40000 ALTER TABLE `qr` DISABLE KEYS */;
INSERT INTO `qr` VALUES (1,1,_binary '�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U\�\�~\0\0NIDATx\�\�1�\�,��\" \�>\n{e\��/\�Q8!\��K�}\�Ϋ�vGь�R�>\�2I^\�I2G\�\�/�*\�X\�R��w\0~)`c\�]b�L\�Wr��\��<\0\�\�\�v,���\�ћa=@*J.\�T،?�ܛm^��?k�y\��ng�\�ݓ=\\�?,ς�?\�tr@*��\�%9#i��\0`�\�\�\08\���\�\'lk�V\�dA��TK�\�]Q+\0\�\�B \�l�zE}�\�\Z\0�-�[v�m��:���N\0�e��S\�\�0�\�\�Y\�@��\�}r�\�_\�\�\�\0\�\�T��\�\��\�\��n\�_�t����+��i!����\�_.1�Y\"��\�]\0��E\�%�r\�5}rY\�\�aզ\0(��&����\��\�\��\�RE��_Ӗ\�\�EH���:ԭ\Z\�I�b\�\�\�{\�]�\"\�t}\�\�\0�t\n���\�\�\Z�\0�\�\ZΤ&}p�>y\'\0�֑\��\�ǵ�M]��\r�\�EaJ+\"�䘼:�T��3k�iK\�\�\\�\Z\�\�\�n��\�j*B\�.��\�\�b	`lY��h���\�^װ�c��W�Zp2\�\�`L\0\�\�^S�&��O\�\"`uW�\�\�%��\�gp\��r\�\���}+0\�eew	\�I��q<�Ɩ�\�\�\��\����\�_�\0\0��#Jd�?��(\0\0\0\0IEND�B`�'),(2,2,_binary '�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U\�\�~\0\0YIDATx\�옻�\�0DK�A�!0&�\��Ca4i�C55�\�\��#\�\r�N\��\��U>\�\��\�7�\�\�\�58n5��恀`��ȭ�e�I�\"\�\�3\�\�=j\�\�\�@\�,\n\��\�\�\�\�21[.�TQ�{\�\�\�\�\�\�\�\�ͻ\�ޕ9\��_��\��\�.\r�t���zk`jXZB\�H}�[E\�\�Oɽ`a\�\���x ��v��\0�%f$�	VL=!�P��\�F���\��\�\�C\0��\0,V\�C[aFj\�\��\�[�{/&�\�\�G�\��/T\Z�V.\"��E}�\�,��\��?\��1�\\/�w\Z\���\�D\�B\�`�P�\�x\�\��xA\�&�̣+\�l��eV�-�`۶�b\�C\�G?hVQY�3;�\rK\� �	�N=�ŕ]�f\�\�\�g�7\0Xv\�1�\�\n��;k�E�>�\�I��\�\��Q\�\0$\�\�\����$\�����Usrk���x7��\n�Ψ\�Q3��<\0\0\���\�\�\�\rsȾ`$�\'[��\�xn���\rp�U6�`׺b\�`7\�pY��\�Fzn5y~�e\�\�8]V\�{\\\�ݔ\nw�?I\�RR\�*��2\0,\nx![<B\�\r;\0 �\0I�~bI;;\�	\�g�\�\n@�جV�.k�\�\�Ѵ��\��\�}\�?\��\0\0��w\�~L\��\0\0\0\0IEND�B`�');
/*!40000 ALTER TABLE `qr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift`
--

DROP TABLE IF EXISTS `shift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift` (
  `id` int NOT NULL AUTO_INCREMENT,
  `check_in_time` time NOT NULL,
  `check_out_time` time NOT NULL,
  `lunch_break_length` int NOT NULL DEFAULT '0' COMMENT 'length in minutes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift`
--

LOCK TABLES `shift` WRITE;
/*!40000 ALTER TABLE `shift` DISABLE KEYS */;
INSERT INTO `shift` VALUES (1,'09:00:00','17:30:00',0),(2,'06:00:00','19:00:00',90);
/*!40000 ALTER TABLE `shift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_id` int NOT NULL,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rut` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_id` int DEFAULT NULL,
  `shift_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `rut` (`rut`),
  KEY `user_ibfk_1` (`device_id`),
  KEY `company_id` (`company_id`),
  KEY `shift_id` (`shift_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`),
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`),
  CONSTRAINT `user_ibfk_3` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (2,1,'shimeji','','based','smj@sml.com','e27a68f34edc5e93625d1806feb56bdf',1,1),(6,1,'majime','59','based','mjm@sml.com','2e315dcaa77983999bf11106c65229dc',NULL,2);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-02  0:02:05
