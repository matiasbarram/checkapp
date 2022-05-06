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
INSERT INTO `qr` VALUES (1,1,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0NIDATx\Ú\ì˜1²\ä,„›\" \ä>\n{e\ìú/\ÆQ8!\åþK‚}\öÎ«vGÑŒùR«>\ñ‰2I^\äI2G\Ø\å/™*\äX\àRÿ•w\0~)`c\Ù]b‰L\öWrÁ±\Í<\0\ò\ð\Äv,ÀŸ’\æÑ›a=@*J.\ËTØŒ?”Ü›m^—š?k°y\÷©ngù\ÑÝ“=\\‚?,Ï‚º?\åtr@*Šº\Ù%9#i¶‰\0`³\Å\Ô\08\Ú¹‹\Ë\'lkŽV\ÒdA— TKÀ\ö]Q+\0\Ú\ÝB \Øl˜zE}—\Õ\Z\0³-±[v m‡§:‰‡N\0Àe­S\Å\é”0²\Ð\ËY\ã€@”Ž\Þ}r½\Ù_\æ\Å\Ü\0\ä\ÌT¨þ\ß\óŒù\Ù\÷¦n\Í_€t°ž±Š+–¯i!€¹‰†\Â_.1Y\"¤\æ]\0¨°E\Þ%þr\â5}rY\Ë\êaÕ¦\0(þ¦&›½ú\ãÿ\î\æ€\ËREÁª_Ó–\à\åEH±À¦:Ô­\Z\åIûb\ã\Þ\è{\è] \"\êt}\é\ô\0ût\ný³¸\Î\Û\Z¯\0Œ\í\ZÎ¤&}pý>y\'\0ŒÖ‘\Ö»\îÇµ€M]š¢\r±\÷EaJ+\"¤ä˜¼:³T‚ž3k iK\È\Ã\\¬\Z\Ç\ð\ënÿ·\ßj*B\Ê.¤±\à\Îb	`lY»‰hºŸƒ\ï^×°“c¥“W¬Zp2\Ü\Ó`L\0\ô\Í^S«&¢¯O\æ¸\"`uWœ\Ç\Ð%¤¹\Ðgp\ßŸr\ö\õº†}+0\öeew	\ÛIª¿q<–Æ–•\â\í\Ç„\Ò‘Ÿø\Ä_ÿ\0\0ÿÿ#Jd¿?€ž(\0\0\0\0IEND®B`‚'),(2,2,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0YIDATx\Úì˜»\ä0DK A“!0&¶\Ð›Ca4iªC55³\Â\Íú#\Þ\rN\÷œ\ÞþU>\ï\óþ\Ë7‘\ä\á\é¸58n5‘´æ€`¶–È­‚eªI†\"\ë\ì3\ë\ì=j\Ö\ä¹\ß@\Ú,\n\Ïƒ\Ø\Ã\ê\É21[.†TQž{\ï\å¥\Â\à¥\ä\Þ\ô\æÍ»\ÊÞ•9\ä·_ºû\ÞÀ\ã±.\r®tþ·zk`jXZB\ØH}Š[E\Ã\×OÉ½`a\à\ÔÁªx ²¦v©¨\0¨%f$„	VL=!ûP€¦\ÏFºº\ç‡ù\Ú\ÝC\0“–\0,V\ÇC[aFj\ñ¢\Þ°\ë[¿{/&‹\â\ëGª\Ý€/T\ZœV.\"•E}þ\õ,¹€\éü?\Ó–1“\\/‡w\Z\ô¦Š\ëD\åB\ò`©P˜\áx\ö\í´xA\÷&Ì£+\ælúeV-¼`Û¶«b\ÄC\ÓG?hVQYª3;Á\rK\Õ ­	ˆN= Å•]¿f\í\à\ïg˜7\0Xv\Ø1¨\é¨\n˜¯;k E›>®\ÉIªù\ó\îþQ\Å\0$\Ý\Í\î˜ˆ¸$\ëý€­«Usrk©»ªx7 Š\n’Î¨\äºQ3ú‹<\0\0\âþ¼\Î\í\ß\rsÈ¾`$À\'[²‘\êxnšˆ¸\rp–U6»`×ºb\ï`7\ðpY´¸\âFzn5y~ÿe\Ã\Þ8]V\Û{\\\ÕÝ”\nwº?I\ÝRR\Å*¦‡2\0,\nx![<B\æ‹\r;\0 ý\0Iµ~bI;;\Þ	\èg‡\å\n@ªØ¬Vœ.k©\å\áÑ´¯ø\ÖÀ\ç}\Þ?\öþ\0\0ÿÿw\Ò~L\í²û\0\0\0\0IEND®B`‚');
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
