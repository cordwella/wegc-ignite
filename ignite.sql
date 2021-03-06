-- MySQL dump 10.16  Distrib 10.1.13-MariaDB, for osx10.11 (x86_64)
--
-- Host: localhost    Database: ignite
-- ------------------------------------------------------
-- Server version	10.1.13-MariaDB

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
-- Temporary table structure for view `house_points`
--

DROP TABLE IF EXISTS `house_points`;
/*!50001 DROP VIEW IF EXISTS `house_points`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `house_points` (
  `points` tinyint NOT NULL,
  `house_id` tinyint NOT NULL,
  `name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `houses`
--

DROP TABLE IF EXISTS `houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) NOT NULL,
  `desc` varchar(1000) DEFAULT NULL,
  `captain` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `houses`
--

LOCK TABLES `houses` WRITE;
/*!40000 ALTER TABLE `houses` DISABLE KEYS */;
INSERT INTO `houses` VALUES (1,'Bledisloe','Bledisloe house has won the athletics day competition for the last four years in a row, and the overall house cup for the last three - these stats alone show you that Bledisloe house is not one to mess with! So far as house prefect this year, I\'ve seen girls in red excel on the track and in the field, supporting each other from the sidelines, and chanting their hearts out - not to mention the stunning costumes they came up with for athletics day! I can\'t wait to see them excel even more at all the other things we have lined up for this year.','Ellie Shea'),(2,'Jellicoe','Hi, I am Stella Hudson, 2016\'s Jellicoe House Prefect! I\'m so passionate about our mighty green house and have ever been since year 9! Jellicoe has so much pride and the best chants ever! We love to dance, sing chant and jump. Jellicoe turns everyone in the room green with envy! JELLICOE FOR THE WIN.','Stella Hudson'),(3,'Fergusson','So far this year, we Fergi girls have spread spirit and showed off our best moves at athletics day in our best shades of yellow, keeping up in the running for house cup! I take pride and enjoy pushing and motivating Fergi girls to be there absolute best and reach full potential individually and as a house! and I believe with our enthusiasm, drive and of course awesome dancing we can take out the cup this year!','Lexi Apostolakis'),(4,'Onslow','Passionate, vibrant, dedicated, motivated and talented are just some of the many words to describe the girls that make up Onslow house. Onslow house is the house of blue, the house with the most pride and definitely the house that is going to win it this year. We aren\'t just a house that chants together, we stand together as one. This is why Onslow girls are so unique, we all have each others backs - \'Who has your back, Onslow has your back\'.','Katrina Stephens');
/*!40000 ALTER TABLE `houses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `markers`
--

DROP TABLE IF EXISTS `markers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `markers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `house_id` int(11) DEFAULT NULL,
  `point_value` int(3) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `catergory_fk` (`house_id`),
  CONSTRAINT `catergory_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `markers`
--

LOCK TABLES `markers` WRITE;
/*!40000 ALTER TABLE `markers` DISABLE KEYS */;
/*INSERT INTO `markers` VALUES (1,'Winds About The East Hills',1,1),(2,'Sounds of glorious carefree days',2,2),(3,'DOMELI!',3,3);*/
/*!40000 ALTER TABLE `markers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `markers_with_houses`
--

DROP TABLE IF EXISTS `markers_with_houses`;
/*!50001 DROP VIEW IF EXISTS `markers_with_houses`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `markers_with_houses` (
  `id` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `house_id` tinyint NOT NULL,
  `point_value` tinyint NOT NULL,
  `house` tinyint NOT NULL,
  `house_desc` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `scan_info`
--

DROP TABLE IF EXISTS `scan_info`;
/*!50001 DROP VIEW IF EXISTS `scan_info`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `scan_info` (
  `id` tinyint NOT NULL,
  `user_id` tinyint NOT NULL,
  `marker_id` tinyint NOT NULL,
  `scan_time` tinyint NOT NULL,
  `point_value` tinyint NOT NULL,
  `uname` tinyint NOT NULL,
  `uhouse_id` tinyint NOT NULL,
  `uhouse` tinyint NOT NULL,
  `mname` tinyint NOT NULL,
  `mhouse_id` tinyint NOT NULL,
  `mhouse` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `scans`
--

DROP TABLE IF EXISTS `scans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `marker_id` int(11) NOT NULL,
  `scan_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `point_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scans_once` (`user_id`,`marker_id`),
  KEY `marker_fk` (`marker_id`),
  CONSTRAINT `marker_fk` FOREIGN KEY (`marker_id`) REFERENCES `markers` (`id`),
  CONSTRAINT `user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scans`
--

LOCK TABLES `scans` WRITE;
/*!40000 ALTER TABLE `scans` DISABLE KEYS */;
/*!40000 ALTER TABLE `scans` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger update_points BEFORE INSERT ON scans FOR EACH ROW BEGIN     IF ((SELECT house_id FROM users WHERE id = NEW.user_id)      = (SELECT house_id FROM markers where id = NEW.marker_id)) THEN         SET NEW.point_value = (SELECT point_value from markers where id= new.marker_id)*2;     ELSE         SET NEW.point_value = (SELECT point_value from markers where id= new.marker_id);     END IF;  UPDATE users set points = points + NEW.point_value WHERE id = new.user_id;  END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uname` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `pwhash` binary(60) NOT NULL,
  `house_id` int(11) NOT NULL,
  `points` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uname` (`uname`),
  UNIQUE KEY `email` (`email`),
  KEY `house_fk` (`house_id`),
  CONSTRAINT `house_fk` FOREIGN KEY (`house_id`) REFERENCES `houses` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `users_with_house`
--

DROP TABLE IF EXISTS `users_with_house`;
/*!50001 DROP VIEW IF EXISTS `users_with_house`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `users_with_house` (
  `id` tinyint NOT NULL,
  `uname` tinyint NOT NULL,
  `email` tinyint NOT NULL,
  `house_id` tinyint NOT NULL,
  `points` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `desc` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `house_points`
--

/*!50001 DROP TABLE IF EXISTS `house_points`*/;
/*!50001 DROP VIEW IF EXISTS `house_points`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `house_points` AS select sum(`users`.`points`) AS `points`,`users`.`house_id` AS `house_id`,`houses`.`name` AS `name` from (`users` join `houses`) where (`users`.`house_id` = `houses`.`id`) group by `users`.`house_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `markers_with_houses`
--

/*!50001 DROP TABLE IF EXISTS `markers_with_houses`*/;
/*!50001 DROP VIEW IF EXISTS `markers_with_houses`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `markers_with_houses` AS select `markers`.`id` AS `id`,`markers`.`name` AS `name`,`markers`.`house_id` AS `house_id`,`markers`.`point_value` AS `point_value`,`houses`.`name` AS `house`,`houses`.`desc` AS `house_desc` from (`markers` left join `houses` on((`houses`.`id` = `markers`.`house_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `scan_info`
--

/*!50001 DROP TABLE IF EXISTS `scan_info`*/;
/*!50001 DROP VIEW IF EXISTS `scan_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `scan_info` AS select `scans`.`id` AS `id`,`scans`.`user_id` AS `user_id`,`scans`.`marker_id` AS `marker_id`,`scans`.`scan_time` AS `scan_time`,`scans`.`point_value` AS `point_value`,`users_with_house`.`uname` AS `uname`,`users_with_house`.`house_id` AS `uhouse_id`,`users_with_house`.`name` AS `uhouse`,`markers_with_houses`.`name` AS `mname`,`markers_with_houses`.`house_id` AS `mhouse_id`,`markers_with_houses`.`house` AS `mhouse` from ((`scans` left join `users_with_house` on((`users_with_house`.`id` = `scans`.`user_id`))) left join `markers_with_houses` on((`markers_with_houses`.`id` = `scans`.`marker_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `users_with_house`
--

/*!50001 DROP TABLE IF EXISTS `users_with_house`*/;
/*!50001 DROP VIEW IF EXISTS `users_with_house`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `users_with_house` AS select `users`.`id` AS `id`,`users`.`uname` AS `uname`,`users`.`email` AS `email`,`users`.`house_id` AS `house_id`,`users`.`points` AS `points`,`houses`.`name` AS `name`,`houses`.`desc` AS `desc` from (`users` join `houses`) where (`houses`.`id` = `users`.`house_id`) */;
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

-- Dump completed on 2016-05-10 16:00:18
