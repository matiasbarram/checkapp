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
(1,1,'�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U��~\0\0RIDATx��1�+-�kD@�8\n[�g�_��pB��U��z��r�{&�,�KZtU���\\I�}v$3\0�I�y!�ؑz���&�	@X\n�������j�ɳOx�\nO���YW�\0�M���Q�5�C˽�����%W���,~O���X>�n\r���	�%��[��7Rg�#�=��7\r\0_��g��Y������\n\06�CB\Zl\Zv���%�@�q����H�\'�\\B��庶U&>�T��v ��\'����u\0��T�3�Vn����gC�	�2˦Zo�����}kAV�\0_��p\n�\Z�{��=��\0��R��Ƕ�2�_���R�&؄^��O.X�ҁ\\B�	鏳�0��!���Fu�r�1�.��c��#�\"�Y�,$�|�L69��a���.t�A�s��;?.��[���\\q�����\0��iap�IÛL�\n\0̥��AV#�G��M�f���u�FX�z�\0���vgq�Y��s0�\Zx��|���?K�u<J��\'��^\r�0h~\rQ~�Xe�4j�\"w�S�e܂@�;�J��|��(�Q�L�\'��v+\0cx��+�JH+Z|z��x������\0\0��O�m�%�\0\0\0\0IEND�B`�'),
(3,2,'�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U��~\0\0]IDATx��;�;-�r���V���b�#N��>Uc{�������Z¿����e��m��9�<C�t\\\0�ڲ^�B��\n��\0�iG��%q\\ˡ9�O �H�ck`�ښ@(ʭ�d���\0e�EL�ȡ��+�^�����Ⱦ^b9ҟ�\Z�����L�ԩw�����[�n_�t�7wd߶=�ȇ������\0��O���C2Ի.�\0����CQ2��XH6,(X��\"\\\"U��>�S��\0B���B��t�Ne��#�\0,B��E����:\0�F�j\n[�D\"�J��;�HU�̶�x����Z�e`�4���~?�xj2;�e�:�(���H�>�X;`�=ȇ+\0��ֳ�IbW\r���rS{�\r�����Y?�u�7Z���x���w��9�[,�g\r�X\n�$N-�T;�Gb{�&\0l��r��J�o��\0�Ne=��v�n.(6��F���wn{��\0���evQ��6�[��ڥKה�kukXx�@�P��?��F����L\rܮ�cl�`�ML�+��F�geT�ϺX�Z12ݒO{�:\0r׋�@�=��1�����z-�]c%���h�\00�;\ZƏN=뇺�������\0\0���N3���!�\0\0\0\0IEND�B`�'),
(4,3,'�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U��~\0\0_IDATx��͍,!��Ł#!\n�=Mwk#B��M=���wxo8�V��Ų].{�}��_��$�H�.�+s�R��所�t\\�ȝd� S����3[��g`]�]����aR\0=��\n��r1����յ%ĽZ��*�ּ>���d�hq��݃�K=l\0��;b}{cKS1yZ�X.A��܆�Ⱥ���J:n7*��s1pV�,5��9����B�\r�����K�Z��D\0<H�\n�;V��\Z\n\0�*���\Z2�B���A�н\ru����3\0���gM6��JM����\0��Z�*��&_ֻ�O\0,-*Lڨ�Q��\\\0}��\08��x��a�g ��^Yo�$�~.\0�t�K:��[��\0,M-���i-l@`�{���H�X���~���~�E���׃U�u�Y�\0+�,�	/��^��0\0O��q��s�P_Hxx��`�y���®��F�=�\Z\rO\Z5>���-���t�����GY����_?/׃��ەaC궓k����3:p�G�j=&���c�\0�=iO�Z���v��\0��q�[\Zl&<V�y\0@�9Q�\\ړm8�w�sm=���Um�<79���\'ɪx�G\r\r|���c�o\0\0\0���MW,�\0\0\0\0IEND�B`�'),
(5,4,'�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U��~\0\0^IDATx��A��,���%G�(\\ld��(�%��Um\'��y����\"J�o�rWW5����?y�<]��\0��<�4O4\0���ܱW �\Z�����!�.͊#���؇Ywr���k��k\"ˆ�\0u�J[�ڪ��?Z�x}jq-��Mm�u�\\�Eh��c�,\rkݙ׺7�e!NO��\0\0V�@�,{�+/�L\0�B���Q{����,,�P��%�\n§p&\0��jNP7�IV4-<[n\0�>�\"�:���\0G\"M����O��C�N��^�I|�ʓ���p*���\084D��F�b���:H�\0J�+�^}d�V��1ػ���ۻ�c�l_���<�Z�Y���E�\0K��JX��r�_�����hW[q&@eʳh�[���������Z�̸l�M56<�w\0@I��.噊_G��:JI�l�Eͩ���T\0,œǕ���m�y���&�MwJ�S�������^��Q�P��z{06����Zv�L\n�O����%f��kG\r\\7{��Jipwo=���ߦ�[�����L�$��l|/�w�������q��ī��d�ןh��5������_v�\0\0���nٺ�u�\0\0\0\0IEND�B`�'),
(8,5,'�PNG\r\n\Z\n\0\0\0\rIHDR\0\0\0\0\0\0\0\0\0f�:%\0\0\0PLTE���\0\0\0U��~\0\0GIDATx���q� ���GB ��H���8r���^3��v��K�f��uo{�iI^ގ�x\0䅤�y!��V��*Z<k�\"�d@�Ի�&�>�s</����;�$��ZPD�,g�������e`$o��lɕ=d��=70�LE|��r:9�5�z㨡v\0{ �m�\0��<<.�/@y�|y�p��ֳ�:n̈W�d_	Pv+%ȳ)���_;��\0|qC?���\Z��{��\Z��7�Q��r�B�Eԭ\r��BJ)�drg!\0��.�O��Y_�9`a�w�$����z�b	`������&հ��N�Ɯ5TА�u\0����{ud�拇T[��U!խ�=�۫\0Z(�Bj%賐=4`��\"J=K*�i̺�jI�c��y-�Yϒ�\\٘}��zv��6%or<[��#��F-\0��w_�\"e`T�����rl����6����g[�H\n�e&��:�@t��ܲ�tl�E`,\0ܷ�*T��S�V�}i�ۀm���!��H&r�\"�k�c�#��x|n��4b!kd��D�ET�1J=k4ݗ�]x$�}a� ��g���zf�����\0\0����I���\0\0\0\0IEND�B`�');
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
