-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 01, 2013 at 10:50 AM
-- Server version: 5.5.29
-- PHP Version: 5.4.6-1ubuntu1.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `grid360`
--

-- --------------------------------------------------------

--
-- Table structure for table `competency`
--

CREATE TABLE IF NOT EXISTS `competency` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `competencygroup_id` int(11) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_competency_tenant` (`tenant_id`),
  KEY `index_foreignkey_competency_competencygroup` (`competencygroup_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=42 ;

-- --------------------------------------------------------

--
-- Table structure for table `competencygroup`
--

CREATE TABLE IF NOT EXISTS `competencygroup` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `general` tinyint(3) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_competencygroup_tenant` (`tenant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE IF NOT EXISTS `department` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_department_tenant` (`tenant_id`),
  KEY `index_foreignkey_department_user` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=11 ;

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE IF NOT EXISTS `rating` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE IF NOT EXISTS `review` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `comment` text COLLATE utf8_unicode_ci,
  `reviewer_id` int(11) unsigned DEFAULT NULL,
  `reviewee_id` int(11) unsigned DEFAULT NULL,
  `competency_id` int(11) unsigned DEFAULT NULL,
  `rating_id` int(11) unsigned DEFAULT NULL,
  `round_id` int(11) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  `is_positive` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_review_user` (`reviewer_id`),
  KEY `cons_fk_review_reviewee_id_id` (`reviewee_id`),
  KEY `index_foreignkey_review_competency` (`competency_id`),
  KEY `index_foreignkey_review_rating` (`rating_id`),
  KEY `index_foreignkey_review_round` (`round_id`),
  KEY `index_foreignkey_review_tenant` (`tenant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1326 ;

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE IF NOT EXISTS `role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `department_id` int(11) unsigned DEFAULT NULL,
  `competencygroup_id` int(11) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_role_competencygroup` (`competencygroup_id`),
  KEY `index_foreignkey_role_tenant` (`tenant_id`),
  KEY `index_foreignkey_role_department` (`department_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Table structure for table `round`
--

CREATE TABLE IF NOT EXISTS `round` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` tinyint(3) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_round_tenant` (`tenant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `roundinfo`
--

CREATE TABLE IF NOT EXISTS `roundinfo` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(1) unsigned DEFAULT NULL,
  `answer` text COLLATE utf8_unicode_ci,
  `reviewer_id` int(11) unsigned DEFAULT NULL,
  `reviewee_id` int(11) unsigned DEFAULT NULL,
  `round_id` int(11) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_roundinfo_user` (`reviewer_id`),
  KEY `cons_fk_roundinfo_reviewee_id_id` (`reviewee_id`),
  KEY `index_foreignkey_roundinfo_round` (`round_id`),
  KEY `index_foreignkey_roundinfo_tenant` (`tenant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=471 ;

-- --------------------------------------------------------

--
-- Table structure for table `tenant`
--

CREATE TABLE IF NOT EXISTS `tenant` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` tinyint(3) unsigned DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `department_id` int(11) unsigned DEFAULT NULL,
  `role_id` int(11) unsigned DEFAULT NULL,
  `userlevel_id` int(11) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT NULL,
  `identity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_foreignkey_user_department` (`department_id`),
  KEY `index_foreignkey_user_role` (`role_id`),
  KEY `index_foreignkey_user_userlevel` (`userlevel_id`),
  KEY `index_foreignkey_user_tenant` (`tenant_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=35 ;

-- --------------------------------------------------------

--
-- Table structure for table `userlevel`
--

CREATE TABLE IF NOT EXISTS `userlevel` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `level` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `competency`
--
ALTER TABLE `competency`
  ADD CONSTRAINT `cons_fk_competency_competencygroup_id_id` FOREIGN KEY (`competencygroup_id`) REFERENCES `competencygroup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_competency_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `competencygroup`
--
ALTER TABLE `competencygroup`
  ADD CONSTRAINT `cons_fk_competencygroup_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `department`
--
ALTER TABLE `department`
  ADD CONSTRAINT `cons_fk_department_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_department_user_id_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `cons_fk_review_competency_id_id` FOREIGN KEY (`competency_id`) REFERENCES `competency` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_review_rating_id_id` FOREIGN KEY (`rating_id`) REFERENCES `rating` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_review_reviewee_id_id` FOREIGN KEY (`reviewee_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_review_reviewer_id_id` FOREIGN KEY (`reviewer_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_review_round_id_id` FOREIGN KEY (`round_id`) REFERENCES `round` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_review_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `role`
--
ALTER TABLE `role`
  ADD CONSTRAINT `cons_fk_role_competencygroup_id_id` FOREIGN KEY (`competencygroup_id`) REFERENCES `competencygroup` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_role_department_id_id` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_role_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `round`
--
ALTER TABLE `round`
  ADD CONSTRAINT `cons_fk_round_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `roundinfo`
--
ALTER TABLE `roundinfo`
  ADD CONSTRAINT `cons_fk_roundinfo_reviewee_id_id` FOREIGN KEY (`reviewee_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_roundinfo_reviewer_id_id` FOREIGN KEY (`reviewer_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_roundinfo_round_id_id` FOREIGN KEY (`round_id`) REFERENCES `round` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_roundinfo_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `cons_fk_user_department_id_id` FOREIGN KEY (`department_id`) REFERENCES `department` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_user_role_id_id` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_user_tenant_id_id` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
  ADD CONSTRAINT `cons_fk_user_userlevel_id_id` FOREIGN KEY (`userlevel_id`) REFERENCES `userlevel` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
