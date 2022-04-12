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
  `arrival` datetime NOT NULL,
  `departure` datetime NOT NULL,
  `location` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `on_site` int(11) DEFAULT NULL,
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES
(1,'Asiendo Software','-39.831970278556206, -73.24455166529128'),
(2,'referencia a shimeji simulation','-55.16407, 16.34224,'),
(3,'sementerio','-40.07785757561413, -72.86723225181254'),
(4,'tetasion','-40.064067736782484, -72.86893364873045'),
(5,'lae mpresa','-34.709787382159845, -62.194379532770384');
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) NOT NULL,
  `content` blob DEFAULT NULL,
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
INSERT INTO `qr` VALUES
(1,1,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0RIDATxÚì˜1Ž+-„kD@È8\n[gô_Œ£pBäúUÍìz×ûrÃ{&°,æKZtUà½ÞëŸ\\IÞ}v$3\0ò¬I»y! Ø‘z°­&Ä	@X\nˆ¬»þÝÈÏj»É³Oxº\nOûÖâYWî\0ËMÜëê¨Qæ5üCË½¸†·‡³%Wöí,~O÷ÔÀX>³n\rš‹¤	þ%§“[ƒ«7RgÇ#ä†=ú7\r\0_ÈÃgªÙY¥öÒý¯\n\06²CB\Zl\Zv¤¦‚%ù@´qÖú¸³Hê\'¯\\Bš­åº¶U&>ÂT€«v ð”Ú\'–ýÒýu\0øâT¦3¿Vn°°‘ŽgC‡	Õ2Ë¦Zoûâõ€}kAVÒ\0_µ€p\nØ\ZÈ{ ç=—¿\0ÄØRÇîÇ¶·2ù_ÀÖR§&Ø„^çËO.X‚Ò\\Bº	é³˜0ÛŸ!çãÊFu”rí1 .ºcä#ù\"Yì,$“|ÙL69þaÀÓÉ.t…A§sòÃ;?.µ×[‹Ýˆ\\q·Ž–¹\0Ä¹iap«IÃ›L÷\n\0Ì¥™ÁAV#á¿GÚùM·fáîÇuÐFXÿz™\0øÌÝvgqéYáËs0Ÿ\Zx¼|ºâË?Kã•u<JÙó‡\'žÍ^\rŒ0h~\rQ~²Xeß4jÀ\"wƒS÷eÜ‚@²;ÁJ‹Ç|Àè(‹QÖLˆ\'³ÿv+\0cx‡Ú+×JH+Z|z†x¯÷úËÖÿ\0\0ÿÿO¢mÄ%ø\0\0\0\0IEND®B`‚'),
(3,2,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0]IDATxÚì™;Ž;-ÄrŽÂÅVž±öb…#N€¦>Uc{½ÜðýÝÁZÂ¿¤·»úe¼ímÿ¤9’<Cñ¼²t\\\0òÚ²^ËBÀà\nâõ\0ÒiG—Û%q\\Ë¡9°O ÷H²ck`ÝÚš@(Ê­¢d²×õ\0e²ELºÈ¡ºö+å^ÜÄÛãõÈ¾^b9ÒŸêž\Z¸›¥•çŽLžÔ©wàæ’–›–[¡n_…tÀ7wdß¶=È‡•üúäÅü\0©ïOÀêC2Ô».–\0œ’›ÜCQ2ÉÍXH6,(X’„\"\\\"U´ò‘>ŸSîÅ\0B¥¾³BêÕt‘NeÔÇ#£\0,B³žE–ÛíÏ:\0F¡j\n[½D\"‰J÷Î;àHUŸÌ¶±xú ÜÇZ€e`…4©Ö~?Öxj2;ƒe”:›(ÿ¤î—HÝ>âX;`³=È‡+\0ŽõÖ³¨IbW\r½ÊÙrS{ \røž»©»Y?žuÌ7Z£¬Ùx€´‰w€¾9²[,¬g\rûX\n$N-æT;ÐGb{ž&\0l¶‡r¬…J¦o“Ø\0©Ne=‹Þv•n.(6·ùFºÜwn{ü–\0à›evQ°ê6š[™øÚ¥K×”ªkukXxÜ@€Pº?ªÓF¸ÿ¼äL\rÜ®¬cl¶`ÉMLŒ+ëýF£geTõÏºX¸Z12Ý’O{Ö:\0r×‹Ý@Æ=ê÷1ù¥À¸²z-ƒ]c%Òùíh¶\00Ä;\ZÆN=ë‡ºçÞö¶ÿ™ý\0\0ÿÿ·N3ú§È!æ\0\0\0\0IEND®B`‚'),
(4,3,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0_IDATxÚì™Í,!„«Å#!\n‰=Mwk#BàÈM=•»çwxo8¬V½ßÅ²].{ñ}ß÷_¾…$¯H®.¤+sÃR“¾æ‰€àt\\Èd¹ S‘õ‚ä¸3[À¦g`]™]¹„Œ¸aR\0=¨¬\n¼r1 ŠòÙÕµ%Ä½Zý*¹Ö¼>÷°·d¹hqÿÝÝƒçK=l\0‹‚;b}{cKS1yZŠX.A¿…Ü†€Èº´äêJ:n7*þÜs1pVø,5¥º9±¸¹€Bî\rú‘œºÁK‡ZÜÂD\0<Hº\nŸ;VÒÉ\Z\n\0œ*ÊÔñ\Z2ËBÆAÓÐ½\ru÷ÂŒø¤´3\0¥‡ÍgM6š¤JMéŸûâã\0•°Z®*±½&_Ö»äO\0,-*LÚ¨íQ®³\\\0}Íó\08ÿæxºê¨aõg ÀÔ^Yo¨$’~.\0¾t‹K:ËÅ[ÉÍ\0,M-ÑÐÍi-l@`ƒ{¬´ŸH‹XõÑÊ~©¯Þ~ Eº×ƒU•uŸYÓ\0+Û,Ã	/×Ù^Ãü0\0O§æµqêŠÖs™P_Hxx‹ê`òyï€œÂ®æÐF¨=\Z\rO\Z5> î‡-óÙòtŽˆŸ€GYÑÔÔš_?/×ƒÁÛ•aCê¶“kôåõ’3:p¿GÙj=&¯¼Äcò\0—=iOîZÛÙövú›\0ðÙqó¹[\Zl&<V˜y\0@¶9QÍ\\Ú“m8þwÀsm=ÇÕËUmà<79µÔ\'Éªx¿G\r\r|ß÷ýcïo\0\0\0ÿÿËMW,”\0\0\0\0IEND®B`‚'),
(5,4,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0^IDATxÚì™AŽë,„Ëò‚%Gà(\\ldýã(%äúUm\'“™yû÷Â\"J¬oÓrWW5Áû¼Ï?y’<]îØ\0òð™<õ4O4\0âÊÄÜ±W ¤\Zø©€Àº!².ÍŠ#°×èØ‡Ywråá©ï³k…Ëk\"Ë†ù\0u”J[šÚª¢…?Zî—‡x}jq-›ÏMmÿu\\ÇEh¥úcœ,\rkÝ™×º7¬e!NO©Ã\0\0VŽ@ì,{…+/…L\0¸B«ÖQ{‰¡Ï,,¬P™Ð%Ó\nÂ§p&\0àÊjNP7—IV4-<[n\0š>Ê\"»:–¹\0ÂŸG\"MÝ÷ýøOãËCÝNˆÙ^–I|àÊ“°¼†p*ÀçÉ\084DøÃFªbý‰ø:H§\0J×+ê^}dšV­1Ø»ýªÛ»¦c‰l_³Üè€<ëZ÷YéžíEÝ\0K»œJX´Úrû_€‚ÀÎŸhîª¶W[q&@eÊ³hÎ[àéÊæÙæ€°’Z±Ì¸l¥M56<w\0@IŒé.å™Š_GÐ€:JI÷l×EÍ©ðÀT\0,Å“Ç•Š•ªm‡yÀÂü&ûMwJ»SÐËæ¯÷ÈÏÔ^«ÇQºPâÿz{06ð¸òÃZvýL\nøO¿˜¸§%f«ðkG\r\\7{ÝŽJipwo=«˜ß¦†[§çËíÁL€$®Øl|/ów«£©ø¾¨qœ¸Ä«ÀÙdº×ŸháÛ5ìØÀû¼Ï_vþ\0\0ÿÿ·nÙºèuœ\0\0\0\0IEND®B`‚'),
(8,5,'‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f¼:%\0\0\0PLTEÿÿÿ\0\0\0UÂÓ~\0\0GIDATxÚì™Íqä …ŸŠGB ÛÒHåÄ…8r ô¶^3ãÛv§”Kúfúïuo{ÛiI^ÞŽìx\0ä…¤§y! ØVøÜ*Z<k–\"ëŽd@Ô»­&Ï>às</ù‚Ëú;¹$¯ˆZPDù,gÑññÀûe`$oîálÉ•=dûÙ=70ìLE|Ùêr:9°5¸zã¨¡v\0{ Ím³\0ð…<<.¤/@y|yÞp îÖ³:nÌˆWÈd_	Pv+%È³)¢¬_;ïô\0|qC?œ¤š\Zš€{˜Ø\Zô«7ðQíÁrãB€EÔ­\r‘£BJ)drg!\0ÑÎ.ŸOåÅY_¯9`a¯wá$¡ˆ²ØzÞb	`¨É“õ‡œ&Õ°°‘NåÆœ5TÐÍu\0ˆ£éÖ{ud‹æ‹‡T[þU!Õ­ú=ŽÛ«\0Z(÷Bj%è³=4`ÿ´\"J=K*ÍiÌº jIµcìèy-ÐYÏ’‹\\Ù˜}±ˆzvÞß6%or<[ê‘Ì#˜â³F-\0˜íw_¸\"e`Tùƒµ€þrl´‘š¾6–ÇÖÏg[âH\n‘e&à‘:ò@t¿ðÜ²’tlòE`,\0Ü·¬*T¦èSÃVñ}iöÛ€möØÃ!‡ìH&r¸\" kîc“#ýˆx|nÖÔ4b!kd³ÊD€ET²1J=k4Ý—ä]x$¯}aÐ ÛÆgïzfÞö¶Ìþ\0\0ÿÿ¼íIŠ³¾\0\0\0\0IEND®B`‚');
/*!40000 ALTER TABLE `qr` ENABLE KEYS */;
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
  `device_id` int(11) DEFAULT NULL,
  `email` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
INSERT INTO `user` VALUES
(1,1,'joselo','18','femboy',NULL,NULL,NULL),
(5,1,'mbarra','20','admin',NULL,NULL,NULL),
(20,1,'majime','22','based',NULL,'asdf@xd.cl','2ab96390c7dbe3439de74d0c9b0b1767');
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

-- Dump completed on 2022-04-12  1:13:51
