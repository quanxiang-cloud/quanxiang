/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : application

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 15:52:16
*/
CREATE DATABASE application;
USE application;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for application
-- ----------------------------
DROP TABLE IF EXISTS `application`;
CREATE TABLE `application` (
  `id` varchar(64) NOT NULL,
  `application_name` varchar(50) DEFAULT NULL,
  `application_describe` varchar(50) DEFAULT NULL,
  `client_id` varchar(50) DEFAULT NULL,
  `client_secret` varchar(64) DEFAULT NULL,
  `domain` varchar(64) DEFAULT NULL,
  `app_index_url` varchar(100) DEFAULT NULL,
  `create_by` varchar(64) DEFAULT NULL,
  `client_base_url` varchar(100) DEFAULT NULL,
  `login_url` varchar(64) DEFAULT NULL,
  `status` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
insert into application (id, application_name, application_describe, client_id, client_secret, domain, app_index_url, create_by, client_base_url, login_url, status) values ('sdvcvnshms124s', '测试应用', '测试', '000000', '999999', 'http://oauth2c', 'http://127.0.0.1:9099/test/index', null, 'http://oauth2c/api/v1/oauth2c', 'http://127.0.0.1:9095/loginhtml', 1);