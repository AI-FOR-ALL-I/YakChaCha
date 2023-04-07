-- MariaDB dump 10.19  Distrib 10.10.2-MariaDB, for Win64 (AMD64)
--
-- Host: j8a803.p.ssafy.io    Database: dev
-- ------------------------------------------------------
-- Server version	10.11.2-MariaDB-1:10.11.2+maria~ubu2204

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
-- Table structure for table `account`
--

DROP TABLE IF EXISTS `account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account` (
  `account_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `device_token` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`account_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `collision`
--

DROP TABLE IF EXISTS `collision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collision` (
  `collision_seq` int(11) NOT NULL AUTO_INCREMENT,
  `medicine_a_id` int(11) DEFAULT NULL,
  `medicine_a_material` varchar(45) DEFAULT NULL,
  `medicine_b_id` int(11) DEFAULT NULL,
  `medicine_b_material` varchar(45) DEFAULT NULL,
  `detail` varchar(2000) DEFAULT NULL,
  `a_material` varchar(255) DEFAULT NULL,
  `b_material` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`collision_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=571198 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicine` (
  `medicine_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `edi_code` varchar(149) DEFAULT NULL,
  `img` varchar(70) DEFAULT NULL,
  `item_name` varchar(391) DEFAULT NULL,
  `item_seq` bigint(20) DEFAULT NULL,
  `type_code` varchar(35) DEFAULT NULL,
  `medicine_detail_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`medicine_seq`),
  UNIQUE KEY `item_seq_UNIQUE` (`item_seq`),
  KEY `FKisykrhd7qwydbge8cy4y3mwyv` (`medicine_detail_seq`),
  CONSTRAINT `FKisykrhd7qwydbge8cy4y3mwyv` FOREIGN KEY (`medicine_detail_seq`) REFERENCES `medicine_detail` (`medicine_detail_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=52709 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicine_detail`
--

DROP TABLE IF EXISTS `medicine_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicine_detail` (
  `medicine_detail_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `ee_doc_data` mediumtext DEFAULT NULL,
  `material_name` text DEFAULT NULL,
  `nb_doc_data` mediumtext DEFAULT NULL,
  `ud_doc_data` mediumtext DEFAULT NULL,
  `entp_name` varchar(22) DEFAULT NULL,
  `item_permit_date` varchar(8) DEFAULT NULL,
  `etc_otc_code` varchar(5) DEFAULT NULL,
  `chart` varchar(1000) DEFAULT NULL,
  `class_no` varchar(36) DEFAULT NULL,
  `valid_term` varchar(83) DEFAULT NULL,
  `storage_method` varchar(618) DEFAULT NULL,
  `pack_unit` varchar(615) DEFAULT NULL,
  `change_date` varchar(8) DEFAULT NULL,
  `main_item_ingr` varchar(2043) DEFAULT NULL,
  `ingr_name` varchar(3985) DEFAULT NULL,
  PRIMARY KEY (`medicine_detail_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=52709 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_medicine`
--

DROP TABLE IF EXISTS `my_medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `my_medicine` (
  `my_medicine_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `end_date` datetime(6) DEFAULT NULL,
  `finish` varchar(1) DEFAULT NULL,
  `start_date` datetime(6) DEFAULT NULL,
  `medicine_seq` bigint(20) DEFAULT NULL,
  `profile_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`my_medicine_seq`),
  KEY `FKssktl1xf2yd7nf2tj3vihrx2i` (`medicine_seq`),
  KEY `FKmbrywmcggq6tsdlebs19uucab` (`profile_seq`),
  CONSTRAINT `FKmbrywmcggq6tsdlebs19uucab` FOREIGN KEY (`profile_seq`) REFERENCES `profile` (`profile_seq`),
  CONSTRAINT `FKssktl1xf2yd7nf2tj3vihrx2i` FOREIGN KEY (`medicine_seq`) REFERENCES `medicine` (`medicine_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `my_medicine_has_tag`
--

DROP TABLE IF EXISTS `my_medicine_has_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `my_medicine_has_tag` (
  `mmht_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `my_medicine_seq` bigint(20) DEFAULT NULL,
  `tag_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`mmht_seq`),
  KEY `FKknaw0nf2vh0kpor7au76h48jx` (`my_medicine_seq`),
  KEY `FK6gi59mc72ecu1ul9wvrb19437` (`tag_seq`),
  CONSTRAINT `FK6gi59mc72ecu1ul9wvrb19437` FOREIGN KEY (`tag_seq`) REFERENCES `tag` (`tag_seq`),
  CONSTRAINT `FKknaw0nf2vh0kpor7au76h48jx` FOREIGN KEY (`my_medicine_seq`) REFERENCES `my_medicine` (`my_medicine_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news` (
  `news_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `img` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`news_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile` (
  `profile_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `birth_date` date NOT NULL,
  `gender` varchar(1) NOT NULL,
  `name` varchar(255) NOT NULL,
  `pregnancy` tinyint(4) NOT NULL,
  PRIMARY KEY (`profile_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `profile_link`
--

DROP TABLE IF EXISTS `profile_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_link` (
  `profile_link_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `img_code` int(11) NOT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `account_seq` bigint(20) DEFAULT NULL,
  `owner_seq` bigint(20) DEFAULT NULL,
  `profile_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`profile_link_seq`),
  KEY `FKfhpnr1ook1s7c43bw8xe8ffts` (`account_seq`),
  KEY `FKa8v678sk6dqckrr4iwchifufk` (`owner_seq`),
  KEY `FK82fec64myg6v4hxnsxi0vlbpe` (`profile_seq`),
  CONSTRAINT `FK82fec64myg6v4hxnsxi0vlbpe` FOREIGN KEY (`profile_seq`) REFERENCES `profile` (`profile_seq`),
  CONSTRAINT `FKa8v678sk6dqckrr4iwchifufk` FOREIGN KEY (`owner_seq`) REFERENCES `account` (`account_seq`),
  CONSTRAINT `FKfhpnr1ook1s7c43bw8xe8ffts` FOREIGN KEY (`account_seq`) REFERENCES `account` (`account_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reminder`
--

DROP TABLE IF EXISTS `reminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reminder` (
  `reminder_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `taken` bit(1) NOT NULL,
  `time` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `profile_seq` bigint(20) NOT NULL,
  PRIMARY KEY (`reminder_seq`),
  KEY `FKrtx1q2doou0rm4rg0xwdxu5fr` (`profile_seq`),
  CONSTRAINT `FKrtx1q2doou0rm4rg0xwdxu5fr` FOREIGN KEY (`profile_seq`) REFERENCES `profile` (`profile_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reminder_medicine`
--

DROP TABLE IF EXISTS `reminder_medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reminder_medicine` (
  `reminder_medicine_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `count` int(11) NOT NULL,
  `medicine_seq` bigint(20) NOT NULL,
  `reminder_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`reminder_medicine_seq`),
  KEY `FKqgor3d3unyth00uooouirrho3` (`reminder_seq`),
  CONSTRAINT `FKqgor3d3unyth00uooouirrho3` FOREIGN KEY (`reminder_seq`) REFERENCES `reminder` (`reminder_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=314 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `tag_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `color` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `profile_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`tag_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taken_record`
--

DROP TABLE IF EXISTS `taken_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taken_record` (
  `taken_record_seq` bigint(20) NOT NULL AUTO_INCREMENT,
  `del_yn` varchar(255) DEFAULT NULL,
  `mod_account_seq` bigint(20) DEFAULT NULL,
  `mod_dttm` datetime(6) DEFAULT NULL,
  `reg_account_seq` bigint(20) DEFAULT NULL,
  `reg_dttm` datetime(6) DEFAULT NULL,
  `date` date NOT NULL,
  `reminder_seq` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`taken_record_seq`),
  KEY `FKqoem6msl6t730psgy4nljsij4` (`reminder_seq`),
  CONSTRAINT `FKqoem6msl6t730psgy4nljsij4` FOREIGN KEY (`reminder_seq`) REFERENCES `reminder` (`reminder_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-07 11:46:58
