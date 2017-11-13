-- MySQL dump 10.14  Distrib 5.5.44-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: eor_ods
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
  `source` varchar(145) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `priority` varchar(5) DEFAULT NULL,
  `type` varchar(3) NOT NULL,
  `command` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `min_value` varchar(5) DEFAULT NULL,
  `is_define` tinyint(1) DEFAULT '0',
  `lilac_flag` varchar(45) DEFAULT NULL,
  `is_reported` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`name`,`source`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bp_contract`
--

DROP TABLE IF EXISTS `bp_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_contract` (
  `bp_name` varchar(255) NOT NULL,
  `bp_name_source` varchar(145) NOT NULL,
  `contract_id` int(11) NOT NULL,
  `chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`bp_name`,`bp_name_source`,`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `bp_name_source` varchar(45) NOT NULL,
  `bp_link_source` varchar(45) NOT NULL,
  `chg_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`,`bp_name`,`bp_link`,`bp_name_source`,`bp_link_source`)
) ENGINE=MyISAM AUTO_INCREMENT=824 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bp_links_analysis`
--

DROP TABLE IF EXISTS `bp_links_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_links_analysis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bp_master_name` varchar(60) DEFAULT NULL,
  `bp_master_source` varchar(45) DEFAULT NULL,
  `bp_link_name` varchar(60) DEFAULT NULL,
  `bp_link_source` varchar(45) DEFAULT NULL,
  `bp_link_parent_name` varchar(60) DEFAULT NULL,
  `bp_link_parent_source` varchar(45) DEFAULT NULL,
  `chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=102 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bp_services`
--

DROP TABLE IF EXISTS `bp_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bp_services` (
  `host_service_id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `host_service_source` varchar(145) NOT NULL,
  `bp_name` varchar(255) NOT NULL,
  `bp_source` varchar(255) NOT NULL,
  `host` varchar(255) NOT NULL,
  `service` varchar(255) NOT NULL,
  `chg_id` varchar(45) DEFAULT NULL,
  `is_reported` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`host_service_id`,`host_service_source`,`bp_name`,`bp_source`),
  KEY `idx_bp_service_host` (`host`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=80623 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chargements`
--

DROP TABLE IF EXISTS `chargements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chargements` (
  `chg_id` int(11) NOT NULL AUTO_INCREMENT,
  `chg_etl` varchar(45) DEFAULT NULL,
  `chg_date` date DEFAULT NULL,
  `chg_source` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`chg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract` (
  `ID_CONTRACT` int(11) NOT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(50) DEFAULT NULL,
  `CONTRACT_SDM_INTERN` varchar(50) DEFAULT NULL,
  `CONTRACT_SDM_EXTERN` varchar(50) DEFAULT NULL,
  `COMPANY` varchar(50) DEFAULT NULL,
  `EXTERN_CONTRACT_ID` varchar(30) DEFAULT NULL,
  `VALIDITY_DATE` date DEFAULT NULL,
  `CHG_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_context`
--

DROP TABLE IF EXISTS `contract_context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_context` (
  `ID_CONTRACT_CONTEXT` int(11) NOT NULL,
  `ID_CONTRACT` int(11) DEFAULT NULL,
  `ID_TIME_PERIOD` int(11) DEFAULT NULL,
  `ID_KPI` int(11) DEFAULT NULL,
  `CHG_ID` int(11) DEFAULT NULL,
  `ID_STEP_GROUP` int(11) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT_CONTEXT`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT_CONTEXT`,`APPLICATION_NAME`,`APPLICATION_SOURCE`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_context_application_ttr`
--

DROP TABLE IF EXISTS `contract_context_application_ttr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_context_application_ttr` (
  `ID_CONTRACT_CONTEXT_TTR` int(11) NOT NULL,
  `APPLICATION_NAME` varchar(60) NOT NULL,
  `APPLICATION_SOURCE` varchar(15) NOT NULL,
  `chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT_CONTEXT_TTR`,`APPLICATION_NAME`,`APPLICATION_SOURCE`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_context_ttr`
--

DROP TABLE IF EXISTS `contract_context_ttr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_context_ttr` (
  `ID_CONTRACT_CONTEXT_TTR` int(11) NOT NULL,
  `ID_CONTRACT` int(11) DEFAULT NULL,
  `ID_TIME_PERIOD` int(11) DEFAULT NULL,
  `ID_KPI` int(11) DEFAULT NULL,
  `CHG_ID` int(11) DEFAULT NULL,
  `ID_STEP_GROUP` int(11) DEFAULT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID_CONTRACT_CONTEXT_TTR`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `host`
--

DROP TABLE IF EXISTS `host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host` (
  `host_id` int(11) NOT NULL,
  `host_name` varchar(255) DEFAULT NULL,
  `chg_id` varchar(145) DEFAULT NULL,
  `source_id` varchar(45) NOT NULL,
  PRIMARY KEY (`host_id`,`source_id`),
  KEY `idx_host_source_id` (`source_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kpi`
--

DROP TABLE IF EXISTS `kpi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kpi` (
  `ID_KPI` int(11) NOT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  `ALIAS` longtext,
  `UNIT_COMPUT` varchar(50) DEFAULT NULL,
  `UNIT_PRESENTATION` varchar(50) DEFAULT NULL,
  `CHG_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_KPI`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `type` varchar(255) DEFAULT NULL,
  `time` int(10) NOT NULL,
  `state` tinyint(4) DEFAULT NULL,
  `state_type` varchar(45) DEFAULT NULL,
  `host_id` int(11) NOT NULL,
  `service_id` int(11) DEFAULT NULL,
  `message` int(11) NOT NULL,
  `chg_id` int(11) DEFAULT NULL,
  `source_id` varchar(15) NOT NULL,
  `down_flag` tinyint(4) DEFAULT NULL,
  KEY `idx_logs_source` (`source_id`) USING BTREE,
  KEY `idx_logs_message` (`message`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs_solarwind`
--

DROP TABLE IF EXISTS `logs_solarwind`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs_solarwind` (
  `host_name` varchar(255) NOT NULL DEFAULT '',
  `time` varchar(100) NOT NULL DEFAULT '',
  `availability_rate` int(11) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `message` varchar(500) DEFAULT NULL,
  `chg_id` varchar(45) DEFAULT NULL,
  `source_id` varchar(45) NOT NULL,
  PRIMARY KEY (`message_id`,`source_id`),
  KEY `idx_message_source_id` (`source_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `services_id` int(11) NOT NULL,
  `host_id` int(11) NOT NULL,
  `service_name` varchar(255) DEFAULT NULL,
  `chg_id` varchar(145) DEFAULT NULL,
  `source_id` varchar(45) NOT NULL,
  PRIMARY KEY (`services_id`,`host_id`,`source_id`),
  KEY `idx_service_source_id` (`source_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `step_group`
--

DROP TABLE IF EXISTS `step_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step_group` (
  `ID_STEP_GROUP` int(11) NOT NULL,
  `ID_KPI` int(11) DEFAULT NULL,
  `STEP_GROUP_ALIAS` varchar(45) DEFAULT NULL,
  `STEP_NUMBER` tinyint(4) DEFAULT NULL,
  `step_1_min` decimal(10,3) DEFAULT NULL,
  `step_1_max` decimal(10,3) DEFAULT NULL,
  `step_2_min` decimal(10,3) DEFAULT NULL,
  `step_2_max` decimal(10,3) DEFAULT NULL,
  `step_3_min` decimal(10,3) DEFAULT NULL,
  `step_3_max` decimal(10,3) DEFAULT NULL,
  `step_4_min` decimal(10,3) DEFAULT NULL,
  `step_4_max` decimal(10,3) DEFAULT NULL,
  `step_5_min` decimal(10,3) DEFAULT NULL,
  `step_5_max` decimal(10,3) DEFAULT NULL,
  `step_6_min` decimal(10,3) DEFAULT NULL,
  `step_6_max` decimal(10,3) DEFAULT NULL,
  `step_7_min` decimal(10,3) DEFAULT NULL,
  `step_7_max` decimal(10,3) DEFAULT NULL,
  `step_8_min` decimal(10,3) DEFAULT NULL,
  `step_8_max` decimal(10,3) DEFAULT NULL,
  `step_9_min` decimal(10,3) DEFAULT NULL,
  `step_9_max` decimal(10,3) DEFAULT NULL,
  `step_10_min` decimal(10,3) DEFAULT NULL,
  `step_10_max` decimal(10,3) DEFAULT NULL,
  `CHG_ID` int(11) DEFAULT NULL,
  `TYPE` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`ID_STEP_GROUP`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_period`
--

DROP TABLE IF EXISTS `time_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_period` (
  `tp_id` int(11) DEFAULT NULL,
  `tp_name` varchar(255) NOT NULL,
  `tp_entry` varchar(255) NOT NULL,
  `tp_alias` varchar(255) DEFAULT NULL,
  `chg_id` varchar(255) DEFAULT NULL,
  `tp_h_open` varchar(255) NOT NULL DEFAULT '00:00',
  `tp_h_close` varchar(255) NOT NULL DEFAULT '23:59',
  PRIMARY KEY (`tp_name`,`tp_entry`,`tp_h_open`,`tp_h_close`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-27 11:07:01
