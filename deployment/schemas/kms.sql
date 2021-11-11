/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : kms

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 16:00:54
*/

CREATE DATABASE kms;
USE kms;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for customer_secret_key
-- ----------------------------
DROP TABLE IF EXISTS `customer_secret_key`;
CREATE TABLE `customer_secret_key` (
  `id` varchar(64) NOT NULL COMMENT 'unique id',
  `owner` varchar(64) DEFAULT NULL COMMENT 'owner id',
  `owner_name` varchar(64) DEFAULT NULL COMMENT 'owner name',
  `name` varchar(128) DEFAULT NULL,
  `title` varchar(128) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `service` varchar(128) NOT NULL COMMENT 'belong service, eg: system_form',
  `host` varchar(256) NOT NULL COMMENT 'service host, eg: api.xxx.com:8080',
  `auth_type` varchar(64) NOT NULL COMMENT 'signature/cookie/oauth2...',
  `auth_content` text NOT NULL COMMENT 'authorize detail',
  `key_id` varchar(512) NOT NULL,
  `key_secret` text NOT NULL COMMENT 'crypt key secret',
  `key_content` text NOT NULL COMMENT 'key content',
  `active` int(11) NOT NULL COMMENT '1 active 0 disable',
  `create_at` datetime DEFAULT NULL COMMENT 'create time',
  `update_at` datetime DEFAULT NULL COMMENT 'update time',
  `delete_at` datetime DEFAULT NULL COMMENT 'delete time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_global_name` (`host`,`key_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for secret_key
-- ----------------------------
DROP TABLE IF EXISTS `secret_key`;
CREATE TABLE `secret_key` (
  `id` varchar(64) NOT NULL COMMENT 'unique id',
  `owner` varchar(64) DEFAULT NULL COMMENT 'owner id',
  `owner_name` varchar(64) DEFAULT NULL COMMENT 'owner name',
  `name` varchar(64) DEFAULT NULL,
  `title` varchar(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `key_id` varchar(128) NOT NULL,
  `key_secret` varchar(128) NOT NULL,
  `active` int(11) NOT NULL COMMENT '1 active 0 disable',
  `assignee` varchar(64) DEFAULT NULL COMMENT 'assignee name',
  `create_at` datetime DEFAULT NULL COMMENT 'create time',
  `update_at` datetime DEFAULT NULL COMMENT 'update time',
  `delete_at` datetime DEFAULT NULL COMMENT 'delete time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_key_id` (`key_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for secret_key_config
-- ----------------------------
DROP TABLE IF EXISTS `secret_key_config`;
CREATE TABLE `secret_key_config` (
  `id` varchar(64) NOT NULL COMMENT 'unique id',
  `owner` varchar(64) NOT NULL COMMENT 'owner id',
  `owner_name` varchar(64) NOT NULL COMMENT 'owner name',
  `key_num` int(11) NOT NULL COMMENT 'max key num',
  `expiry` int(11) NOT NULL COMMENT '1.expire, 0.no expiration',
  `expire_at` datetime DEFAULT NULL COMMENT 'expiry date',
  `create_at` datetime DEFAULT NULL COMMENT 'create time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;
REPLACE INTO `secret_key_config` VALUES ('1', 'system', '系统', '5', '0', NULL, NOW())