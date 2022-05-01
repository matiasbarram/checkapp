-- MariaDB dump 10.19  Distrib 10.7.3-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: checkapp
-- ------------------------------------------------------
-- Server version	10.7.3-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `event_type` enum('CHECK_IN','CHECK_OUT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_time` datetime NOT NULL DEFAULT current_timestamp(),
  `location` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pending` tinyint(1) NOT NULL DEFAULT 1,
  `comments` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expected_time` time NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=233 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES
(183,6,'CHECK_IN','2022-04-10 06:34:12','-42,70',0,'ON TIME','06:00:00'),
(184,6,'CHECK_OUT','2022-04-10 18:58:39','-42,70',0,'ON TIME','19:00:00'),
(227,15,'CHECK_IN','2022-04-20 09:01:06','-40,70',0,'ON TIME','09:00:00'),
(228,15,'CHECK_OUT','2022-04-20 17:41:06','-40,70',0,'ON TIME','17:30:00'),
(229,14,'CHECK_IN','2022-04-27 09:00:36','44,55',0,'ON TIME','09:00:00'),
(230,14,'CHECK_OUT','2022-04-27 19:00:00','44,55',0,'ON TIME','17:30:00'),
(231,15,'CHECK_IN','2022-03-02 09:01:06','-40,70',0,'ON TIME','09:00:00'),
(232,15,'CHECK_OUT','2022-03-02 17:41:06','-40,70',0,'ON TIME','17:30:00');
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES
(1,'Asiendo Software','-39.83181839213899, -73.24469505831748'),
(2,'tetasion','-40.064054017974485, -72.86893421240293');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `registered_at` datetime NOT NULL,
  `secret_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
INSERT INTO `device` VALUES
(1,'sansun','android 12','2022-04-15 15:51:21','asdfb'),
(2,'nokia 5100','android','2022-04-30 22:20:38','kok'),
(3,'aifon','ios','2022-05-01 18:12:33','kek'),
(4,'xiaome','android','2022-05-01 18:12:33','afds');
/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qr`
--

DROP TABLE IF EXISTS `qr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
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
INSERT INTO `qr` VALUES
(1,1,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0NIDATxÚì˜1²ä,„›\" ä>\n{eìú/ÆQ8!åþK‚}öÎ«vGÑŒùR«>ñ‰2I^äI2GØå/™*äXàRÿ•w\0~)`cÙ]b‰LöWrÁ±Í<\0òðÄv,ÀŸ’æÑ›a=@*J.ËTØŒ?”Ü›m^—š?k°y÷©ngùÑÝ“=\\‚?,Ï‚º?åtr@*ŠºÙ%9#i¶‰\0`³ÅÔ\08Ú¹‹Ë\'lkŽVÒdA— TKÀö]Q+\0ÚÝB Øl˜zE}—Õ\Z\0³-±[v m‡§:‰‡N\0Àe­SÅé”0²ÐËYã€@”ŽÞ}r½Ù_æÅÜ\0äÌT¨þßóŒùÙ÷¦nÍ_€t°ž±Š+–¯i!€¹‰†Â_.1Y\"¤æ]\0¨°EÞ%þrâ5}rYËêaÕ¦\0(þ¦&›½úãÿîæ€ËREÁª_Ó–àåEH±À¦:Ô­\ZåIûbãÞè{è] \"êt}éô\0ût\ný³¸ÎÛ\Z¯\0Œí\ZÎ¤&}pý>y\'\0ŒÖ‘Ö»îÇµ€M]š¢\r±÷EaJ+\"¤ä˜¼:³T‚ž3k iKÈÃ\\¬\ZÇðënÿ·ßj*BÊ.¤±àÎb	`lY»‰hºŸƒï^×°“c¥“W¬Zp2ÜÓ`L\0ôÍ^S«&¢¯Oæ¸\"`uWœÇÐ%¤¹ÐgpßŸröõº†}+0öeew	ÛIª¿q<–Æ–•âíÇ„Ò‘ŸøÄ_ÿ\0\0ÿÿ#Jd¿?€ž(\0\0\0\0IEND®B`‚'),
(2,2,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0YIDATxÚì˜»ä0DK A“!0&¶Ð›Ca4iªC55³ÂÍú#Þ\rN÷œÞþU>ïóþË7‘äáé¸58n5‘´æ€`¶–È­‚eªI†\"ëì3ëì=jÖä¹ß@Ú,\nÏƒØÃêÉ21[.†TQž{ïå¥Âà¥äÞôæÍ»ÊÞ•9ä·_ºûÞÀã±.\r®tþ·zk`jXZBØH}Š[EÃ×OÉ½`aàÔÁªx ²¦v©¨\0¨%f$„	VL=!ûP€¦ÏFººç‡ùÚÝC\0“–\0,VÇC[aFjñ¢Þ°ë[¿{/&‹âëGªÝ€/T\ZœV.\"•E}þõ,¹€éü?Ó–1“\\/‡w\Zô¦ŠëDåBò`©P˜áxöí´xA÷&Ì£+ælúeV-¼`Û¶«bÄCÓG?hVQYª3;Á\rKÕ ­	ˆN= Å•]¿fíàïg˜7\0XvØ1¨é¨\n˜¯;k E›>®ÉIªùóîþQÅ\0$ÝÍî˜ˆ¸$ëý€­«Usrk©»ªx7 Š\n’Î¨äºQ3ú‹<\0\0âþ¼Îíß\rsÈ¾`$À\'[²‘êxnšˆ¸\rp–U6»`×ºbï`7ðpY´¸âFzn5y~ÿeÃÞ8]VÛ{\\ÕÝ”\nwº?IÝRRÅ*¦‡2\0,\nx![<Bæ‹\r;\0 ý\0Iµ~bI;;Þ	èg‡å\n@ªØ¬Vœ.k©åáÑ´¯øÖÀç}Þ?öþ\0\0ÿÿwÒ~Lí²û\0\0\0\0IEND®B`‚');
/*!40000 ALTER TABLE `qr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift`
--

DROP TABLE IF EXISTS `shift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shift` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `check_in_time` time NOT NULL,
  `check_out_time` time NOT NULL,
  `lunch_break_length` int(11) NOT NULL DEFAULT 0 COMMENT 'length in minutes',
  `workdays` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'array of day names',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift`
--

LOCK TABLES `shift` WRITE;
/*!40000 ALTER TABLE `shift` DISABLE KEYS */;
INSERT INTO `shift` VALUES
(1,'09:00:00','17:30:00',0,'monday,tuesday,wednesday,thursday,friday'),
(2,'06:00:00','19:00:00',90,'monday,tuesday,wednesday,thursday,friday,saturday,sunday');
/*!40000 ALTER TABLE `shift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rut` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_id` int(11) DEFAULT NULL,
  `shift_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `rut` (`rut`),
  UNIQUE KEY `device_id` (`device_id`),
  KEY `company_id` (`company_id`),
  KEY `shift_id` (`shift_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`),
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`),
  CONSTRAINT `user_ibfk_3` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(2,1,'shimeji','','based','smj@sml.com','e27a68f34edc5e93625d1806feb56bdf',1,1),
(6,1,'majime','59','cringe','mjm@sml.com','2e315dcaa77983999bf11106c65229dc',2,2),
(14,2,'cr7','7','cringe','bicho@cr7.com','1463ccd2104eeb36769180b8a0c86bb6',NULL,1),
(15,1,'kaos','37','cringe','kaos@kaos.com','be1232fb0b27349ae4334d275038ff6f',4,1);
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

-- Dump completed on 2022-05-01 19:44:25
