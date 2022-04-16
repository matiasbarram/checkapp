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
  `arrival` datetime NOT NULL,
  `departure` datetime NOT NULL,
  `location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `on_site` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'Asiendo Software','-39.831970278556206, -73.24455166529128'),(2,'referencia a shimeji simulation','-55.16407, 16.34224,'),(3,'sementerio','-40.07785757561413, -72.86723225181254'),(4,'tetasion','-40.064067736782484, -72.86893364873045'),(5,'lae mpresa','-34.709787382159845, -62.194379532770384');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
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
  `content` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `company_id` (`company_id`),
  CONSTRAINT `qr_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qr`
--

LOCK TABLES `qr` WRITE;
/*!40000 ALTER TABLE `qr` DISABLE KEYS */;
INSERT INTO `qr` VALUES (1,1,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0RIDATx\Ú\ì˜1Ž+-„kD@\È8\n[g\ô_Œ£pB\äúU\Í\ìz\×ûr\Ã{&°,\æKZtU\à½\Þ\ëŸ\\I\Þ}v$3\0\ò¬I»y! Ø‘z°­&\Ä	@X\nˆ¬»þ\Ý\È\Ïj»É³Oxº\nOû\Ö\âYW\î\0\ËM\Ü\ë\ê¨Q\æ5üCË½¸†·‡³%W\ö\í,~O\÷\ÔÀX>³n\rš‹¤	þ%§“[ƒ«7Rg\Ç#\ä†=ú7\r\0_\È\Ãgª\ÙY¥\ö\Òý¯\n\06²CB\Zl\Zv¤¦‚%ù@´q\Öú¸³H\ê\'¯\\Bš­åº¶U&>\ÂT€«v \ð”\Ú\'–ý\Òýu\0ø\âT¦3¿Vn°°‘ŽgC‡	\Õ2Ë¦Zoû\â\õ€}kAV\Ò\0_µ€p\n\Ø\Z\È{ \ç=—¿\0\Ä\ØR\Ç\îÇ¶·2ù_À\ÖR§&Ø„^\ç\ËO.X‚Ò\\Bº	é³˜0\ÛŸ!\ç\ã\ÊFu”r\í1 .ºc\ä#ù\"Y\ì,$“|\ÙL69þaÀ\Ó\É.t…A§s\ò\Ã;?.µ\×[‹\Ýˆ\\q·Ž–¹\0\Ä¹iap«IÃ›L\÷\n\0Ì¥™ÁAV#\á¿G\ÚùM·f\á\î\Çu\ÐFXÿz™\0ø\Ì\Ývgq\éY\á\Ës0Ÿ\Zx¼|º\â\Ë?K\ã•u<J\Ù\ó‡\'ž\Í^\rŒ0h~\rQ~²Xe\ß4jÀ\"wƒS\÷eÜ‚@²;ÁJ‹\Ç|À\è(‹Q\ÖLˆ\'³ÿv+\0cx‡\Ú+\×JH+Z|z†x¯\÷ú\Ë\Öÿ\0\0ÿÿO¢m\Ä%ø\0\0\0\0IEND®B`‚'),(3,2,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0]IDATx\Ú\ì™;Ž;-\ÄrŽ\Â\ÅVž±\öb…#N€¦>Uc{½\Ü\ðý\ÝÁZÂ¿¤·»úe¼\ímÿ¤9’<C\ñ¼²t\\\0\òÚ²^\ËBÀ\à\n\â\õ\0\ÒiG—\Û%q\\Ë¡9°O \÷H²ck`\ÝÚš@(Ê­¢d²\×\õ\0e²ELºÈ¡º\ö+\å^\Ü\Ä\Û\ã\õÈ¾^b9ÒŸ\êž\Z¸›¥•\çŽLžÔ©w\à\æ’–›–[¡n_…tÀ7wdß¶=È‡•üú\ä\Åü\0©\ïOÀ\êC2Ô».–\0œ’›\ÜCQ2\É\ÍXH6,(X’„\"\\\"U´\ò‘>ŸS\î\Å\0B¥¾³B\ê\Õt‘Ne\Ô\Ç#£\0,B³žE–\Û\í\Ï:\0F¡j\n[½D\"‰J\÷\Î;\àHUŸÌ¶±xú \Ü\ÇZ€e`…4©\Ö~?\Öxj2;ƒe”:›(ÿ¤\î—H\Ý>\âX;`³=È‡+\0Ž\õÖ³¨IbW\r½\Ê\ÙrS{ \røž»©»Y?žu\Ì7Z£¬\Ùx€´‰w€¾9²[,¬g\rûX\n$N-\æT;\ÐGb{ž&\0l¶‡r¬…J¦o“\Ø\0©Ne=‹\Þv•n.(6·ùFº\Üwn{ü–\0\à›evQ°\ê6š[™øÚ¥K×”ªkukXx\Ü@€Pº?ª\ÓF¸ÿ¼\äL\rÜ®¬cl¶`\ÉMLŒ+\ëýF£geT\õÏºX¸Z12Ý’O{\Ö:\0r×‹\Ý@\Æ=\ê\÷1ù¥À¸²z-ƒ]c%\Òù\íh¶\00\Ä;\ZÆN=ë‡º\ç\Þ\ö¶ÿ™ý\0\0ÿÿ·N3ú§\È!\æ\0\0\0\0IEND®B`‚'),(4,3,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0_IDATx\Ú\ì™Í,!„«Å#!\n‰=Mwk#B\à\ÈM=•»\çwxo8¬V½\ßÅ²].{\ñ}\ß\÷_¾…$¯H®.¤+s\ÃR“¾æ‰€\àt\\Èd¹ S‘\õ‚\ä¸3[À¦g`]™]¹„Œ¸aR\0=¨¬\n¼r1 Š\ò\ÙÕµ%Ä½Zý*¹Ö¼>\÷°·d¹hqÿ\ÝÝƒ\çK=l\0‹‚;b}{cKS1yZŠX.A¿…Ü†€Èº´\ä\êJ:n7*þ\Üs1pVø,5¥º9±¸¹€B\î\rú‘œºÁK‡Z\Ü\ÂD\0<Hº\nŸ;V\Ò\É\Z\n\0œ*\Ê\Ô\ñ\Z2\ËB\ÆA\ÓÐ½\ru\÷ÂŒø¤´3\0¥‡\ÍgM6š¤JM\éŸû\â\ã\0•°Z®*±½&_Ö»\äO\0,-*LÚ¨\íQ®³\\\0}\Í\ó\08ÿ\æxº\ê¨a\õg À\Ô^Yo¨$’~.\0¾t‹K:\Ë\Å[\É\Í\0,M-\Ñ\Ð\Íi-l@`ƒ{¬´ŸH‹X\õ\Ñ\Ê~©¯\Þ~ Eº×ƒU•uŸY\Ó\0+\Û,\Ã	/\×\Ù^\Ãü0\0O§\æµq\êŠ\Ös™P_Hxx‹\ê`\òy\ï€œÂ®\æ\ÐF¨=\Z\rO\Z5> \î‡-\ó\Ù\òtŽˆŸ€GY\Ñ\Ô\Ôš_?/×ƒÁÛ•aCê¶“k\ô\å\õ’3:p¿G\Ùj=&¯¼\Äc\ò\0—=iO\îZ\Û\Ù\övú›\0\ð\Ùq\ó¹[\Zl&<V˜y\0@¶9Q\Í\\Ú“m8þwÀsm=\Ç\Õ\ËUm\à<79µ\Ô\'Éªx¿G\r\r|\ß\÷ýc\ïo\0\0\0ÿÿ\ËMW,”\0\0\0\0IEND®B`‚'),(5,4,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0^IDATx\Ú\ì™AŽ\ë,„\Ë\ò‚%G\à(\\ldý\ã(%\äúUm\'“™yû\÷\Â\"J¬o\ÓrWW5Áû¼\Ï?y’<]\î\Ø\0\ò\ð™<\õ4O4\0\â\Ê\ÄÜ±W ¤\Zø©€Àº!².ÍŠ#°\×\èØ‡Ywr\å\á©\ï³k…\Ëk\"Ë†ù\0u”J[šÚª¢…?Zî—‡x}jq-›\ÏMmÿu\\\ÇEh¥úcœ,\rkÝ™×º7¬e!NO©\Ã\0\0VŽ@\ì,{…+/…L\0¸B«\ÖQ{‰¡\Ï,,¬P™\Ð%\Ó\nÂ§p&\0\à\ÊjNP7—IV4-<[n\0š>\Ê\"»:–¹\0ÂŸG\"M\Ý\÷ýøO\ã\ËC\ÝNˆ\Ù^–I|\àÊ“°¼†p*À\ç\É\084Dø\ÃFªbý‰ø:H§\0J\×+\ê^}dšV­1Ø»ýªÛ»¦c‰l_³\Ü\è€<\ëZ\÷Y\éž\íE\Ý\0K»œJX´\Úrû_€‚À\ÎŸhîª¶W[q&@eÊ³h\Î[\à\é\Ê\æ\Ù\æ€°’Z±Ì¸l¥M56<w\0@IŒ\é.å™Š_G\Ð€:JI\÷l\×EÍ©\ðÀT\0,Å“Ç•Š•ªm‡yÀ\Âü&ûMwJ»S\Ð\Ë\æ¯\÷\È\Ï\Ô^«\ÇQºP\âÿz{06\ð¸\ò\ÃZvýL\nøO¿˜¸§%f«\ðkG\r\\7{\ÝŽJipwo=«˜ß¦†[§\ç\Ë\íÁL€$®\Øl|/\ów«£©ø¾¨qœ¸Ä«À\Ùdº×Ÿh\á\Û5\ì\ØÀû¼\Ï_vþ\0\0ÿÿ·nÙº\èuœ\0\0\0\0IEND®B`‚'),(8,5,_binary '‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0U\Â\Ó~\0\0GIDATx\Ú\ì™\Íq\ä …ŸŠGB \Û\ÒH\å\Ä…8r \ô¶^3\ã\Ûv§”Kúfú\ïuo{\ÛiI^ÞŽ\ìx\0ä…¤§y! \ØVø\Ü*Z<k–\"\ëŽd@Ô»­&\Ï>\às</ù‚\Ëú;¹$¯ˆZPDù,g\Ñ\ñ\ñÀûe`$o\î\álÉ•=dû\Ù=70\ìLE|\Ù\êr:9°5¸zã¨¡v\0{ \Ím³\0\ð…<<.¤/@y|y\Þp \îÖ³:nÌˆW\Èd_	Pv+%È³)¢¬_;\ï\ô\0|qC?œ¤š\Zš€{˜\Ø\Z\ô«7\ðQ\íÁr\ãB€EÔ­\r‘£BJ)drg!\0\Ñ\Î.ŸO\å\ÅY_¯9`a¯w\á$¡ˆ²\Øz\Þb	`¨\É“\õ‡œ&Õ°°‘N\åÆœ5TÐ\Íu\0ˆ£\é\Ö{ud‹æ‹‡T[þU!Õ­ú=ŽÛ«\0Z(\÷Bj%è³=4`ÿ´\"J=K*\ÍiÌº jIµc\ì\èy-\ÐYÏ’‹\\Ù˜}±ˆzv\Þ\ß6%or<[\ê‘\Ì#˜\â³F-\0˜\íw_¸\"e`Tùƒµ€þrl´‘š¾6–\Ç\Ö\Ïg[\âH\n‘e&\à‘:\ò@t¿\ðÜ²’tl\òE`,\0Ü·¬*T¦\èS\ÃV\ñ}i\öÛ€m\ö\Ø\Ã!‡\ìH&r¸\" k\îc“#ýˆx|n\Ö\Ô4b!kd³\ÊD€ET²1J=k4Ý—\ä]x$¯}a\Ð \Û\Æg\ïzf\Þ\ö¶\Ìþ\0\0ÿÿ¼\íIŠ³¾\0\0\0\0IEND®B`‚');
/*!40000 ALTER TABLE `qr` ENABLE KEYS */;
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
  `device_id` int DEFAULT NULL,
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `user_ibfk_1` (`device_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`),
  CONSTRAINT `user_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,1,'joselo','18','femboy',NULL,NULL,NULL),(5,1,'mbarra','20','admin',NULL,NULL,NULL),(20,1,'majime','22','based',NULL,'asdf@xd.cl','2ab96390c7dbe3439de74d0c9b0b1767');
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

-- Dump completed on 2022-04-16  0:59:21
