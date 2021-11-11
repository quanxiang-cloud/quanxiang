/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : message

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 16:01:10
*/
CREATE DATABASE message;
USE message;


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for message_list
-- ----------------------------
DROP TABLE IF EXISTS `message_list`;
CREATE TABLE `message_list` (
  `id` varchar(36) NOT NULL,
  `template_id` varchar(36) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `args` text,
  `handle_id` varchar(36) DEFAULT NULL,
  `handle_name` varchar(30) DEFAULT NULL,
  `channel` varchar(30) DEFAULT NULL,
  `type` smallint(6) DEFAULT NULL,
  `send_way` varchar(50) DEFAULT NULL,
  `sort` smallint(6) DEFAULT NULL,
  `status` smallint(6) DEFAULT NULL,
  `recivers` text,
  `send_num` smallint(6) DEFAULT NULL,
  `success` smallint(6) DEFAULT NULL,
  `fail` smallint(6) DEFAULT NULL,
  `mes_attachment` text,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for message_send
-- ----------------------------
DROP TABLE IF EXISTS `message_send`;
CREATE TABLE `message_send` (
  `id` varchar(36) NOT NULL,
  `list_id` varchar(36) DEFAULT NULL,
  `content` text,
  `title` varchar(255) DEFAULT NULL,
  `handle_id` varchar(36) DEFAULT NULL,
  `handle_name` varchar(30) DEFAULT NULL,
  `reciver_id` varchar(36) DEFAULT NULL,
  `reciver_name` varchar(30) DEFAULT NULL,
  `channel` varchar(30) DEFAULT NULL,
  `reciver_account` varchar(100) DEFAULT NULL,
  `status` smallint(6) DEFAULT NULL,
  `read_status` smallint(6) DEFAULT NULL,
  `sort` smallint(6) DEFAULT NULL,
  `mes_attachment` text,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for template
-- ----------------------------
DROP TABLE IF EXISTS `template`;
CREATE TABLE `template` (
  `id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  `created_at` bigint(20) DEFAULT NULL,
  `updated_at` bigint(20) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
INSERT INTO `template` VALUES ('quanliang', '全量模板', '111', '#{code}', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_logincode', '登录验证码', '登录验证码', '您好：</br>您正在登录全象云系统，你的验证码是：#{code} 【有效期5分钟】', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_resetcode', '重置验证码', '重置验证码', '您好：</br>您正在重置您的全象云系统登录密码，你的验证码是：#{code} 【有效期5分钟】', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_forgetcode', '找回验证码', '找回验证码', '您好：</br>您正在找回全象云系统密码，你的验证码是：#{code} 【有效期5分钟】', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_resetpwd', '密码提示', '密码提示', '您好：</br>您正在使用全象云系统，当前最新的密码是 #{code}', NULL, NULL, NULL, NULL);
UPDATE message_list Set `source` = 'web' WHERE channel = 'letter'