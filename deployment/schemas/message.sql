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


/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2021/3/28 20:01:33                           */
/*==============================================================*/


DROP TABLE IF EXISTS `message_list`;

DROP TABLE IF EXISTS `record`;

DROP TABLE IF EXISTS `template`;

/*==============================================================*/
/* Table: message_list                                          */
/*==============================================================*/
CREATE TABLE  `message_list`
(
    `id`                   VARCHAR(36) NOT NULL,
    `title`                VARCHAR(100),
    `content`              TEXT,
    `creator_id`            VARCHAR(36),
    `creator_name`          VARCHAR(30),
    `types`                 SMALLINT,
    `status`               SMALLINT,
    `receivers`             TEXT,
    `send_num`             SMALLINT,
    `success`              SMALLINT,
    `fail`                 SMALLINT,
    `files`                TEXT,
    `created_at`           BIGINT(20),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*==============================================================*/
/* Table: messsage_send                                         */
/*==============================================================*/
create table `record`
(
    `id`                   VARCHAR(36) NOT NULL,
    `list_id`              VARCHAR(36),
    `receiver_id`           VARCHAR(36),
    `receiver_name`         VARCHAR(30),
    `read_status`          SMALLINT,
    `types`                 SMALLINT,
    `created_at`           BIGINT(20),
    PRIMARY KEY(`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `template`  (
                             `id`         VARCHAR(36)  NOT NULL,
                             `name`       VARCHAR(255) NOT NULL,
                             `title`      VARCHAR(255) NOT NULL,
                             `content`    VARCHAR(255) NOT NULL,
                             `created_at` BIGINT(20) ,
                             `updated_at` BIGINT(20) ,
                             `create_by`  VARCHAR(255),
                             `status`     INT,
                             PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of template
-- ----------------------------
INSERT INTO `template` VALUES ('quanliang', '全量模板', '111', '{{.code}}', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_logincode', '登录验证码', '登录验证码', '您好：</br>您正在登录全象云系统，你的验证码是：{{.code}} 【有效期5分钟】', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_resetcode', '重置验证码', '重置验证码', '您好：</br>您正在重置您的全象云系统登录密码，你的验证码是：{{.code}} 【有效期5分钟】', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_forgetcode', '找回验证码', '找回验证码', '您好：</br>您正在找回全象云系统密码，你的验证码是：{{.code}} 【有效期5分钟】', NULL, NULL, NULL, NULL);

INSERT INTO `template` VALUES ('org_resetpwd', '密码提示', '密码提示', '您好：</br>您正在使用全象云系统，当前最新的密码是 {{.code}}', NULL, NULL, NULL, NULL);