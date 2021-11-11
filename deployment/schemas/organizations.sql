/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : organizations

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 16:01:28
*/
CREATE DATABASE organizations;
USE organizations;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_source
-- ----------------------------
DROP TABLE IF EXISTS `auth_source`;
CREATE TABLE `auth_source` (
  `id` varchar(64) NOT NULL,
  `auth_conf` text,
  `company_id` varchar(64) DEFAULT NULL,
  `types` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_department
-- ----------------------------
DROP TABLE IF EXISTS `t_department`;
CREATE TABLE `t_department` (
  `id` varchar(64) NOT NULL,
  `department_name` varchar(64) DEFAULT NULL,
  `department_leader_id` varchar(64) DEFAULT NULL,
  `use_status` bigint(20) DEFAULT NULL,
  `pid` varchar(64) DEFAULT NULL,
  `super_pid` varchar(64) DEFAULT NULL,
  `company_id` varchar(64) DEFAULT NULL,
  `grade` bigint(20) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `creat_by` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `id` varchar(64) NOT NULL,
  `user_name` varchar(64) DEFAULT NULL,
  `phone` varchar(64) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `id_card` varchar(64) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `bank_card_number` varchar(64) DEFAULT NULL,
  `bank_address` varchar(64) DEFAULT NULL,
  `leader_id` varchar(64) DEFAULT NULL,
  `use_status` bigint(20) DEFAULT NULL,
  `company_id` varchar(64) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `creat_by` varchar(64) DEFAULT NULL,
  `avatar` text,
  `password_status` int(11) DEFAULT '0',
  `position` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `t_user_email_uindex` (`email`),
  UNIQUE KEY `t_user_phone_uindex` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for t_user_department_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_user_department_relation`;
CREATE TABLE `t_user_department_relation` (
  `user_id` varchar(64) DEFAULT NULL,
  `dep_id` varchar(64) DEFAULT NULL,
  KEY `t_user_department_relation_dep_id_index` (`dep_id`),
  KEY `t_user_department_relation_user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for user_account
-- ----------------------------
DROP TABLE IF EXISTS `user_account`;
CREATE TABLE `user_account` (
  `id` varchar(36) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_id` varchar(64) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `use_status` bigint(20) DEFAULT NULL,
  `create_time` bigint(20) DEFAULT NULL,
  `update_time` bigint(20) DEFAULT NULL,
  `create_by` varchar(64) DEFAULT NULL,
  `auth_source_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_account_user_name_uindex` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
insert into t_department (id, department_name, department_leader_id, use_status, pid, super_pid, company_id, grade,
                          create_time, update_time, creat_by)
values ('1', 'Demo', '', 1, null, '1', '123', 1, 1615897859, 1617693390, null);

insert into t_user (id, user_name, phone, email, id_card, address, bank_card_number, bank_address, leader_id,
                    use_status, company_id, create_time, update_time, creat_by, avatar, password_status)
values ('admin', 'superAdmin', '13866668888', 'Admin@Admin.com', '', '', '', '', '', 1, '', 1618207988, 1618207988,
        'Avatar', '', 0);

insert into t_user_department_relation (user_id, dep_id)
values ('admin', '1');

-- password 654321a..

INSERT INTO `organizations`.`user_account` (`id`, `user_name`, `user_id`, `password`, `use_status`, `create_time`, `update_time`, `create_by`, `auth_source_id`) values ('1', 'Admin@Admin.com', 'admin', '24d04ec3c9f0e285791035a47ba3e61a', 1, 1618207988, 1618207988, '1', '');

-- password 654321a..
insert into user_account (id, user_name, user_id, password, use_status, create_time, update_time, create_by,
                          auth_source_id)
values ('2', '13866668888', 'admin', '24d04ec3c9f0e285791035a47ba3e61a', 1, 1618207988,
        1618207988, '1', '');

