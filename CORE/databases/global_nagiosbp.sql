-- MySQL dump 10.14  Distrib 5.5.44-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: global_nagiosbp
-- ------------------------------------------------------
-- Server version	5.5.44-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bp`
--

DROP TABLE IF EXISTS `bp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp` (
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `priority` varchar(5) DEFAULT NULL,
  `type` varchar(3) NOT NULL,
  `command` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `min_value` varchar(5) DEFAULT NULL,
  `is_define` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bp`
--

LOCK TABLES `bp` WRITE;
/*!40000 ALTER TABLE `bp` DISABLE KEYS */;
/*!40000 ALTER TABLE `bp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bp_category`
--

DROP TABLE IF EXISTS `bp_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_category` (
  `idbp_category` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `bp_source` varchar(45) DEFAULT NULL,
  `bp_name` varchar(150) DEFAULT NULL,
  `category` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idbp_category`),
  UNIQUE KEY `idbp_category_UNIQUE` (`idbp_category`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bp_category`
--

LOCK TABLES `bp_category` WRITE;
/*!40000 ALTER TABLE `bp_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `bp_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bp_links`
--

DROP TABLE IF EXISTS `bp_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_links` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `bp_name` varchar(255) NOT NULL,
  `bp_link` varchar(255) NOT NULL,
  `bp_source` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bp_links`
--

LOCK TABLES `bp_links` WRITE;
/*!40000 ALTER TABLE `bp_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `bp_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bp_links_analysis`
--

DROP TABLE IF EXISTS `bp_links_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_links_analysis` (
  `bp_master_name` varchar(60) NOT NULL,
  `bp_master_source` varchar(15) NOT NULL,
  `bp_link_name` varchar(60) NOT NULL,
  `bp_link_source` varchar(45) NOT NULL DEFAULT '',
  `bp_link_parent_name` varchar(60) DEFAULT NULL,
  `bp_link_parent_source` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`bp_master_name`,`bp_master_source`,`bp_link_name`,`bp_link_source`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bp_links_analysis`
--

LOCK TABLES `bp_links_analysis` WRITE;
/*!40000 ALTER TABLE `bp_links_analysis` DISABLE KEYS */;
/*!40000 ALTER TABLE `bp_links_analysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bp_services`
--

DROP TABLE IF EXISTS `bp_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_services` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `bp_name` varchar(255) NOT NULL,
  `host` varchar(255) NOT NULL,
  `service` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bp_services`
--

LOCK TABLES `bp_services` WRITE;
/*!40000 ALTER TABLE `bp_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `bp_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bp_sources`
--

DROP TABLE IF EXISTS `bp_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_sources` (
  `idbp_sources` int(11) NOT NULL AUTO_INCREMENT,
  `db_names` varchar(45) NOT NULL,
  `nick_name` varchar(50) DEFAULT NULL,
  `thruk_idx` varchar(10) DEFAULT NULL,
  `name` varchar(30) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `type_source` varchar(3) DEFAULT NULL,
  `trigram_source` varchar(3) DEFAULT NULL,
  `ssh_port` int(11) DEFAULT NULL,
  `container_ssh` varchar(45) DEFAULT NULL,
  `container_nagios` varchar(45) DEFAULT NULL,
  `trigram_site` varchar(45) DEFAULT NULL,
  `host_source` varchar(45) DEFAULT NULL,
  `host_source_public_key` longtext,
  `host_source_private_key` longtext,
  `flag_nagiosbp` tinyint(4) DEFAULT NULL,
  `flag_lilac` tinyint(4) DEFAULT NULL,
  `flag_ged` tinyint(4) DEFAULT NULL,
  `flag_thruk` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`idbp_sources`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bp_sources`
--

LOCK TABLES `bp_sources` WRITE;
/*!40000 ALTER TABLE `bp_sources` DISABLE KEYS */;
INSERT INTO `bp_sources` VALUES (1,'global_nagiosbp','global','NR',NULL,NULL,'glb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,0);
/*!40000 ALTER TABLE `bp_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company` (
  `ID_COMPANY` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_COMPANY`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (13,'Axians Cloud Builder','');
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract` (
  `ID_CONTRACT` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(50) DEFAULT NULL,
  `CONTRACT_SDM_INTERN` varchar(50) DEFAULT NULL,
  `CONTRACT_SDM_EXTERN` varchar(50) DEFAULT NULL,
  `ID_COMPANY` int(11) DEFAULT NULL,
  `EXTERN_CONTRACT_ID` varchar(30) DEFAULT NULL,
  `VALIDITY_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT`),
  KEY `ID_COMPANY` (`ID_COMPANY`),
  CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`ID_COMPANY`) REFERENCES `company` (`ID_COMPANY`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract`
--

LOCK TABLES `contract` WRITE;
/*!40000 ALTER TABLE `contract` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_context`
--

DROP TABLE IF EXISTS `contract_context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_context` (
  `ID_CONTRACT_CONTEXT` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(50) DEFAULT NULL,
  `ID_CONTRACT` int(11) DEFAULT NULL,
  `ID_TIME_PERIOD` int(11) DEFAULT NULL,
  `ID_KPI` int(11) DEFAULT NULL,
  `ID_STEP_GROUP` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT_CONTEXT`),
  KEY `ID_CONTRACT` (`ID_CONTRACT`),
  KEY `ID_TIME_PERIOD` (`ID_TIME_PERIOD`),
  KEY `ID_KPI` (`ID_KPI`),
  KEY `ID_STEP_GROUP` (`ID_STEP_GROUP`),
  CONSTRAINT `contract_context_ibfk_1` FOREIGN KEY (`ID_CONTRACT`) REFERENCES `contract` (`ID_CONTRACT`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contract_context_ibfk_2` FOREIGN KEY (`ID_TIME_PERIOD`) REFERENCES `time_period` (`ID_TIME_PERIOD`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contract_context_ibfk_3` FOREIGN KEY (`ID_KPI`) REFERENCES `kpi` (`ID_KPI`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contract_context_ibfk_4` FOREIGN KEY (`ID_STEP_GROUP`) REFERENCES `step_group` (`ID_STEP_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_context`
--

LOCK TABLES `contract_context` WRITE;
/*!40000 ALTER TABLE `contract_context` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_context` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_context_application`
--

DROP TABLE IF EXISTS `contract_context_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_context_application` (
  `ID_CONTRACT_CONTEXT` int(11) NOT NULL,
  `APPLICATION_NAME` varchar(60) NOT NULL,
  `APPLICATION_SOURCE` varchar(15) NOT NULL,
  PRIMARY KEY (`ID_CONTRACT_CONTEXT`,`APPLICATION_NAME`,`APPLICATION_SOURCE`),
  CONSTRAINT `contract_context_application_ibfk_1` FOREIGN KEY (`ID_CONTRACT_CONTEXT`) REFERENCES `contract_context` (`ID_CONTRACT_CONTEXT`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_context_application`
--

LOCK TABLES `contract_context_application` WRITE;
/*!40000 ALTER TABLE `contract_context_application` DISABLE KEYS */;
/*!40000 ALTER TABLE `contract_context_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kpi`
--

DROP TABLE IF EXISTS `kpi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kpi` (
  `ID_KPI` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` longtext,
  `ID_UNIT_COMPUT` int(11) DEFAULT NULL,
  `ID_UNIT_PRESENTATION` int(11) DEFAULT NULL,
  `CODE` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`ID_KPI`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kpi`
--

LOCK TABLES `kpi` WRITE;
/*!40000 ALTER TABLE `kpi` DISABLE KEYS */;
INSERT INTO `kpi` VALUES (1,'Availability','',1,1,'AVL');
/*!40000 ALTER TABLE `kpi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `last_entry`
--

DROP TABLE IF EXISTS `last_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `last_entry` (
  `ID_LAST_ENTRY` int(11) NOT NULL AUTO_INCREMENT,
  `STATUS` varchar(10) DEFAULT NULL,
  `TABLE_NAME` varchar(50) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `DATE_ENTRY` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_LAST_ENTRY`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `last_entry`
--

LOCK TABLES `last_entry` WRITE;
/*!40000 ALTER TABLE `last_entry` DISABLE KEYS */;
INSERT INTO `last_entry` VALUES (4,'Update','company','Axians Cloud Builder','2016-09-07 12:41:04'),(5,'Update','time_period','5j/7 7h/19','2016-09-07 12:41:31'),(6,'Update','time_period','7j/7 24h/24','2016-09-07 12:41:55'),(7,'Update','step_group','High Availability','2016-09-07 12:42:14'),(8,'Update','step_group','Standard Threshold','2016-09-07 12:42:24');
/*!40000 ALTER TABLE `last_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `step_group`
--

DROP TABLE IF EXISTS `step_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step_group` (
  `ID_STEP_GROUP` int(11) NOT NULL AUTO_INCREMENT,
  `ID_KPI` int(11) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(50) DEFAULT NULL,
  `STEP_NUMBER` smallint(6) DEFAULT NULL,
  `STEP_1_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_1_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_2_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_2_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_3_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_3_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_4_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_4_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_5_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_5_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_6_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_6_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_7_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_7_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_8_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_8_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_9_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_9_MAX` decimal(10,3) DEFAULT NULL,
  `STEP_10_MIN` decimal(10,3) DEFAULT NULL,
  `STEP_10_MAX` decimal(10,3) DEFAULT NULL,
  `TYPE` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID_STEP_GROUP`),
  KEY `ID_KPI` (`ID_KPI`),
  CONSTRAINT `step_group_ibfk_1` FOREIGN KEY (`ID_KPI`) REFERENCES `kpi` (`ID_KPI`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `step_group`
--

LOCK TABLES `step_group` WRITE;
/*!40000 ALTER TABLE `step_group` DISABLE KEYS */;
INSERT INTO `step_group` VALUES (6,1,'High Availability',NULL,4,0.000,99.700,99.700,99.800,99.800,99.900,99.900,100.000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'%'),(7,1,'Standard Threshold',NULL,4,0.000,95.000,95.000,97.000,97.000,98.500,98.500,100.000,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'%');
/*!40000 ALTER TABLE `step_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_period`
--

DROP TABLE IF EXISTS `time_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_period` (
  `ID_TIME_PERIOD` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_TIME_PERIOD`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_period`
--

LOCK TABLES `time_period` WRITE;
/*!40000 ALTER TABLE `time_period` DISABLE KEYS */;
INSERT INTO `time_period` VALUES (3,'7j/7 24h/24','7j/7 24h/24'),(4,'5j/7 7h/19','7h00 19h00 lundi vendredi');
/*!40000 ALTER TABLE `time_period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `timeperiod_entry`
--

DROP TABLE IF EXISTS `timeperiod_entry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `timeperiod_entry` (
  `ID_TIMEPERIOD_ENTRY` int(11) NOT NULL AUTO_INCREMENT,
  `ID_TIME_PERIOD` int(11) DEFAULT NULL,
  `ENTRY` varchar(50) DEFAULT NULL,
  `H_OPEN` varchar(5) DEFAULT NULL,
  `H_CLOSE` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`ID_TIMEPERIOD_ENTRY`),
  KEY `ID_TIME_PERIOD` (`ID_TIME_PERIOD`),
  CONSTRAINT `timeperiod_entry_ibfk_1` FOREIGN KEY (`ID_TIME_PERIOD`) REFERENCES `time_period` (`ID_TIME_PERIOD`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timeperiod_entry`
--

LOCK TABLES `timeperiod_entry` WRITE;
/*!40000 ALTER TABLE `timeperiod_entry` DISABLE KEYS */;
INSERT INTO `timeperiod_entry` VALUES (47,4,'lundi','07:00','19:00'),(48,4,'mardi','07:00','19:00'),(49,4,'mercredi','07:00','19:00'),(50,4,'jeudi','07:00','19:00'),(51,4,'vendredi','07:00','19:00'),(52,3,'lundi','00:00','23:59'),(53,3,'mardi','00:00','23:59'),(54,3,'mercredi','00:00','23:59'),(55,3,'jeudi','00:00','23:59'),(56,3,'vendredi','00:00','23:59'),(57,3,'samedi','00:00','23:59'),(58,3,'dimanche','00:00','23:59');
/*!40000 ALTER TABLE `timeperiod_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit` (
  `ID_UNIT` int(11) NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `SHORT_NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_UNIT`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit`
--

LOCK TABLES `unit` WRITE;
/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
INSERT INTO `unit` VALUES (1,'minute','min');
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-07 15:20:45
