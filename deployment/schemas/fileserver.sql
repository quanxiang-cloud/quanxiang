/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : fileserver

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 15:53:45
*/
CREATE DATABASE fileserver;
USE fileserver;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for fileserver
-- ----------------------------
CREATE TABLE `user`  (
                         `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
                         `file_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件名称',
                         `file_md5` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件唯一md5值',
                         `file_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件mime类型',
                         `file_time` int(11) NOT NULL DEFAULT 0 COMMENT '视频文件长度 单位秒',
                         `file_size` int(11) NOT NULL DEFAULT 0 COMMENT '文件大小 单位KB',
                         `file_number` int(11) NOT NULL DEFAULT 1 COMMENT '同一文件上传的个数',
                         `upload_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件上传保存的文件名',
                         `url` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'URL地址',
                         `create_at` bigint(20) NOT NULL COMMENT '创建时间',
                         `update_at` bigint(20) NOT NULL COMMENT '修改时间',
                         PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件上传表' ROW_FORMAT = DYNAMIC;

CREATE TABLE `fileserver`  (
                               `id` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'ID',
                               `file_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件名称',
                               `file_md5` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件唯一md5值',
                               `file_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件mime类型',
                               `file_time` int(11) NOT NULL DEFAULT 0 COMMENT '视频文件长度 单位秒',
                               `file_size` int(11) NOT NULL DEFAULT 0 COMMENT '文件大小 单位KB',
                               `file_number` int(11) NOT NULL DEFAULT 1 COMMENT '同一文件上传的个数',
                               `upload_name` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件上传保存的文件名',
                               `url` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'URL地址',
                               `create_at` bigint(20) NOT NULL COMMENT '创建时间',
                               `update_at` bigint(20) NOT NULL COMMENT '修改时间',
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件上传表' ROW_FORMAT = DYNAMIC;

-- 把表默认的字符集和所有字符列（CHAR,VARCHAR,TEXT）改为新的字符集
ALTER TABLE `fileserver`.`fileserver` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 修改
ALTER TABLE `fileserver`.`fileserver` change `file_md5` `digest` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '文件唯一md5值';
ALTER TABLE `fileserver`.`fileserver` change `file_type` `path` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '存储服务中的路径';
ALTER TABLE `fileserver`.`fileserver` change `file_number` `number` int NOT NULL DEFAULT '1' COMMENT '同一文件上传的个数';
ALTER TABLE `fileserver`.`fileserver` change `upload_name` `upload_id` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分块上传uploadID';
ALTER TABLE `fileserver`.`fileserver` change `file_size` `store_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '使用的存储配置名';
ALTER TABLE `fileserver`.`fileserver` change `file_time` `upload_type` int NOT NULL COMMENT '上传的类型，1：文件上传,2：自定义页面上传';

-- drop
ALTER TABLE `fileserver`.`fileserver` DROP `id`;
ALTER TABLE `fileserver`.`fileserver` DROP `url`;
-- 查看相关表与字段编码
-- SHOW CREATE TABLE `user`;
-- SHOW FULL COLUMNS FROM `user`;


ALTER TABLE `fileserver`.`fileserver` DROP `digest`;
ALTER TABLE `fileserver`.`fileserver` DROP `upload_type`;
ALTER TABLE `fileserver`.`fileserver` DROP `store_name`;
ALTER TABLE `fileserver`.`fileserver` DROP `upload_id`;
ALTER TABLE `fileserver`.`fileserver` DROP `number`;

-- ADD COLUMN
ALTER TABLE `fileserver`.`fileserver` ADD COLUMN `id` VARCHAR(36) FIRST;

UPDATE `fileserver`.`fileserver` set `id` = UUID();
DELETE FROM `fileserver`.`fileserver` WHERE `id` NOT IN (
    SELECT fs.minid FROM ( SELECT MIN(id) AS minid FROM `fileserver`.`fileserver` GROUP BY `path`) fs
);

-- ADD PRIMARY KEY and UNIQUE KEY
ALTER TABLE `fileserver`.`fileserver` ADD PRIMARY KEY(`id`);
ALTER TABLE `fileserver`.`fileserver` ADD UNIQUE UQE_PATH (`path`);
