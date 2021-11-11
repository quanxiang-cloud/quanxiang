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
DROP TABLE IF EXISTS `fileserver`;
CREATE TABLE `fileserver` (
  `file_name` varchar(300) NOT NULL DEFAULT '' COMMENT '文件名称',
  `digest` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '文件唯一md5值',
  `path` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '存储服务中的路径',
  `upload_type` int(11) NOT NULL COMMENT '上传的类型，1：文件上传,2：自定义页面上传',
  `store_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '使用的存储配置名',
  `number` int(11) NOT NULL DEFAULT '1' COMMENT '同一文件上传的个数',
  `upload_id` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '分块上传uploadID',
  `create_at` bigint(20) NOT NULL COMMENT '创建时间',
  `update_at` bigint(20) NOT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='文件上传表';

SET FOREIGN_KEY_CHECKS = 1;
