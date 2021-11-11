/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : app_center

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 15:47:39
*/

CREATE DATABASE app_center;
USE app_center;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_app_center
-- ----------------------------
DROP TABLE IF EXISTS `t_app_center`;
CREATE TABLE `t_app_center` (
  `id` varchar(64) NOT NULL,
  `app_name` varchar(80) DEFAULT NULL,
  `access_url` varchar(200) DEFAULT NULL,
  `app_icon` text,
  `create_by` varchar(64) DEFAULT NULL,
  `update_by` varchar(64) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `use_status` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_app_center_app_name_uindex` (`app_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_app_scope
-- ----------------------------
DROP TABLE IF EXISTS `t_app_scope`;
CREATE TABLE `t_app_scope` (
  `app_id` varchar(64) DEFAULT NULL,
  `scope_id` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_app_user_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_app_user_relation`;
CREATE TABLE `t_app_user_relation` (
  `user_id` varchar(64) DEFAULT NULL,
  `app_id` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

ALTER table t_app_center ADD del_flag TINYINT;

UPDATE t_app_center set del_flag = 0;

ALTER table t_app_center ADD delete_time BIGINT;

UPDATE t_app_center set delete_time = 0;

DROP INDEX t_app_center_app_name_uindex ON t_app_center;
