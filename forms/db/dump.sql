CREATE DATABASE  IF NOT EXISTS `new_schema` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `new_schema`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: new_schema
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Classrooms`
--

DROP TABLE IF EXISTS `Classrooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Classrooms` (
  `ClassroomId` int NOT NULL,
  `ClassroomName` varchar(50) NOT NULL,
  PRIMARY KEY (`ClassroomId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Classrooms`
--

LOCK TABLES `Classrooms` WRITE;
/*!40000 ALTER TABLE `Classrooms` DISABLE KEYS */;
INSERT INTO `Classrooms` VALUES (1,'101'),(2,'102'),(3,'201'),(4,'301'),(5,'311');
/*!40000 ALTER TABLE `Classrooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Exams`
--

DROP TABLE IF EXISTS `Exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Exams` (
  `ExamId` int NOT NULL AUTO_INCREMENT,
  `SubjectId` int DEFAULT NULL,
  `ExamDate` date NOT NULL,
  `ExamTime` time NOT NULL,
  `ClassroomId` int DEFAULT NULL,
  PRIMARY KEY (`ExamId`),
  KEY `SubjectId` (`SubjectId`),
  KEY `ClassroomId` (`ClassroomId`),
  CONSTRAINT `Exams_ibfk_1` FOREIGN KEY (`SubjectId`) REFERENCES `Subjects` (`SubjectId`),
  CONSTRAINT `Exams_ibfk_2` FOREIGN KEY (`ClassroomId`) REFERENCES `Classrooms` (`ClassroomId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Exams`
--

LOCK TABLES `Exams` WRITE;
/*!40000 ALTER TABLE `Exams` DISABLE KEYS */;
INSERT INTO `Exams` VALUES (1,3,'2023-05-20','09:00:00',1),(2,1,'2023-06-15','12:00:00',2),(3,2,'2023-06-20','10:00:00',3);
/*!40000 ALTER TABLE `Exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Groups`
--

DROP TABLE IF EXISTS `Groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Groups` (
  `GroupId` int NOT NULL,
  `GroupName` varchar(50) NOT NULL,
  PRIMARY KEY (`GroupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Groups`
--

LOCK TABLES `Groups` WRITE;
/*!40000 ALTER TABLE `Groups` DISABLE KEYS */;
INSERT INTO `Groups` VALUES (1,'КН-11'),(2,'КН-12'),(3,'КН-21'),(4,'КН-22'),(5,'КН-31');
/*!40000 ALTER TABLE `Groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Professors`
--

DROP TABLE IF EXISTS `Professors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Professors` (
  `ProfessorId` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Department` varchar(50) DEFAULT NULL,
  `Position` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ProfessorId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Professors`
--

LOCK TABLES `Professors` WRITE;
/*!40000 ALTER TABLE `Professors` DISABLE KEYS */;
INSERT INTO `Professors` VALUES (1,'Іван','Кравчук','ivan.kravchuk@example.com',NULL,NULL,NULL),(2,'Марія','Сидоренко','maria.sydorenko@example.com',NULL,NULL,NULL),(3,'Олександра','Петренко','oleksandra.petrenko@example.com',NULL,NULL,NULL),(4,'Віктор','Бондаренко','victor.bondarenko@example.com',NULL,NULL,NULL),(5,'Тарас','Марченко','taras.marchenko@example.com',NULL,NULL,NULL);
/*!40000 ALTER TABLE `Professors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Schedule`
--

DROP TABLE IF EXISTS `Schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Schedule` (
  `ScheduleId` int NOT NULL AUTO_INCREMENT,
  `SubjectId` int DEFAULT NULL,
  `GroupId` int DEFAULT NULL,
  `ProfessorId` int DEFAULT NULL,
  `ClassroomId` int DEFAULT NULL,
  `StartTime` time NOT NULL,
  `EndTime` time NOT NULL,
  `DayOfWeek` int NOT NULL,
  `EvenOdd` tinyint(1) NOT NULL,
  PRIMARY KEY (`ScheduleId`),
  KEY `SubjectId` (`SubjectId`),
  KEY `GroupId` (`GroupId`),
  KEY `ProfessorId` (`ProfessorId`),
  KEY `ClassroomId` (`ClassroomId`),
  CONSTRAINT `Schedule_ibfk_1` FOREIGN KEY (`SubjectId`) REFERENCES `Subjects` (`SubjectId`),
  CONSTRAINT `Schedule_ibfk_2` FOREIGN KEY (`GroupId`) REFERENCES `Groups` (`GroupId`),
  CONSTRAINT `Schedule_ibfk_3` FOREIGN KEY (`ProfessorId`) REFERENCES `Professors` (`ProfessorId`),
  CONSTRAINT `Schedule_ibfk_4` FOREIGN KEY (`ClassroomId`) REFERENCES `Classrooms` (`ClassroomId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Schedule`
--

LOCK TABLES `Schedule` WRITE;
/*!40000 ALTER TABLE `Schedule` DISABLE KEYS */;
INSERT INTO `Schedule` VALUES (1,1,1,1,1,'08:30:00','10:00:00',1,1),(2,2,1,2,2,'10:15:00','11:45:00',1,1),(3,3,3,3,3,'12:00:00','13:30:00',1,1),(4,4,3,4,4,'14:00:00','15:30:00',1,1),(5,5,5,5,5,'15:45:00','17:15:00',1,1);
/*!40000 ALTER TABLE `Schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Students`
--

DROP TABLE IF EXISTS `Students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Students` (
  `StudentId` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(50) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `GroupId` int DEFAULT NULL,
  PRIMARY KEY (`StudentId`),
  KEY `GroupId` (`GroupId`),
  CONSTRAINT `Students_ibfk_1` FOREIGN KEY (`GroupId`) REFERENCES `Groups` (`GroupId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Students`
--

LOCK TABLES `Students` WRITE;
/*!40000 ALTER TABLE `Students` DISABLE KEYS */;
INSERT INTO `Students` VALUES (1,'Іван','Іванов',1),(2,'Петро','Петров',1),(3,'Марія','Петренко',1),(4,'Олег','Сидоренко',3),(5,'Віктор','Василенко',5);
/*!40000 ALTER TABLE `Students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Subjects`
--

DROP TABLE IF EXISTS `Subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Subjects` (
  `SubjectId` int NOT NULL,
  `SubjectName` varchar(100) NOT NULL,
  PRIMARY KEY (`SubjectId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Subjects`
--

LOCK TABLES `Subjects` WRITE;
/*!40000 ALTER TABLE `Subjects` DISABLE KEYS */;
INSERT INTO `Subjects` VALUES (1,'Бази даних'),(2,'Алгоритми і структури даних'),(3,'Вища математика'),(4,'Історія України'),(5,'Англійська мова');
/*!40000 ALTER TABLE `Subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tests`
--

DROP TABLE IF EXISTS `Tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tests` (
  `TestId` int NOT NULL AUTO_INCREMENT,
  `SubjectId` int DEFAULT NULL,
  `TestDate` date NOT NULL,
  `TestTime` time NOT NULL,
  `ClassroomId` int DEFAULT NULL,
  PRIMARY KEY (`TestId`),
  KEY `SubjectId` (`SubjectId`),
  KEY `ClassroomId` (`ClassroomId`),
  CONSTRAINT `Tests_ibfk_1` FOREIGN KEY (`SubjectId`) REFERENCES `Subjects` (`SubjectId`),
  CONSTRAINT `Tests_ibfk_2` FOREIGN KEY (`ClassroomId`) REFERENCES `Classrooms` (`ClassroomId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tests`
--

LOCK TABLES `Tests` WRITE;
/*!40000 ALTER TABLE `Tests` DISABLE KEYS */;
INSERT INTO `Tests` VALUES (1,1,'2023-05-15','08:30:00',1),(2,2,'2023-05-17','09:45:00',2),(3,3,'2023-05-19','10:30:00',3),(4,4,'2023-05-21','11:15:00',4),(5,5,'2023-05-23','12:00:00',5);
/*!40000 ALTER TABLE `Tests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-01  4:32:34
