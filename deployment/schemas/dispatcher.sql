/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : dispatcher

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 15:52:57
*/
CREATE DATABASE dispatcher;
USE dispatcher;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `id` varchar(36) NOT NULL,
  `title` varchar(120) DEFAULT NULL,
  `describe` text,
  `type` tinyint(1) NOT NULL,
  `time_bar` varchar(24) DEFAULT NULL,
  `state` tinyint(1) NOT NULL,
  `code` varchar(55) NOT NULL,
  `retry` int(2) DEFAULT NULL,
  `retry_delay` int(6) DEFAULT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
