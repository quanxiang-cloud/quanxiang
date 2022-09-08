/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : goalie

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 16:00:30
*/

CREATE DATABASE goalie;
USE goalie;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for func
-- ----------------------------
DROP TABLE IF EXISTS `func`;
CREATE TABLE `func` (
  `id` varchar(36) NOT NULL,
  `p_id` varchar(36) DEFAULT NULL,
  `func_tag` varchar(255) NOT NULL,
  `name` varchar(60) NOT NULL,
  `describe` text,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nk_func_pid` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` varchar(36) NOT NULL,
  `name` varchar(30) NOT NULL,
  `tag` varchar(24) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for role_func
-- ----------------------------
DROP TABLE IF EXISTS `role_func`;
CREATE TABLE `role_func` (
  `id` varchar(36) NOT NULL,
  `role_id` varchar(36) NOT NULL,
  `func_id` varchar(36) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  `updated_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_func` (`role_id`,`func_id`),
  KEY `nk_role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for role_owner
-- ----------------------------
DROP TABLE IF EXISTS `role_owner`;
CREATE TABLE `role_owner` (
  `id` varchar(36) NOT NULL,
  `role_id` varchar(36) NOT NULL,
  `type` tinyint(1) NOT NULL,
  `owner_id` varchar(36) NOT NULL,
  `created_at` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_owner` (`role_id`,`owner_id`),
  KEY `nk_role` (`role_id`),
  KEY `nk_owner` (`owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
BEGIN;
INSERT INTO `role` (`id`, `name`,`tag`,`created_at`,`updated_at`)
    VALUES ("1","超级管理员","super",0,0);
INSERT INTO `role` (`id`, `name`,`tag`,`created_at`,`updated_at`)
    VALUES ("2","管理员","warden",0,0);
INSERT INTO `role` (`id`, `name`,`tag`,`created_at`,`updated_at`)
    VALUES ("3","查看者","viewer",0,0);
COMMIT;
BEGIN;
-- 应用管理 --
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("1","","application","应用管理","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("101","1","application/read","查看应用","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("102","1","application/create","新建应用","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("103","1","application/update","修改应用","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("104","1","application/delete","删除应用","",0,0);
-- 访问控制 --
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("2","","accessControl","访问控制","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("201","2","accessControl/mailList/read","查看企业通讯录","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("202","2","accessControl/mailList/manage","管理企业通讯录","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("203","2","accessControl/role/read","查看角色","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("204","2","accessControl/role/manage","管理角色","",0,0);
-- 平台设置 --
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("3","","platform","平台设置","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("301","3","platform/read","查看平台设置","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("302","3","platform/mangage","管理平台设置","",0,0);
COMMIT;
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("1","1","1",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("2","1","101",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("3","1","102",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("4","1","103",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("5","1","104",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("6","1","2",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("7","1","201",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("8","1","202",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("9","1","203",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("10","1","204",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("11","1","3",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("12","1","301",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("13","1","302",0,0);
COMMIT;

BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("14","2","1",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("15","2","101",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("16","2","102",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("17","2","103",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("18","2","104",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("19","2","2",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("20","2","201",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("21","2","202",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("22","2","203",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("23","2","204",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("24","2","3",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("25","2","301",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("26","2","302",0,0);
COMMIT;
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("27","3","1",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("28","3","101",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("29","3","2",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("30","3","201",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("31","3","203",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("32","3","3",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("33","3","301",0,0);
COMMIT;
BEGIN;
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("4","","system","系统设置","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("401","4","system/read","消息查看","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("402","4","system/mangage","消息管理","",0,0);
COMMIT;
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("34","1","4",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("35","1","401",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("36","1","402",0,0);
COMMIT;

BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("37","2","4",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("38","2","401",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("39","2","402",0,0);
COMMIT;

BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("40","3","4",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("41","3","401",0,0);
COMMIT;
-- 操作日志 ---
BEGIN;
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("5","","audit","操作日志","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("501","5","audit/read","查看","",0,0);
COMMIT;

-- 赋予超级管理员权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("42","1","5",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("43","1","501",0,0);
COMMIT;

-- 赋予管理员权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("44","2","5",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("45","2","501",0,0);
COMMIT;

-- 赋予观察这权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("46","3","5",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("47","3","501",0,0);
COMMIT;

-- 数据集 ---
BEGIN;
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("6","","system","数据集","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("601","6","dataset/read","查看","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("602","6","dataset/create","新建","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("603","6","dataset/update","修改","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("604","6","dataset/delete","删除","",0,0);
COMMIT;

-- 赋予超级管理员权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("48","1","6",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("49","1","601",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("50","1","602",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("51","1","603",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("52","1","604",0,0);
COMMIT;

-- 赋予管理员权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("53","2","6",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("54","2","601",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("55","2","602",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("56","2","603",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("57","2","604",0,0);
COMMIT;

-- 赋予观察这权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("58","3","6",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("59","3","601",0,0);
COMMIT;


-- 异常流程 ---
BEGIN;
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("7","","abnormalFlow","异常流程","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("701","7","abnormalFlow/read","查看","",0,0);
INSERT INTO `func` (`id`, `p_id`,`func_tag`,`name`,`describe`,`created_at`,`updated_at`)
    VALUES ("702","7","abnormalFlow/dispose","处理","",0,0);
COMMIT;

-- 赋予超级管理员权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("60","1","7",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("61","1","701",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("62","1","702",0,0);
COMMIT;

-- 赋予管理员权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("63","2","7",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("64","2","701",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("65","2","702",0,0);
COMMIT;

-- 赋予观察这权限 --
BEGIN;
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("66","3","7",0,0);
INSERT INTO `role_func` (`id`, `role_id`,`func_id`,`created_at`,`updated_at`)
    VALUES ("67","3","701",0,0);
COMMIT;

-- insert into role_owner (`id`, `role_id`, `type`, `owner_id`, `created_at`)values ('1', '1', '1', 'admin',0);

-- update func set created_at=1629257919 where p_id!='' or p_id is not null

-- 默认超管 --
insert into role_owner (`id`, `role_id`, `type`, `owner_id`, `created_at`)values ('1', '1', '1', '1',0);

-- role 新增字段 --
alter table role add created_by varchar(64) null;

alter table role add updated_by varchar(64) null;

alter table role add tenant_id varchar(64) null;
