-- MySQL dump 10.14  Distrib 5.5.44-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: generic_ged
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
-- Table structure for table `nagios`
--

DROP TABLE IF EXISTS `nagios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios`
--

LOCK TABLES `nagios` WRITE;
/*!40000 ALTER TABLE `nagios` DISABLE KEYS */;
/*!40000 ALTER TABLE `nagios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nagios_queue_active`
--

DROP TABLE IF EXISTS `nagios_queue_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_queue_active` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- Table structure for table `nagios_queue_history`
--

DROP TABLE IF EXISTS `nagios_queue_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_queue_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nagios_queue_sync`
--

DROP TABLE IF EXISTS `nagios_queue_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nagios_queue_sync` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nagios_queue_sync`
--

--LOCK TABLES `nagios_queue_sync` WRITE;
--/*!40000 ALTER TABLE `nagios_queue_sync` DISABLE KEYS */;
--/*!40000 ALTER TABLE `nagios_queue_sync` ENABLE KEYS */;
--UNLOCK TABLES;

--
-- Table structure for table `pkt_type`
--

DROP TABLE IF EXISTS `pkt_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pkt_type` (
  `pkt_type_id` int(11) NOT NULL DEFAULT '0',
  `pkt_type_name` varchar(128) NOT NULL DEFAULT '',
  `pkt_type_hash` varchar(128) NOT NULL DEFAULT '',
  `pkt_type_vers` int(11) NOT NULL DEFAULT '10504',
  PRIMARY KEY (`pkt_type_id`),
  UNIQUE KEY `pkt_type_name` (`pkt_type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pkt_type`
--

LOCK TABLES `pkt_type` WRITE;
/*!40000 ALTER TABLE `pkt_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `pkt_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmptrap`
--

DROP TABLE IF EXISTS `snmptrap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snmptrap` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmptrap`
--

LOCK TABLES `snmptrap` WRITE;
/*!40000 ALTER TABLE `snmptrap` DISABLE KEYS */;
/*!40000 ALTER TABLE `snmptrap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmptrap_queue_active`
--

DROP TABLE IF EXISTS `snmptrap_queue_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snmptrap_queue_active` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmptrap_queue_active`
--

LOCK TABLES `snmptrap_queue_active` WRITE;
/*!40000 ALTER TABLE `snmptrap_queue_active` DISABLE KEYS */;
/*!40000 ALTER TABLE `snmptrap_queue_active` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmptrap_queue_history`
--

DROP TABLE IF EXISTS `snmptrap_queue_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snmptrap_queue_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmptrap_queue_history`
--

LOCK TABLES `snmptrap_queue_history` WRITE;
/*!40000 ALTER TABLE `snmptrap_queue_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `snmptrap_queue_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `snmptrap_queue_sync`
--

DROP TABLE IF EXISTS `snmptrap_queue_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `snmptrap_queue_sync` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `queue` enum('a','h','s') NOT NULL DEFAULT 'a',
  `occ` int(10) unsigned NOT NULL DEFAULT '1',
  `o_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `o_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `l_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `r_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `m_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `f_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_sec` int(10) unsigned NOT NULL DEFAULT '0',
  `a_usec` int(10) unsigned NOT NULL DEFAULT '0',
  `reason` enum('na','pkt','ttl') NOT NULL DEFAULT 'na',
  `src` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `tgt` varchar(255) NOT NULL DEFAULT 'na',
  `req` enum('na','push','update','drop_by_data','drop_by_id') NOT NULL DEFAULT 'na',
  `equipment` varchar(2048) NOT NULL DEFAULT '',
  `service` varchar(2048) NOT NULL DEFAULT '',
  `state` int(11) NOT NULL DEFAULT '0',
  `owner` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(2048) NOT NULL DEFAULT '',
  `ip_address` varchar(2048) NOT NULL DEFAULT '',
  `host_alias` varchar(2048) NOT NULL DEFAULT '',
  `hostgroups` varchar(2048) NOT NULL DEFAULT '',
  `servicegroups` varchar(2048) NOT NULL DEFAULT '',
  `comments` varchar(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `equipment` (`equipment`(767)) USING BTREE,
  KEY `service` (`service`(767)) USING BTREE,
  KEY `state` (`state`) USING BTREE,
  KEY `o_sec` (`o_sec`) USING BTREE,
  KEY `o_usec` (`o_usec`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `snmptrap_queue_sync`
--

LOCK TABLES `snmptrap_queue_sync` WRITE;
/*!40000 ALTER TABLE `snmptrap_queue_sync` DISABLE KEYS */;
/*!40000 ALTER TABLE `snmptrap_queue_sync` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-03-16 15:49:24
