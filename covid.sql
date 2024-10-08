-- MariaDB dump 10.19  Distrib 10.4.24-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: covid
-- ------------------------------------------------------
-- Server version	10.4.24-MariaDB

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
-- Table structure for table `answers`
--

CREATE DATABASE covid;
USE covid;


DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pat_id` int(11) NOT NULL,
  `A1` int(1) DEFAULT NULL,
  `A2` int(1) DEFAULT NULL,
  `A3` int(1) DEFAULT NULL,
  `A4` int(1) DEFAULT NULL,
  `A5` int(1) DEFAULT NULL,
  `A6` int(1) DEFAULT NULL,
  `A7` int(1) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
INSERT INTO `answers` VALUES (1,2,1,0,1,0,1,0,0,'2022-05-01 12:04:17'),(2,7,0,1,1,1,0,-1,0,'2022-05-01 12:05:15'),(3,9,1,0,0,0,1,0,0,'2022-05-01 17:50:36');
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `doctors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `surname` varchar(40) NOT NULL,
  `specialty` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `specialty` (`specialty`),
  CONSTRAINT `connect_doctor_uid_with_user_id` FOREIGN KEY (`uid`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `connect_doctors_id_with_vitals_doc_id` FOREIGN KEY (`id`) REFERENCES `vitals` (`doc_id`) ON UPDATE CASCADE,
  CONSTRAINT `connect_doctors_specialty_with_specialties_id` FOREIGN KEY (`specialty`) REFERENCES `medical_specialties` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (1,'Doctor','Who',3,3),(2,'Al','Debaran',7,6),(3,'Elbereth','Gray',11,8);
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_specialties`
--

DROP TABLE IF EXISTS `medical_specialties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medical_specialties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `specialty` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `specialty` (`specialty`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_specialties`
--

LOCK TABLES `medical_specialties` WRITE;
/*!40000 ALTER TABLE `medical_specialties` DISABLE KEYS */;
INSERT INTO `medical_specialties` VALUES (11,'Anaesthesiology '),(6,'Cardiology'),(3,'Dermatology'),(2,'Gastroenterology'),(12,'Gynecology'),(15,'Hematology'),(10,'Intensive Care'),(5,'Nephrology'),(8,'Neurology'),(14,'Oncology'),(1,'Otolaryngology'),(13,'Paediatrics'),(4,'Pathology'),(7,'Pneumonology'),(9,'Surgery');
/*!40000 ALTER TABLE `medical_specialties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `patients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `surname` varchar(40) NOT NULL,
  `sex` int(1) NOT NULL,
  `amka` varchar(11) NOT NULL,
  `contact` varchar(11) NOT NULL,
  `date_of_birth` date NOT NULL,
  `weight` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `bmi` int(11) NOT NULL,
  `smoker` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `amka` (`amka`),
  CONSTRAINT `connect_patient_uid_with_user_id` FOREIGN KEY (`uid`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `connect_patients_amka_with_vitals_amka` FOREIGN KEY (`amka`) REFERENCES `vitals` (`amka`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,2,'Nick','Hard',1,'01057096325','6983548968','1970-05-01',85,187,24,1),(2,4,'Anna','Karenina',0,'09090378963','6974569874','1990-02-18',68,172,23,0),(3,5,'Max','Planck',1,'09090378963','6973568741','1980-10-10',78,170,27,1),(4,7,'Fyodor','Dostoevsky',1,'07128523659','6948623598','1985-12-07',75,167,27,0),(5,9,'Albert','Camus',1,'08088436987','6982459863','1984-08-08',51,162,19,0),(6,10,'Jean Paul','Sartre',1,'20109926589','6976987419','1999-10-20',96,174,32,1),(7,11,'Joey','Tribiani',1,'13050714568','6973896238','1971-05-13',104,169,36,0),(8,12,'Frida','Kahlo',0,'11010136987','6942879634','2001-01-11',97,181,30,0),(9,13,'Irene','Curie',0,'09090378963','6983987415','2003-09-09',48,165,18,0),(10,14,'Friedrich','Nietzsche',1,'15075269874','6974893158','1952-07-15',87,176,28,1),(11,15,'Bruce','Wayne',1,'13014832659','6981782593','1948-01-13',63,181,19,1),(12,16,'Great','Lebowski',1,'11116536987','6942763411','1965-11-11',58,164,22,1),(13,17,'Steve','Buscemi',1,'21036458971','6976664475','1964-03-21',103,192,28,0),(14,18,'James','Maxwell',1,'03047825417','6978693331','1978-04-03',97,186,28,1),(15,19,'Jim','Jarmusch',1,'31087156842','6978963148','1971-08-31',60,158,24,1),(16,20,'Marie','Curie',0,'01126078142','6973689782','1960-12-01',71,171,24,1),(17,21,'Phoebe','Buffay',0,'07070058963','6976982114','2000-07-07',74,169,26,1);
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questionary`
--

DROP TABLE IF EXISTS `questionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questionary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `questions` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questionary`
--

LOCK TABLES `questionary` WRITE;
/*!40000 ALTER TABLE `questionary` DISABLE KEYS */;
INSERT INTO `questionary` VALUES (1,'Do you have a fever?'),(2,'Do you have a persistent cough (coughing a lot for more than an hour or 3, or more coughing episodes in 24 hours)?'),(3,'Do you experience unusual fatigue?'),(4,'Do you experience shortness of breath?'),(5,'Do you have a headache?'),(6,'Do you have diarrhea?'),(7,'Do you experience anosmia or tastelessness?');
/*!40000 ALTER TABLE `questionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(40) NOT NULL,
  `passwd` varchar(40) NOT NULL,
  `usertype` int(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','123456',0),(2,'nickhard','n1ckh@rd',2),(3,'drwho','drwh0',1),(4,'akarenina','ak@renin@',2),(5,'mplanck','mpl@nck',2),(6,'aldebaran','@ld3b@r@n',1),(7,'fdostoevsky','fd0st0evsky',2),(8,'egray','egr@y',1),(9,'acamus','ac@mus',2),(10,'jpsartre','jps@rtre',2),(11,'jtribiani','jtribi@ni',2),(12,'fkahlo','fk@hlo',2),(13,'icurie','icuri3',2),(14,'fnietzsche','fnietzsch3',2),(15,'bwayne','bw@yne',2),(16,'glebowski','glebowsk1',2),(17,'sbuscemi','sbuscem1',2),(18,'jmaxwell','jm@xwell',2),(19,'jjarmusch','jj@rmusch',2),(20,'mcurie','mcuri3',2),(21,'pbuffay','pbuff@y',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vitals`
--

DROP TABLE IF EXISTS `vitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vitals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `respiration_rate` int(11) NOT NULL,
  `spo2` int(11) NOT NULL,
  `temperature` float NOT NULL,
  `systolic_pressure` int(11) NOT NULL,
  `diastolic_pressure` int(11) NOT NULL,
  `heart_rate` int(11) NOT NULL,
  `amka` varchar(11) NOT NULL,
  `doc_id` int(11) NOT NULL,
  `examination_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `amka` (`amka`),
  KEY `doc_id` (`doc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vitals`
--

LOCK TABLES `vitals` WRITE;
/*!40000 ALTER TABLE `vitals` DISABLE KEYS */;
INSERT INTO `vitals` VALUES (1,10,98,38.5,118,58,92,'01057096325',1,'2020-07-10 08:29:36'),(2,25,95,37.6,81,69,95,'01126078142',2,'2022-04-25 05:33:29'),(3,16,99,36.5,171,60,75,'03047825417',3,'2020-09-01 10:06:23'),(4,14,93,38.7,133,73,106,'07070058963',3,'2022-01-27 08:50:39'),(5,14,85,38.1,173,77,114,'07128523659',1,'2022-01-11 15:08:10'),(6,16,89,38.3,86,58,62,'08088436987',1,'2020-08-07 19:49:09'),(7,11,92,36.3,133,68,118,'09090378963',3,'2022-01-03 05:40:29'),(8,17,93,40.9,127,58,80,'10108025698',2,'2021-10-20 19:42:41'),(9,25,88,39.5,158,64,58,'11010136987',3,'2020-12-04 00:38:34'),(10,14,94,38.9,128,69,65,'11116536987',3,'2021-11-19 21:37:42'),(11,17,89,40,89,73,93,'13014832659',2,'2021-04-29 04:53:07'),(12,17,95,37.2,178,78,85,'13050714568',1,'2021-08-19 15:20:15'),(13,26,92,40,145,62,89,'15075269874',1,'2020-11-11 19:34:45'),(14,19,93,37.6,111,58,69,'18029025987',3,'2022-02-03 09:25:56'),(15,24,89,37.1,141,52,90,'20109926589',3,'2021-07-16 13:39:28'),(16,20,98,36.7,91,67,121,'21036458971',1,'2021-02-03 04:06:07'),(17,19,92,36.3,153,70,79,'31087156842',1,'2020-07-06 15:38:46'),(23,14,97,38.2,114,78,80,'01126078142',1,'2022-04-30 14:53:44'),(24,14,99,37,120,80,65,'07128523659',2,'2022-04-30 14:56:12'),(25,20,92,39,111,58,120,'18029025987',1,'2022-04-30 15:08:12'),(26,16,91,39.6,132,85,45,'13050714568',1,'2022-04-30 15:11:54'),(27,20,93,39.6,130,90,125,'18029025987',1,'2022-04-30 19:47:25'),(28,13,93,39.1,100,60,98,'09090378963',1,'2022-04-30 19:55:09'),(29,13,96,37.4,113,84,97,'15075269874',1,'2022-05-01 18:55:13'),(30,16,94,38.9,120,71,84,'09090378963',1,'2022-05-03 06:17:04'),(31,12,98,38.9,125,65,84,'20109926589',1,'2022-05-03 06:18:20'),(32,13,94,38.9,136,65,101,'10108025698',1,'2022-05-03 06:17:38'),(33,11,98,38.9,112,64,68,'10108025698',1,'2022-05-03 03:15:48');
/*!40000 ALTER TABLE `vitals` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-03 11:40:47
