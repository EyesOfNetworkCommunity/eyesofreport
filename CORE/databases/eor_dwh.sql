-- MySQL dump 10.14  Distrib 5.5.44-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: eor_dwh
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
-- Table structure for table `d_application`
--

DROP TABLE IF EXISTS `d_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_application` (
  `DAP_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DAP_NAME` varchar(150) NOT NULL,
  `DAP_DESCRIPTION` varchar(255) DEFAULT NULL,
  `DAP_CHG_ID` varchar(150) DEFAULT NULL,
  `DAP_SOURCE` varchar(45) NOT NULL,
  `DAP_CATEGORY` varchar(45) NOT NULL,
  `DAP_PRIORITY` tinyint(4) DEFAULT NULL,
  `DAP_TYPE` varchar(45) NOT NULL,
  `DAP_MIN` int(11) DEFAULT NULL,
  PRIMARY KEY (`DAP_ID`,`DAP_NAME`,`DAP_SOURCE`)
) ENGINE=InnoDB AUTO_INCREMENT=350 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_application_complete_link`
--

DROP TABLE IF EXISTS `d_application_complete_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_application_complete_link` (
  `acl_master` int(11) NOT NULL,
  `acl_link` int(11) NOT NULL,
  PRIMARY KEY (`acl_master`,`acl_link`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_application_contract_link`
--

DROP TABLE IF EXISTS `d_application_contract_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_application_contract_link` (
  `ack_appli_id` int(11) NOT NULL,
  `ack_dcc_id` int(11) NOT NULL,
  PRIMARY KEY (`ack_appli_id`,`ack_dcc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_application_contract_link_ttr`
--

DROP TABLE IF EXISTS `d_application_contract_link_ttr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_application_contract_link_ttr` (
  `ack_appli_id` int(11) NOT NULL,
  `ack_dcc_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_application_link`
--

DROP TABLE IF EXISTS `d_application_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_application_link` (
  `dal_id` int(11) NOT NULL AUTO_INCREMENT,
  `dal_app_master_name` varchar(45) DEFAULT NULL,
  `dal_app_master_id` int(11) DEFAULT NULL,
  `dal_app_link_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=389 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_application_link_analysis`
--

DROP TABLE IF EXISTS `d_application_link_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_application_link_analysis` (
  `dla_id` int(11) NOT NULL AUTO_INCREMENT,
  `dla_app_master_id` int(11) DEFAULT NULL,
  `dla_app_master_source` varchar(45) DEFAULT NULL,
  `dla_app_link_id` int(11) DEFAULT NULL,
  `dla_app_link_source` varchar(45) DEFAULT NULL,
  `dla_cat_analysis` int(11) DEFAULT NULL,
  `dls_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dla_id`)
) ENGINE=MyISAM AUTO_INCREMENT=92 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_category`
--

DROP TABLE IF EXISTS `d_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_category` (
  `CAT_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CAT_LABEL` varchar(255) DEFAULT NULL,
  `CAT_CCHG_ID` varchar(145) DEFAULT NULL,
  PRIMARY KEY (`CAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_category_analysis`
--

DROP TABLE IF EXISTS `d_category_analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_category_analysis` (
  `CAA_ID` int(11) NOT NULL AUTO_INCREMENT,
  `CAA_LABEL` varchar(255) DEFAULT NULL,
  `CAA_CCHG_ID` varchar(145) DEFAULT NULL,
  PRIMARY KEY (`CAA_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_chargement`
--

DROP TABLE IF EXISTS `d_chargement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_chargement` (
  `chg_id` int(11) NOT NULL AUTO_INCREMENT,
  `chg_source` varchar(145) DEFAULT NULL,
  `chg_etl_name` varchar(145) DEFAULT NULL,
  `chg_date` date DEFAULT NULL,
  PRIMARY KEY (`chg_id`)
) ENGINE=InnoDB AUTO_INCREMENT=541 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_contract`
--

DROP TABLE IF EXISTS `d_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_contract` (
  `dco_id` int(11) NOT NULL,
  `dco_name` varchar(50) DEFAULT NULL,
  `dco_alias` varchar(50) DEFAULT NULL,
  `dco_contract_dsm_intern` varchar(50) DEFAULT NULL,
  `dco_contract_dsm_extern` varchar(50) DEFAULT NULL,
  `dco_company` varchar(50) DEFAULT NULL,
  `dco_extern_contract_id` varchar(30) DEFAULT NULL,
  `dco_validity_date` date DEFAULT NULL,
  `dco_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dco_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_contract_context`
--

DROP TABLE IF EXISTS `d_contract_context`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_contract_context` (
  `dcc_id` int(11) NOT NULL,
  `dcc_dco_id` int(11) DEFAULT NULL,
  `dcc_tpr_id` int(11) DEFAULT NULL,
  `dcc_kpi_id` int(11) DEFAULT NULL,
  `dcc_chg_id` int(11) DEFAULT NULL,
  `dcc_dsg_id` int(11) DEFAULT NULL,
  `dcc_alias` varchar(50) DEFAULT NULL,
  `dcc_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`dcc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_contract_context_application`
--

DROP TABLE IF EXISTS `d_contract_context_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_contract_context_application` (
  `dca_dcc_id` int(11) NOT NULL,
  `dca_appli_id` int(11) NOT NULL,
  `dca_dco_id` int(11) NOT NULL,
  `dca_tpr_id` int(11) NOT NULL,
  `dca_kpi_id` int(11) NOT NULL,
  `dca_chg_id` int(11) DEFAULT NULL,
  `dca_dsg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dca_dcc_id`,`dca_appli_id`,`dca_dco_id`,`dca_tpr_id`,`dca_kpi_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_contract_context_application_ttr`
--

DROP TABLE IF EXISTS `d_contract_context_application_ttr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_contract_context_application_ttr` (
  `dca_dcc_id` int(11) NOT NULL,
  `dca_appli_id` int(11) NOT NULL,
  `dca_dco_id` int(11) NOT NULL,
  `dca_tpr_id` int(11) NOT NULL,
  `dca_kpi_id` int(11) NOT NULL,
  `dca_chg_id` int(11) DEFAULT NULL,
  `dca_dsg_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_contract_context_ttr`
--

DROP TABLE IF EXISTS `d_contract_context_ttr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_contract_context_ttr` (
  `dcc_id` int(11) NOT NULL,
  `dcc_dco_id` int(11) DEFAULT NULL,
  `dcc_tpr_id` int(11) DEFAULT NULL,
  `dcc_kpi_id` int(11) DEFAULT NULL,
  `dcc_chg_id` int(11) DEFAULT NULL,
  `dcc_dsg_id` int(11) DEFAULT NULL,
  `dcc_alias` varchar(50) DEFAULT NULL,
  `dcc_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`dcc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_hierarchy_column`
--

DROP TABLE IF EXISTS `d_hierarchy_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_hierarchy_column` (
  `dhc_id` int(11) NOT NULL AUTO_INCREMENT,
  `dhc_lvl1_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl1_source` varchar(45) DEFAULT NULL,
  `dhc_lvl2_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl3_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl4_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl5_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl6_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl7_id` mediumint(9) DEFAULT NULL,
  `dhc_chg_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl8_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl9_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl10_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl11_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl12_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl13_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl14_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl15_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl16_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl17_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl18_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl19_id` mediumint(9) DEFAULT NULL,
  `dhc_lvl20_id` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`dhc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1319 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_hierarchy_leaf`
--

DROP TABLE IF EXISTS `d_hierarchy_leaf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_hierarchy_leaf` (
  `app_master` int(11) NOT NULL DEFAULT '0',
  `app_leaf` int(11) NOT NULL,
  `host_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  PRIMARY KEY (`app_master`,`app_leaf`,`host_id`,`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_host`
--

DROP TABLE IF EXISTS `d_host`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_host` (
  `DHO_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DHO_SOURCE` varchar(145) NOT NULL,
  `DHO_NAME` varchar(150) NOT NULL,
  `DHO_CHG_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`DHO_ID`),
  KEY `idx_dho_source` (`DHO_SOURCE`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=325 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_host_service`
--

DROP TABLE IF EXISTS `d_host_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_host_service` (
  `dhs_id` int(11) NOT NULL AUTO_INCREMENT,
  `dhs_host` int(11) DEFAULT NULL,
  `dhs_service` int(11) DEFAULT NULL,
  `dhs_source` varchar(45) DEFAULT NULL,
  `dhs_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dhs_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9724 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_host_service_application`
--

DROP TABLE IF EXISTS `d_host_service_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_host_service_application` (
  `hsa_id` int(11) NOT NULL AUTO_INCREMENT,
  `hsa_host` mediumint(9) NOT NULL,
  `hsa_service` mediumint(9) NOT NULL,
  `hsa_appli` mediumint(9) NOT NULL,
  `hsa_chg_id` int(11) NOT NULL,
  PRIMARY KEY (`hsa_id`)
) ENGINE=MyISAM AUTO_INCREMENT=827 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_kpi`
--

DROP TABLE IF EXISTS `d_kpi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_kpi` (
  `kpi_id` int(11) NOT NULL,
  `kpi_name` varchar(50) DEFAULT NULL,
  `kpi_alias` longtext,
  `kpi_unit_compute` varchar(50) DEFAULT NULL,
  `kpi_unit_presentation` varchar(50) DEFAULT NULL,
  `kpi_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`kpi_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_message_type`
--

DROP TABLE IF EXISTS `d_message_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_message_type` (
  `met_id` int(11) NOT NULL AUTO_INCREMENT,
  `met_type_label` varchar(145) NOT NULL,
  `met_state_type_label` varchar(45) NOT NULL,
  PRIMARY KEY (`met_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_service`
--

DROP TABLE IF EXISTS `d_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_service` (
  `DSE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DSE_NAME` varchar(150) DEFAULT NULL,
  `DSE_CHG_ID` int(11) DEFAULT NULL,
  `DSE_SOURCE` varchar(145) DEFAULT NULL,
  PRIMARY KEY (`DSE_ID`),
  KEY `idx_dse_source` (`DSE_SOURCE`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=265 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_state_type`
--

DROP TABLE IF EXISTS `d_state_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_state_type` (
  `DTY_ID` int(11) NOT NULL,
  `DTY_NAME` varchar(150) DEFAULT NULL,
  `DTY_CHG_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`DTY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='si service est null alors on est state host, sinon on est st';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_step_group`
--

DROP TABLE IF EXISTS `d_step_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_step_group` (
  `dsg_id` int(11) NOT NULL,
  `kpi_id` int(11) DEFAULT NULL,
  `dsg_alias` varchar(45) DEFAULT NULL,
  `dsg_step_number` smallint(6) DEFAULT NULL,
  `dsg_step_1_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_1_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_2_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_2_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_3_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_3_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_4_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_4_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_5_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_5_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_6_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_6_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_7_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_7_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_8_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_8_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_9_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_9_max` decimal(10,3) DEFAULT NULL,
  `dsg_step_10_min` decimal(10,3) DEFAULT NULL,
  `dsg_step_10_max` decimal(10,3) DEFAULT NULL,
  `dsg_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`dsg_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_date`
--

DROP TABLE IF EXISTS `d_time_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_date` (
  `date` date NOT NULL,
  `year` int(11) DEFAULT NULL,
  `month` varchar(2) DEFAULT NULL,
  `day` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_dimension`
--

DROP TABLE IF EXISTS `d_time_dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_dimension` (
  `epoch_minute` int(11) NOT NULL,
  `epoch_hour` int(11) DEFAULT NULL,
  `epoch_day` int(11) DEFAULT NULL,
  `epoch_month` int(11) DEFAULT NULL,
  `epoch_year` int(11) DEFAULT NULL,
  `epoch_month_hour` int(11) DEFAULT NULL,
  `db_datetime` datetime NOT NULL,
  `db_date` date NOT NULL,
  `year` int(11) NOT NULL,
  `month` varchar(2) NOT NULL,
  `day` varchar(2) NOT NULL,
  `last_day_month` tinyint(4) DEFAULT NULL,
  `quarter` int(11) NOT NULL,
  `hour` varchar(2) NOT NULL,
  `minute` varchar(2) NOT NULL,
  `minute_day` int(11) NOT NULL,
  `day_name` varchar(9) NOT NULL,
  `month_name` varchar(9) NOT NULL,
  `weekend_flag` char(1) DEFAULT 'f',
  `nb_seconds_hour` mediumint(9) DEFAULT NULL,
  `nb_seconds_day` int(11) DEFAULT NULL,
  `nb_seconds_month` int(11) DEFAULT NULL,
  KEY `idx_d_time_dimension_hour` (`epoch_hour`) USING BTREE,
  KEY `idx_d_time_dimension_day` (`epoch_day`) USING BTREE,
  KEY `idx_d_time_dimension_month` (`epoch_month`) USING BTREE,
  KEY `idx_d_time_dimension_month_hour` (`epoch_month_hour`) USING BTREE,
  KEY `td_dbdate_idx` (`db_datetime`) USING BTREE,
  KEY `idx_d_time_dimension_year` (`year`) USING BTREE,
  KEY `idx_d_time_dimension_month_num` (`month`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_month`
--

DROP TABLE IF EXISTS `d_time_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_month` (
  `DTM_DATETIME` datetime NOT NULL,
  `DTM_DATE` date DEFAULT NULL,
  `DTM_TIME` time DEFAULT NULL,
  `DTM_DAY_WEEK` varchar(15) DEFAULT NULL,
  `DTM_DAY_WEEK_NB` int(11) DEFAULT NULL,
  `DTW_DAY_MONTH_NB` int(11) DEFAULT NULL,
  `DTW_MONTH` varchar(15) DEFAULT NULL,
  `DTW_MONTH_NB` int(11) DEFAULT NULL,
  `DTW_QUARTER_NB` int(11) DEFAULT NULL,
  `DTW_SEMESTER_NB` int(11) DEFAULT NULL,
  `DTW_YEAR` int(11) DEFAULT NULL,
  PRIMARY KEY (`DTM_DATETIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_period`
--

DROP TABLE IF EXISTS `d_time_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_period` (
  `TPR_ID` int(11) NOT NULL,
  `TPR_NAME` varchar(255) DEFAULT NULL,
  `TPR_ALIAS` varchar(255) DEFAULT NULL,
  `TPR_CHG_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`TPR_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_period_day`
--

DROP TABLE IF EXISTS `d_time_period_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_period_day` (
  `tpd_id` int(11) NOT NULL AUTO_INCREMENT,
  `tpd_day` varchar(2) NOT NULL,
  `tpd_month` varchar(2) NOT NULL,
  `tpd_year` mediumint(9) NOT NULL,
  `tpd_tpr_id` mediumint(9) NOT NULL,
  `nb_secondes` int(11) NOT NULL,
  PRIMARY KEY (`tpd_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1412 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_period_minute`
--

DROP TABLE IF EXISTS `d_time_period_minute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_period_minute` (
  `DTP_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DTP_TIMEPERIOD_ID` mediumint(9) DEFAULT NULL,
  `DTP_EPOCH_MINUTE` int(11) DEFAULT NULL,
  `DTP_CHG_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`DTP_ID`),
  KEY `idx_dtp_eopch_minute` (`DTP_EPOCH_MINUTE`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13686 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_period_month`
--

DROP TABLE IF EXISTS `d_time_period_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_period_month` (
  `tpm_id` int(11) NOT NULL AUTO_INCREMENT,
  `tpm_month` varchar(2) NOT NULL,
  `tpm_year` mediumint(9) NOT NULL,
  `tpm_tpr_id` mediumint(9) NOT NULL,
  `nb_secondes` int(11) NOT NULL,
  PRIMARY KEY (`tpm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `d_time_week`
--

DROP TABLE IF EXISTS `d_time_week`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `d_time_week` (
  `DTW_DATETIME` datetime NOT NULL,
  `DTW_DATE` date DEFAULT NULL,
  `DTW_TIME` time DEFAULT NULL,
  `DTW_DAY_WEEK` varchar(15) DEFAULT NULL,
  `DTW_DAY_WEEK_NB` int(11) DEFAULT NULL,
  `DTW_DAY_MONTH_NB` int(11) DEFAULT NULL,
  `DTW_WEEK_NB` int(11) DEFAULT NULL,
  `DTW_YEAR_NB` int(11) DEFAULT NULL,
  PRIMARY KEY (`DTW_DATETIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e_log_functional_error`
--

DROP TABLE IF EXISTS `e_log_functional_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_log_functional_error` (
  `DLR_ID` int(11) DEFAULT NULL,
  `DLR_DATE` date NOT NULL,
  `DLR_ETL_NAME` varchar(255) NOT NULL,
  `DLR_ERROR_CODE` int(11) DEFAULT NULL,
  `DLR_TABLE_NAME` varchar(255) DEFAULT NULL,
  `DLR_ID_ROW` varchar(255) DEFAULT NULL,
  `DLR_FIELD_VALUE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DLR_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `e_log_technical_error`
--

DROP TABLE IF EXISTS `e_log_technical_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_log_technical_error` (
  `DLF_ID` varchar(145) DEFAULT NULL,
  `DLF_DATE` date NOT NULL,
  `DLF_ETL_NAME` varchar(255) NOT NULL,
  PRIMARY KEY (`DLF_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_contract_ttr_minute`
--

DROP TABLE IF EXISTS `f_dtm_appli_contract_ttr_minute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_contract_ttr_minute` (
  `acmttr_id` int(11) NOT NULL DEFAULT '0',
  `acmttr_epoch_minute` int(11) DEFAULT NULL,
  `acmttr_date` date DEFAULT NULL,
  `acmttr_minute` int(11) DEFAULT NULL,
  `acmttr_source` varchar(15) DEFAULT NULL,
  `acmttr_application` int(11) DEFAULT NULL,
  `acmttr_category` int(11) DEFAULT NULL,
  `acmttr_contract_context_id` int(11) DEFAULT NULL,
  `acmttr_kpi_id` int(11) DEFAULT NULL,
  `acmttr_contract_id` int(11) DEFAULT NULL,
  `acmttr_time_period_id` int(11) DEFAULT NULL,
  `acmttr_unavailability` tinyint(3) unsigned DEFAULT NULL,
  `acmttr_unavailability_down` tinyint(3) unsigned DEFAULT NULL,
  `acmttr_downtimeDuration` tinyint(3) unsigned DEFAULT NULL,
  `acmttr_downtimeEffectiveDuration` tinyint(3) unsigned DEFAULT NULL,
  `acmttr_chg_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_ana_contract_unavail_day`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_ana_contract_unavail_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_ana_contract_unavail_day` (
  `aad_id` int(11) NOT NULL AUTO_INCREMENT,
  `aad_epoch_day` int(11) DEFAULT NULL,
  `aad_date` date DEFAULT NULL,
  `aad_source` varchar(15) DEFAULT NULL,
  `aad_appli_master` int(11) DEFAULT NULL,
  `aad_appli_link` int(11) DEFAULT NULL,
  `aad_category` varchar(45) DEFAULT NULL,
  `aad_contract_context_id` int(11) DEFAULT NULL,
  `aad_kpi_id` int(11) DEFAULT NULL,
  `aad_contract_id` int(11) DEFAULT NULL,
  `aad_time_period_id` int(11) DEFAULT NULL,
  `aad_unavailability` mediumint(8) unsigned DEFAULT NULL,
  `aad_unavailability_down` mediumint(8) unsigned DEFAULT NULL,
  `aad_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1887 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_ana_contract_unavail_hour`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_ana_contract_unavail_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_ana_contract_unavail_hour` (
  `aah_id` int(11) NOT NULL AUTO_INCREMENT,
  `aah_epoch_hour` int(11) DEFAULT NULL,
  `aah_date` date DEFAULT NULL,
  `aah_hour` varchar(5) DEFAULT NULL,
  `aah_source` varchar(15) DEFAULT NULL,
  `aah_appli_master` int(11) DEFAULT NULL,
  `aah_appli_link` int(11) DEFAULT NULL,
  `aah_category` varchar(45) DEFAULT NULL,
  `aah_contract_context_id` int(11) DEFAULT NULL,
  `aah_kpi_id` int(11) DEFAULT NULL,
  `aah_contract_id` int(11) DEFAULT NULL,
  `aah_time_period_id` int(11) DEFAULT NULL,
  `aah_unavailability` mediumint(8) unsigned DEFAULT NULL,
  `aah_unavailability_down` mediumint(8) unsigned DEFAULT NULL,
  `aah_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aah_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5050 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_ana_contract_unavail_min`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_ana_contract_unavail_min`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_ana_contract_unavail_min` (
  `aam_id` int(11) NOT NULL AUTO_INCREMENT,
  `aam_epoch_minute` int(11) DEFAULT NULL,
  `aam_date` date DEFAULT NULL,
  `aam_minute` int(11) DEFAULT NULL,
  `aam_source` varchar(15) DEFAULT NULL,
  `aam_appli_master` int(11) DEFAULT NULL,
  `aam_appli_link` int(11) DEFAULT NULL,
  `aam_category` varchar(45) DEFAULT NULL,
  `aam_contract_context_id` int(11) DEFAULT NULL,
  `aam_kpi_id` int(11) DEFAULT NULL,
  `aam_contract_id` int(11) DEFAULT NULL,
  `aam_time_period_id` int(11) DEFAULT NULL,
  `aam_unavailability` tinyint(3) unsigned DEFAULT NULL,
  `aam_unavailability_down` tinyint(3) unsigned DEFAULT NULL,
  `aam_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aam_id`)
) ENGINE=InnoDB AUTO_INCREMENT=194817 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_ana_contract_unavail_month`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_ana_contract_unavail_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_ana_contract_unavail_month` (
  `aam_id` int(11) NOT NULL AUTO_INCREMENT,
  `aam_epoch_month` int(11) DEFAULT NULL,
  `aam_year` int(11) DEFAULT NULL,
  `aam_month` varchar(2) DEFAULT NULL,
  `aam_source` varchar(15) DEFAULT NULL,
  `aam_appli_master` int(11) DEFAULT NULL,
  `aam_appli_link` int(11) DEFAULT NULL,
  `aam_category` varchar(45) DEFAULT NULL,
  `aam_contract_context_id` int(11) DEFAULT NULL,
  `aam_kpi_id` int(11) DEFAULT NULL,
  `aam_contract_id` int(11) DEFAULT NULL,
  `aam_time_period_id` int(11) DEFAULT NULL,
  `aam_unavailability` int(10) unsigned DEFAULT NULL,
  `aam_unavailability_down` int(10) unsigned DEFAULT NULL,
  `aam_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aam_id`)
) ENGINE=InnoDB AUTO_INCREMENT=497 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_contract_unavail_day`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_contract_unavail_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_contract_unavail_day` (
  `ald_id` int(11) NOT NULL AUTO_INCREMENT,
  `ald_epoch_day` int(11) DEFAULT NULL,
  `ald_date` date DEFAULT NULL,
  `ald_source` varchar(15) DEFAULT NULL,
  `ald_appli_master` int(11) DEFAULT NULL,
  `ald_appli_link` int(11) DEFAULT NULL,
  `ald_category` int(11) DEFAULT NULL,
  `ald_contract_context_id` int(11) DEFAULT NULL,
  `ald_kpi_id` int(11) DEFAULT NULL,
  `ald_contract_id` int(11) DEFAULT NULL,
  `ald_time_period_id` int(11) DEFAULT NULL,
  `ald_unavailability` mediumint(8) unsigned DEFAULT NULL,
  `ald_unavailability_down` mediumint(8) unsigned DEFAULT NULL,
  `ald_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`ald_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2578 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_contract_unavail_hour`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_contract_unavail_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_contract_unavail_hour` (
  `alh_id` int(11) NOT NULL AUTO_INCREMENT,
  `alh_epoch_hour` int(11) DEFAULT NULL,
  `alh_date` date DEFAULT NULL,
  `alh_hour` varchar(5) DEFAULT NULL,
  `alh_source` varchar(15) DEFAULT NULL,
  `alh_appli_master` int(11) DEFAULT NULL,
  `alh_appli_link` int(11) DEFAULT NULL,
  `alh_category` int(11) DEFAULT NULL,
  `alh_contract_context_id` int(11) DEFAULT NULL,
  `alh_kpi_id` int(11) DEFAULT NULL,
  `alh_contract_id` int(11) DEFAULT NULL,
  `alh_time_period_id` int(11) DEFAULT NULL,
  `alh_unavailability` mediumint(8) unsigned DEFAULT NULL,
  `alh_unavailability_down` mediumint(8) unsigned DEFAULT NULL,
  `alh_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`alh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6846 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_contract_unavail_min`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_contract_unavail_min`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_contract_unavail_min` (
  `alm_id` int(11) NOT NULL AUTO_INCREMENT,
  `alm_epoch_minute` int(11) DEFAULT NULL,
  `alm_date` date DEFAULT NULL,
  `alm_minute` int(11) DEFAULT NULL,
  `alm_source` varchar(15) DEFAULT NULL,
  `alm_appli_master` int(11) DEFAULT NULL,
  `alm_appli_link` int(11) DEFAULT NULL,
  `alm_category` int(11) DEFAULT NULL,
  `alm_contract_context_id` int(11) DEFAULT NULL,
  `alm_kpi_id` int(11) DEFAULT NULL,
  `alm_contract_id` int(11) DEFAULT NULL,
  `alm_time_period_id` int(11) DEFAULT NULL,
  `alm_unavailability` tinyint(3) unsigned DEFAULT NULL,
  `alm_unavailability_down` tinyint(3) unsigned DEFAULT NULL,
  `alm_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`alm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=263184 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_link_contract_unavail_month`
--

DROP TABLE IF EXISTS `f_dtm_appli_link_contract_unavail_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_link_contract_unavail_month` (
  `alm_id` int(11) NOT NULL AUTO_INCREMENT,
  `alm_epoch_month` int(11) DEFAULT NULL,
  `alm_year` int(11) DEFAULT NULL,
  `alm_month` varchar(2) DEFAULT NULL,
  `alm_source` varchar(15) DEFAULT NULL,
  `alm_appli_master` int(11) DEFAULT NULL,
  `alm_appli_link` int(11) DEFAULT NULL,
  `alm_category` int(11) DEFAULT NULL,
  `alm_contract_context_id` int(11) DEFAULT NULL,
  `alm_kpi_id` int(11) DEFAULT NULL,
  `alm_contract_id` int(11) DEFAULT NULL,
  `alm_time_period_id` int(11) DEFAULT NULL,
  `alm_unavailability` mediumint(8) unsigned DEFAULT NULL,
  `alm_unavailability_down` mediumint(8) unsigned DEFAULT NULL,
  `alm_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`alm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=649 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_unavailability_day`
--

DROP TABLE IF EXISTS `f_dtm_appli_unavailability_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_unavailability_day` (
  `aud_id` int(11) NOT NULL AUTO_INCREMENT,
  `aud_epoch_day` int(11) DEFAULT NULL,
  `aud_date` date DEFAULT NULL,
  `aud_contract_context_id` int(11) DEFAULT NULL,
  `aud_kpi_id` int(11) DEFAULT NULL,
  `aud_time_period_id` int(11) DEFAULT NULL,
  `aud_contract_id` int(11) DEFAULT NULL,
  `aud_source` varchar(15) DEFAULT NULL,
  `aud_appli` int(11) DEFAULT NULL,
  `aud_category` mediumint(9) DEFAULT NULL,
  `aud_unavailability` mediumint(9) DEFAULT NULL,
  `aud_unavailability_down` mediumint(9) DEFAULT NULL,
  `aud_downtime_duration` int(11) DEFAULT NULL,
  `aud_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aud_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2375 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_unavailability_hour`
--

DROP TABLE IF EXISTS `f_dtm_appli_unavailability_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_unavailability_hour` (
  `auh_id` int(11) NOT NULL AUTO_INCREMENT,
  `auh_epoch_hour` int(11) DEFAULT NULL,
  `auh_date` date DEFAULT NULL,
  `auh_hour` varchar(5) DEFAULT NULL,
  `auh_source` varchar(15) DEFAULT NULL,
  `auh_appli` int(11) DEFAULT NULL,
  `auh_category` int(11) DEFAULT NULL,
  `auh_contract_context_id` int(11) DEFAULT NULL,
  `auh_kpi_id` int(11) DEFAULT NULL,
  `auh_time_period_id` int(11) DEFAULT NULL,
  `auh_contract_id` int(11) DEFAULT NULL,
  `auh_unavailability` mediumint(9) DEFAULT NULL,
  `auh_unavailability_down` mediumint(9) DEFAULT NULL,
  `auh_downtime_duration` int(11) DEFAULT NULL,
  `auh_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`auh_id`),
  KEY `idx_appli_hour` (`auh_appli`) USING BTREE,
  KEY `idx_appli_epoch_hour` (`auh_epoch_hour`) USING BTREE,
  KEY `idx_appli_contract_context_hour` (`auh_contract_context_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=6442 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_unavailability_month`
--

DROP TABLE IF EXISTS `f_dtm_appli_unavailability_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_unavailability_month` (
  `aum_id` int(11) NOT NULL AUTO_INCREMENT,
  `aum_epoch_month` int(11) DEFAULT NULL,
  `aum_year` mediumint(9) DEFAULT NULL,
  `aum_month` varchar(2) DEFAULT NULL,
  `aum_source` varchar(15) DEFAULT NULL,
  `aum_appli` int(11) DEFAULT NULL,
  `aum_contract_context_id` int(11) DEFAULT NULL,
  `aum_kpi_id` int(11) DEFAULT NULL,
  `aum_time_period_id` int(11) DEFAULT NULL,
  `aum_contract_id` int(11) DEFAULT NULL,
  `aum_category` mediumint(9) DEFAULT NULL,
  `aum_unavailability` mediumint(9) DEFAULT NULL,
  `aum_unavailability_down` mediumint(9) DEFAULT NULL,
  `aum_downtime_duration` int(11) DEFAULT NULL,
  `aum_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aum_id`)
) ENGINE=InnoDB AUTO_INCREMENT=634 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_appli_unavailability_month_hour`
--

DROP TABLE IF EXISTS `f_dtm_appli_unavailability_month_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_appli_unavailability_month_hour` (
  `aumh_id` int(11) NOT NULL AUTO_INCREMENT,
  `aumh_epoch_month_hour` int(11) DEFAULT NULL,
  `aumh_year` mediumint(9) DEFAULT NULL,
  `aumh_month` varchar(2) DEFAULT NULL,
  `aumh_hour` varchar(5) DEFAULT NULL,
  `aumh_source` varchar(15) DEFAULT NULL,
  `aumh_appli` int(11) DEFAULT NULL,
  `aumh_contract_context_id` int(11) DEFAULT NULL,
  `aumh_kpi_id` int(11) DEFAULT NULL,
  `aumh_time_period_id` int(11) DEFAULT NULL,
  `aumh_contract_id` int(11) DEFAULT NULL,
  `aumh_category` mediumint(9) DEFAULT NULL,
  `aumh_unavailability` mediumint(9) DEFAULT NULL,
  `aumh_unavailability_down` mediumint(9) DEFAULT NULL,
  `aumh_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aumh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4161 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_application_contract_unavailability_minute`
--

DROP TABLE IF EXISTS `f_dtm_application_contract_unavailability_minute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_application_contract_unavailability_minute` (
  `acm_id` int(11) NOT NULL AUTO_INCREMENT,
  `acm_epoch_minute` int(11) DEFAULT NULL,
  `acm_date` date DEFAULT NULL,
  `acm_minute` int(11) DEFAULT NULL,
  `acm_source` varchar(15) DEFAULT NULL,
  `acm_application` int(11) DEFAULT NULL,
  `acm_category` int(11) DEFAULT NULL,
  `acm_contract_context_id` int(11) DEFAULT NULL,
  `acm_kpi_id` int(11) DEFAULT NULL,
  `acm_contract_id` int(11) DEFAULT NULL,
  `acm_time_period_id` int(11) DEFAULT NULL,
  `acm_unavailability` tinyint(3) unsigned DEFAULT NULL,
  `acm_unavailability_down` tinyint(3) unsigned DEFAULT NULL,
  `acm_downtimeDuration` tinyint(3) unsigned DEFAULT NULL,
  `acm_downtimeEffectiveDuration` tinyint(3) unsigned DEFAULT NULL,
  `acm_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`acm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=242903 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_application_unavailability_minute`
--

DROP TABLE IF EXISTS `f_dtm_application_unavailability_minute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_application_unavailability_minute` (
  `fdb_id` int(11) NOT NULL AUTO_INCREMENT,
  `fdb_epoch_minute` int(11) DEFAULT NULL,
  `fdb_date` date DEFAULT NULL,
  `fdb_minute` int(11) DEFAULT NULL,
  `fdb_source` varchar(15) DEFAULT NULL,
  `fdb_application` int(11) DEFAULT NULL,
  `fdb_category` int(11) DEFAULT NULL,
  `fdb_category_analysis` int(11) DEFAULT NULL,
  `fdb_unavailability` tinyint(3) unsigned DEFAULT NULL,
  `fdb_unavailability_down` tinyint(3) unsigned DEFAULT NULL,
  `fdb_downtimeDuration` tinyint(3) unsigned DEFAULT NULL,
  `fdb_downtimeEffectiveDuration` tinyint(3) unsigned DEFAULT NULL,
  `fdb_isOutage` tinyint(3) DEFAULT NULL,
  `fdb_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`fdb_id`)
) ENGINE=MyISAM AUTO_INCREMENT=142336 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_hoststatus_unavailability_minute`
--

DROP TABLE IF EXISTS `f_dtm_hs_hoststatus_unavailability_minute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_hoststatus_unavailability_minute` (
  `hhm_id` int(11) NOT NULL AUTO_INCREMENT,
  `hhm_epoch_minute` int(11) DEFAULT NULL,
  `hhm_date` date NOT NULL,
  `hhm_minute` int(11) NOT NULL,
  `hhm_source` varchar(15) NOT NULL,
  `hhm_host` int(11) NOT NULL,
  `hhm_service` int(11) NOT NULL,
  `hhm_unavailability` tinyint(3) unsigned NOT NULL,
  `hhm_unavailabilityDown` tinyint(3) unsigned NOT NULL,
  `hhm_downtimeDuration` tinyint(3) unsigned NOT NULL,
  `hhm_downtimeEffectiveDuration` tinyint(3) unsigned NOT NULL,
  `hhm_isDowntime` bit(1) NOT NULL,
  `hhm_chg_id` int(11) NOT NULL,
  `hhm_isOutage` tinyint(3) DEFAULT NULL,
  `hhm_isHoststatusOutage` tinyint(3) DEFAULT NULL,
  PRIMARY KEY (`hhm_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_ttr_interval`
--

DROP TABLE IF EXISTS `f_dtm_hs_ttr_interval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_ttr_interval` (
  `hsittr_id` int(11) NOT NULL AUTO_INCREMENT,
  `hsittr_epoch_begin` int(11) DEFAULT NULL,
  `hsittr_epoch_end` int(11) DEFAULT NULL,
  `hsittr_host` int(11) DEFAULT NULL,
  `hsittr_service` int(11) DEFAULT NULL,
  `hsittr_source` varchar(15) DEFAULT NULL,
  `hsittr_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`hsittr_id`),
  KEY `idx_hs_ttr_hostservice` (`hsittr_host`,`hsittr_service`) USING BTREE,
  KEY `idx_hs_ttr_host` (`hsittr_host`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2714 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_unavailability_day`
--

DROP TABLE IF EXISTS `f_dtm_hs_unavailability_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_unavailability_day` (
  `hud_id` int(11) NOT NULL AUTO_INCREMENT,
  `hud_epoch_day` int(11) DEFAULT NULL,
  `hud_date` date DEFAULT NULL,
  `hud_source` varchar(15) DEFAULT NULL,
  `hud_host` int(11) DEFAULT NULL,
  `hud_service` int(11) DEFAULT NULL,
  `hud_isHoststatusOutage` tinyint(4) DEFAULT NULL,
  `hud_unavailability` mediumint(9) DEFAULT NULL,
  `hud_unavailability_down` mediumint(9) DEFAULT NULL,
  `hud_downtime_duration` int(11) DEFAULT NULL,
  `hud_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`hud_id`)
) ENGINE=MyISAM AUTO_INCREMENT=34549 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_unavailability_hour`
--

DROP TABLE IF EXISTS `f_dtm_hs_unavailability_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_unavailability_hour` (
  `huh_id` int(11) NOT NULL AUTO_INCREMENT,
  `huh_epoch_hour` int(11) DEFAULT NULL,
  `huh_date` date DEFAULT NULL,
  `huh_hour` varchar(5) DEFAULT NULL,
  `huh_source` varchar(15) DEFAULT NULL,
  `huh_host` int(11) DEFAULT NULL,
  `huh_service` int(11) DEFAULT NULL,
  `huh_unavailability` mediumint(9) DEFAULT NULL,
  `huh_unavailability_down` mediumint(9) DEFAULT NULL,
  `huh_downtime_duration` int(11) DEFAULT NULL,
  `huh_chg_id` int(11) DEFAULT NULL,
  `huh_isHoststatusOutage` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`huh_id`)
) ENGINE=MyISAM AUTO_INCREMENT=461298 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_unavailability_minute`
--

DROP TABLE IF EXISTS `f_dtm_hs_unavailability_minute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_unavailability_minute` (
  `fdu_id` int(11) NOT NULL AUTO_INCREMENT,
  `fdu_epoch_minute` int(11) DEFAULT NULL,
  `fdu_date` date NOT NULL,
  `fdu_minute` int(11) NOT NULL,
  `fdu_source` varchar(15) NOT NULL,
  `fdu_host` int(11) NOT NULL,
  `fdu_service` int(11) NOT NULL,
  `fdu_unavailability` tinyint(3) unsigned NOT NULL,
  `fdu_unavailabilityDown` tinyint(3) unsigned NOT NULL,
  `fdu_downtimeDuration` tinyint(3) unsigned NOT NULL,
  `fdu_downtimeEffectiveDuration` tinyint(3) unsigned NOT NULL,
  `fdu_isDowntime` bit(1) NOT NULL,
  `fdu_chg_id` int(11) NOT NULL,
  `fdu_isOutage` tinyint(3) DEFAULT NULL,
  `fdu_isHoststatusOutage` tinyint(3) DEFAULT NULL,
  `fdu_OutageInternEventNum` int(11) DEFAULT NULL,
  `fdu_DowntimeInternEventNum` int(11) DEFAULT NULL,
  `fdu_lastHSDowntimeBit` tinyint(4) DEFAULT NULL,
  `fdu_lastHSOutageBit` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`fdu_id`),
  KEY `idx_fdu_date` (`fdu_date`) USING BTREE,
  KEY `idx_fdu_host` (`fdu_host`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=3964211 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_unavailability_month`
--

DROP TABLE IF EXISTS `f_dtm_hs_unavailability_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_unavailability_month` (
  `hum_id` int(11) NOT NULL AUTO_INCREMENT,
  `hum_epoch_month` int(11) DEFAULT NULL,
  `hum_month` int(11) DEFAULT NULL,
  `hum_year` mediumint(9) DEFAULT NULL,
  `hum_source` varchar(15) DEFAULT NULL,
  `hum_host` int(11) DEFAULT NULL,
  `hum_service` int(11) DEFAULT NULL,
  `hum_isHoststatusOutage` tinyint(4) DEFAULT NULL,
  `hum_unavailability` mediumint(9) unsigned DEFAULT NULL,
  `hum_unavailability_down` mediumint(9) unsigned DEFAULT NULL,
  `hum_downtime_duration` int(11) DEFAULT NULL,
  `hum_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`hum_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1941 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dtm_hs_unavailability_month_hour`
--

DROP TABLE IF EXISTS `f_dtm_hs_unavailability_month_hour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dtm_hs_unavailability_month_hour` (
  `humh_id` int(11) NOT NULL AUTO_INCREMENT,
  `humh_epoch_month_hour` int(11) DEFAULT NULL,
  `humh_year` mediumint(9) DEFAULT NULL,
  `hum_month` varchar(2) DEFAULT NULL,
  `humh_hour` varchar(5) DEFAULT NULL,
  `humh_source` varchar(15) DEFAULT NULL,
  `humh_host` int(11) DEFAULT NULL,
  `humh_service` int(11) DEFAULT NULL,
  `humh_isHoststatusOutage` tinyint(4) DEFAULT NULL,
  `humh_unavailability` decimal(10,0) DEFAULT NULL,
  `humh_unavailability_down` decimal(10,0) DEFAULT NULL,
  `humh_chg_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`humh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28576 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dwh_logs_nagios`
--

DROP TABLE IF EXISTS `f_dwh_logs_nagios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dwh_logs_nagios` (
  `FLN_ID` int(11) NOT NULL AUTO_INCREMENT,
  `FLN_SOURCE` varchar(15) DEFAULT NULL,
  `FLN_CHARGEMENT` int(11) DEFAULT NULL,
  `FLN_UNIX_TIME` int(11) DEFAULT NULL,
  `FLN_HOST` int(11) DEFAULT NULL,
  `FLN_SERVICE` int(11) DEFAULT NULL,
  `FLN_DATE` date DEFAULT NULL,
  `FLN_TIME` time DEFAULT NULL,
  `FLN_CODE_INTERVAL` int(11) DEFAULT NULL,
  `FLN_STATE` tinyint(4) DEFAULT NULL,
  `FLN_STATE_UNIF` tinyint(4) DEFAULT NULL,
  `FLN_MESSAGE_TYPE` int(11) DEFAULT NULL,
  PRIMARY KEY (`FLN_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=307741 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_dwh_logs_nagios_downtime`
--

DROP TABLE IF EXISTS `f_dwh_logs_nagios_downtime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_dwh_logs_nagios_downtime` (
  `FDO_ID` int(11) NOT NULL DEFAULT '0',
  `FDO_SOURCE` varchar(15) DEFAULT NULL,
  `FDO_CHARGEMENT` int(11) DEFAULT NULL,
  `FDO_UNIX_TIME` int(11) DEFAULT NULL,
  `FDO_DATETIME` datetime DEFAULT NULL,
  `FDO_DATE` date DEFAULT NULL,
  `FDO_HOST_ID` int(11) DEFAULT NULL,
  `FDO_SERVICE_ID` int(11) DEFAULT NULL,
  `FDO_STATE` int(11) DEFAULT NULL,
  `FDO_MESSAGE_TYPE` varchar(45) DEFAULT NULL,
  `FDO_CODE_INTERVAL` int(11) DEFAULT NULL,
  KEY `fdo_date_index` (`FDO_DATE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_tmp_incident_not_finished`
--

DROP TABLE IF EXISTS `f_tmp_incident_not_finished`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_tmp_incident_not_finished` (
  `hsittr_id` int(11) NOT NULL DEFAULT '0',
  `hsittr_epoch_begin` int(11) DEFAULT NULL,
  `hsittr_epoch_end` int(11) DEFAULT NULL,
  `hsittr_host` int(11) DEFAULT NULL,
  `hsittr_service` int(11) DEFAULT NULL,
  `hsittr_source` varchar(15) DEFAULT NULL,
  `hsittr_chg_id` int(11) DEFAULT NULL,
  `dhs_id` int(11) NOT NULL DEFAULT '0'
) ENGINE=MEMORY DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_tmp_log_day`
--

DROP TABLE IF EXISTS `f_tmp_log_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_tmp_log_day` (
  `FLN_ID` int(11) NOT NULL DEFAULT '0',
  `FLN_SOURCE` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `FLN_CHARGEMENT` int(11) DEFAULT NULL,
  `FLN_UNIX_TIME` int(11) DEFAULT NULL,
  `FLN_HOST` int(11) DEFAULT NULL,
  `FLN_SERVICE` int(11) DEFAULT NULL,
  `FLN_DATE` date DEFAULT NULL,
  `FLN_TIME` time DEFAULT NULL,
  `FLN_CODE_INTERVAL` int(11) DEFAULT NULL,
  `FLN_STATE` tinyint(4) DEFAULT NULL,
  `FLN_STATE_UNIF` tinyint(4) DEFAULT NULL,
  `FLN_MESSAGE_TYPE` int(11) DEFAULT NULL,
  KEY `fln_host_index` (`FLN_HOST`) USING BTREE,
  KEY `fln_service_index` (`FLN_SERVICE`) USING BTREE
) ENGINE=MEMORY DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_tmp_log_down_hs_day`
--

DROP TABLE IF EXISTS `f_tmp_log_down_hs_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_tmp_log_down_hs_day` (
  `FDO_ID` int(11) NOT NULL DEFAULT '0',
  `FDO_SOURCE` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `FDO_CHARGEMENT` int(11) DEFAULT NULL,
  `FDO_UNIX_TIME` int(11) DEFAULT NULL,
  `FDO_DATETIME` datetime DEFAULT NULL,
  `FDO_DATE` date DEFAULT NULL,
  `FDO_HOST_ID` int(11) DEFAULT NULL,
  `FDO_SERVICE_ID` int(11) DEFAULT NULL,
  `FDO_STATE` int(11) DEFAULT NULL,
  `FDO_MESSAGE_TYPE` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `FDO_CODE_INTERVAL` int(11) DEFAULT NULL,
  `FDO_SERVICE_NAME` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `FDO_MESSAGE_TYPE_LABEL` varchar(145) CHARACTER SET utf8 NOT NULL,
  `FDO_HOUR` varchar(7) DEFAULT NULL,
  `FDO_HMINUTE` varchar(2) DEFAULT NULL,
  `FDO_DATE_MINUTE` bigint(17) DEFAULT NULL,
  `FDO_SECONDE` varchar(2) DEFAULT NULL,
  KEY `idx_tmp_fln_date` (`FDO_DATE`,`FDO_HOUR`,`FDO_HMINUTE`) USING BTREE
) ENGINE=MEMORY DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_tmp_log_downtime_day`
--

DROP TABLE IF EXISTS `f_tmp_log_downtime_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_tmp_log_downtime_day` (
  `FDO_ID` int(11) NOT NULL DEFAULT '0',
  `FDO_SOURCE` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `FDO_CHARGEMENT` int(11) DEFAULT NULL,
  `FDO_UNIX_TIME` int(11) DEFAULT NULL,
  `FDO_DATETIME` datetime DEFAULT NULL,
  `FDO_DATE` date DEFAULT NULL,
  `FDO_HOST_ID` int(11) DEFAULT NULL,
  `FDO_SERVICE_ID` int(11) DEFAULT NULL,
  `FDO_STATE` int(11) DEFAULT NULL,
  `FDO_MESSAGE_TYPE` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `FDO_CODE_INTERVAL` int(11) DEFAULT NULL,
  `FDO_SERVICE_NAME` varchar(150) CHARACTER SET utf8 DEFAULT NULL,
  `FDO_MESSAGE_TYPE_LABEL` varchar(145) CHARACTER SET utf8 NOT NULL,
  `FDO_HOUR` varchar(7) DEFAULT NULL,
  `FDO_HMINUTE` varchar(2) DEFAULT NULL,
  `FDO_DATE_MINUTE` bigint(17) DEFAULT NULL,
  `FDO_SECONDE` varchar(2) DEFAULT NULL,
  KEY `fdo_host_index` (`FDO_HOST_ID`) USING BTREE,
  KEY `fdo_service_index` (`FDO_SERVICE_ID`) USING BTREE
) ENGINE=MEMORY DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `f_tmp_unavailability_day`
--

DROP TABLE IF EXISTS `f_tmp_unavailability_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `f_tmp_unavailability_day` (
  `FDU_HOST` int(11) NOT NULL,
  `FDU_SERVICE` int(11) NOT NULL,
  `FDU_ISDOWNTIME` bit(1) NOT NULL,
  `FDU_ISOUTAGE` tinyint(3) DEFAULT NULL,
  `FDU_EPOCH_MINUTE` int(11) DEFAULT NULL,
  `FDU_ISHOSTSTATUSOUTAGE` tinyint(3) DEFAULT NULL,
  `fdu_OutageInternEventNum` int(11) DEFAULT NULL,
  `fdu_DowntimeInternEventNum` int(11) DEFAULT NULL,
  `fdu_lastHSDowntimeBit` tinyint(4) DEFAULT NULL,
  `fdu_lastHSOutageBit` tinyint(4) DEFAULT NULL,
  `FDU_SERVICE_NAME` varchar(150) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `test_application_link`
--

DROP TABLE IF EXISTS `test_application_link`;
/*!50001 DROP VIEW IF EXISTS `test_application_link`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `test_application_link` (
  `application_name` tinyint NOT NULL,
  `link` tinyint NOT NULL,
  `type` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `test_application_link`
--

/*!50001 DROP TABLE IF EXISTS `test_application_link`*/;
/*!50001 DROP VIEW IF EXISTS `test_application_link`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`eyesofreport`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `test_application_link` AS (select `dap_master`.`DAP_NAME` AS `application_name`,`dap_link`.`DAP_NAME` AS `link`,'appli' AS `type` from ((`d_application_link` join `d_application` `dap_master` on((`dap_master`.`DAP_ID` = `d_application_link`.`dal_app_master_id`))) join `d_application` `dap_link` on((`dap_link`.`DAP_ID` = `d_application_link`.`dal_app_link_id`)))) union (select `d_application`.`DAP_NAME` AS `application_name`,`d_host`.`DHO_NAME` AS `link`,'host' AS `type` from ((`d_host_service_application` join `d_host` on((`d_host`.`DHO_ID` = `d_host_service_application`.`hsa_host`))) join `d_application` on((`d_application`.`DAP_ID` = `d_host_service_application`.`hsa_appli`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-27 11:07:13
