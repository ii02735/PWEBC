-- MySQL dump 10.13  Distrib 5.7.11, for Win32 (AMD64)
--
-- Host: localhost    Database: projet_pwebc
-- ------------------------------------------------------
-- Server version	5.7.11

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
-- Table structure for table `coords`
--

DROP TABLE IF EXISTS `coords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coords` (
  `IdPartie` int(11) NOT NULL,
  `Latitude` decimal(10,8) NOT NULL,
  `Longitude` decimal(10,8) NOT NULL,
  `PseudoJoueur` varchar(50) NOT NULL,
  KEY `PseudoJoueur` (`PseudoJoueur`),
  KEY `FK_IdPartie` (`IdPartie`),
  CONSTRAINT `FK_IdPartie` FOREIGN KEY (`IdPartie`) REFERENCES `partie` (`IdPartie`),
  CONSTRAINT `coords_ibfk_1` FOREIGN KEY (`PseudoJoueur`) REFERENCES `joueur` (`Pseudo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coords`
--

LOCK TABLES `coords` WRITE;
/*!40000 ALTER TABLE `coords` DISABLE KEYS */;
INSERT INTO `coords` VALUES (181,7.49319647,-3.80859397,'bilaal'),(181,7.66744148,4.80468728,'root'),(182,9.31899019,7.28027366,'alexandre'),(181,7.43509945,-5.03906272,'root'),(182,10.70379171,-0.38085960,'alexandre'),(184,6.79553503,3.01757835,'root'),(184,6.88280024,-4.77539085,'alexandre');
/*!40000 ALTER TABLE `coords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `joueur`
--

DROP TABLE IF EXISTS `joueur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `joueur` (
  `Pseudo` varchar(50) NOT NULL,
  `Mdp` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Victoires` int(11) DEFAULT '0',
  `Connexion` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`Pseudo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `joueur`
--

LOCK TABLES `joueur` WRITE;
/*!40000 ALTER TABLE `joueur` DISABLE KEYS */;
INSERT INTO `joueur` VALUES ('alexandre','as13ue!+','test@test2.com',0,0),('bilaal','as13ue!+','b@b.fr',0,0),('root','as13ue!+','r@r.fr',0,0),('valentine','valentine','valentine@gmail.com',0,0);
/*!40000 ALTER TABLE `joueur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partie`
--

DROP TABLE IF EXISTS `partie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partie` (
  `IdPartie` int(11) NOT NULL AUTO_INCREMENT,
  `DatePartie` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pseudoJoueur1` varchar(50) NOT NULL DEFAULT 'null',
  `pseudoJoueur2` varchar(50) DEFAULT NULL,
  `ScoreJoueur1` int(11) NOT NULL DEFAULT '0',
  `ScoreJoueur2` int(11) NOT NULL DEFAULT '0',
  `Gagnant` varchar(50) DEFAULT NULL,
  `ScoreGagnant` int(11) NOT NULL DEFAULT '0',
  `Etat` enum('inactif','sur ecoute','en cours','fini') NOT NULL DEFAULT 'inactif',
  PRIMARY KEY (`IdPartie`),
  KEY `pseudoJoueur1` (`pseudoJoueur1`),
  KEY `pseudoJoueur2` (`pseudoJoueur2`),
  CONSTRAINT `partie_ibfk_1` FOREIGN KEY (`pseudoJoueur1`) REFERENCES `joueur` (`Pseudo`),
  CONSTRAINT `partie_ibfk_2` FOREIGN KEY (`pseudoJoueur2`) REFERENCES `joueur` (`Pseudo`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partie`
--

LOCK TABLES `partie` WRITE;
/*!40000 ALTER TABLE `partie` DISABLE KEYS */;
INSERT INTO `partie` VALUES (181,'2018-03-14 15:28:42','root','bilaal',0,0,NULL,0,'en cours'),(182,'2018-03-14 15:47:09','alexandre','root',0,0,NULL,0,'en cours'),(183,'2018-03-14 15:50:12','alexandre','root',0,0,NULL,0,'en cours'),(184,'2018-03-14 15:50:36','alexandre','root',0,0,NULL,0,'en cours');
/*!40000 ALTER TABLE `partie` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER inserer_scores AFTER UPDATE ON Partie
FOR EACH ROW
BEGIN
	DECLARE scoreJoueur1 integer;
	DECLARE scoreJoueur2 integer;
	SET scoreJoueur1 = (SELECT Points From Score WHERE Pseudo = old.PseudoJoueur1 AND IdPartie = old.IdPartie);
	SET scoreJoueur2 = (SELECT Points From Score WHERE Pseudo = old.PseudoJoueur2 AND IdPartie = old.IdPartie);
IF old.Etat  = 'fini' THEN
    IF scoreJoueur1 > scoreJoueur2 THEN
	UPDATE Partie SET Gagnant = old.PseudoJoueur1 WHERE IdPartie = old.IdPartie;
	UPDATE Partie SET ScoreGagnant = scoreJoueur1 WHERE IdPartie = old.IdPartie;
	UPDATE Joueur SET Victoires = Victoires + 1 WHERE Pseudo = old.PseudoJoueur1;
   ELSE
	UPDATE Partie SET Gagnant = old.PseudoJoueur2 WHERE IdPartie = old.IdPartie;
	UPDATE Partie SET ScoreGagnant = scoreJoueur2  WHERE IdPartie = old.IdPartie;
	UPDATE Joueur SET Victoires = Victoires + 1 WHERE Pseudo = old.PseudoJoueur2;
   END IF;
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `score`
--

DROP TABLE IF EXISTS `score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `score` (
  `Points` int(11) NOT NULL DEFAULT '0',
  `Pseudo` varchar(50) DEFAULT NULL,
  `IdPartie` int(11) DEFAULT NULL,
  KEY `IdPartie` (`IdPartie`),
  KEY `Pseudo` (`Pseudo`),
  CONSTRAINT `score_ibfk_1` FOREIGN KEY (`IdPartie`) REFERENCES `partie` (`IdPartie`),
  CONSTRAINT `score_ibfk_2` FOREIGN KEY (`Pseudo`) REFERENCES `joueur` (`Pseudo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `score`
--

LOCK TABLES `score` WRITE;
/*!40000 ALTER TABLE `score` DISABLE KEYS */;
/*!40000 ALTER TABLE `score` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-14 16:54:29
