/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : process

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 16:02:05
*/

CREATE DATABASE process;
USE process;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for proc_execution
-- ----------------------------
DROP TABLE IF EXISTS `proc_execution`;
CREATE TABLE `proc_execution` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `proc_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `p_id` varchar(40) NOT NULL DEFAULT '' COMMENT '父id',
  `node_def_key` varchar(120) NOT NULL DEFAULT '' COMMENT '节点自定义key',
  `node_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '节点实例id',
  `is_active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '激活状态',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程执行实例分析';

-- ----------------------------
-- Table structure for proc_history_task
-- ----------------------------
DROP TABLE IF EXISTS `proc_history_task`;
CREATE TABLE `proc_history_task` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `proc_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `execution_id` varchar(40) NOT NULL DEFAULT '' COMMENT '执行id',
  `node_id` varchar(40) NOT NULL DEFAULT '' COMMENT '节点id',
  `node_def_key` varchar(120) NOT NULL DEFAULT '' COMMENT '节点自定义key',
  `next_node_def_key` varchar(120) NOT NULL COMMENT '下个节点的自定义key',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '任务名称',
  `desc` varchar(100) NOT NULL DEFAULT '' COMMENT '描述',
  `assignee` varchar(36) NOT NULL DEFAULT '' COMMENT '处理人',
  `task_type` varchar(100) NOT NULL DEFAULT 'Model' COMMENT 'Model模型任务、TempModel临时模型任务、NonModel非模型任务',
  `status` varchar(40) NOT NULL DEFAULT '' COMMENT '状态',
  `due_time` varchar(40) NOT NULL DEFAULT '0' COMMENT '有效时间',
  `end_time` varchar(40) NOT NULL DEFAULT '0' COMMENT '结束时间',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程历史任务';

-- ----------------------------
-- Table structure for proc_identity_link
-- ----------------------------
DROP TABLE IF EXISTS `proc_identity_link`;
CREATE TABLE `proc_identity_link` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `node_id` varchar(40) NOT NULL DEFAULT '' COMMENT '节点id',
  `identity_type` varchar(20) NOT NULL DEFAULT '' COMMENT '类型',
  `user_id` varchar(40) NOT NULL DEFAULT '' COMMENT '用户id',
  `group_id` varchar(40) NOT NULL DEFAULT '' COMMENT '组id',
  `variable` varchar(100) NOT NULL DEFAULT '' COMMENT '变量名',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程处理人关联';

-- ----------------------------
-- Table structure for proc_instance
-- ----------------------------
DROP TABLE IF EXISTS `proc_instance`;
CREATE TABLE `proc_instance` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '流程实例名称',
  `p_id` varchar(40) NOT NULL DEFAULT '' COMMENT '父级流程实例id',
  `status` varchar(100) NOT NULL DEFAULT '' COMMENT '状态',
  `end_time` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例结束时间',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程实例';

-- ----------------------------
-- Table structure for proc_model
-- ----------------------------
DROP TABLE IF EXISTS `proc_model`;
CREATE TABLE `proc_model` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '流程名称',
  `def_key` varchar(100) NOT NULL DEFAULT '' COMMENT '流程自定义key',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程模型';

-- ----------------------------
-- Table structure for proc_node
-- ----------------------------
DROP TABLE IF EXISTS `proc_node`;
CREATE TABLE `proc_node` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `proc_instance_id` varchar(40) DEFAULT NULL COMMENT '加签临时节点的实例id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '流程名称',
  `def_key` varchar(120) NOT NULL DEFAULT '' COMMENT '节点自定义key',
  `node_type` varchar(20) NOT NULL DEFAULT '' COMMENT '节点类型',
  `pair_def_key` varchar(120) NOT NULL COMMENT '分流节点对应的合流节点',
  `sub_proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '子流程id',
  `desc` varchar(100) NOT NULL DEFAULT '' COMMENT '描述',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程节点';

-- ----------------------------
-- Table structure for proc_node_instance
-- ----------------------------
DROP TABLE IF EXISTS `proc_node_instance`;
CREATE TABLE `proc_node_instance` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `proc_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `p_id` varchar(40) NOT NULL DEFAULT '' COMMENT '父id',
  `execution_id` varchar(40) NOT NULL DEFAULT '' COMMENT '执行id',
  `node_def_key` varchar(120) NOT NULL DEFAULT '' COMMENT '节点自定义key',
  `node_name` varchar(100) NOT NULL DEFAULT '' COMMENT '节点名称',
  `node_type` varchar(20) NOT NULL DEFAULT '' COMMENT '节点类型',
  `task_id` varchar(40) NOT NULL DEFAULT '' COMMENT '任务id',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='节点实例';

-- ----------------------------
-- Table structure for proc_node_link
-- ----------------------------
DROP TABLE IF EXISTS `proc_node_link`;
CREATE TABLE `proc_node_link` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `node_id` varchar(40) NOT NULL DEFAULT '' COMMENT '节点id',
  `next_node_def_key` varchar(120) NOT NULL DEFAULT '' COMMENT '下个节点自定义id',
  `condition` varchar(2000) NOT NULL DEFAULT '' COMMENT '条件',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程节点关联';

-- ----------------------------
-- Table structure for proc_task
-- ----------------------------
DROP TABLE IF EXISTS `proc_task`;
CREATE TABLE `proc_task` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `proc_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `execution_id` varchar(40) NOT NULL DEFAULT '' COMMENT '执行id',
  `node_id` varchar(40) NOT NULL DEFAULT '' COMMENT '节点id',
  `node_def_key` varchar(120) NOT NULL DEFAULT '' COMMENT '节点自定义key',
  `next_node_def_key` varchar(120) NOT NULL COMMENT '下个节点的自定义key',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '任务名称',
  `desc` varchar(100) NOT NULL DEFAULT '' COMMENT '描述',
  `assignee` varchar(36) NOT NULL DEFAULT '' COMMENT '处理人',
  `task_type` varchar(100) NOT NULL DEFAULT 'Model' COMMENT 'Model模型任务、TempModel临时模型任务、NonModel非模型任务',
  `status` varchar(40) NOT NULL DEFAULT '' COMMENT '状态',
  `end_time` varchar(40) NOT NULL DEFAULT '' COMMENT '结束时间',
  `due_time` varchar(40) NOT NULL DEFAULT '' COMMENT '有效时间',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程任务实例';

-- ----------------------------
-- Table structure for proc_task_identity
-- ----------------------------
DROP TABLE IF EXISTS `proc_task_identity`;
CREATE TABLE `proc_task_identity` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `instance_id` varchar(40) NOT NULL COMMENT '流程实例id',
  `task_id` varchar(40) NOT NULL DEFAULT '' COMMENT '任务id',
  `identity_type` varchar(20) NOT NULL DEFAULT '' COMMENT '类型',
  `user_id` varchar(40) NOT NULL DEFAULT '' COMMENT '用户id',
  `group_id` varchar(40) NOT NULL DEFAULT '' COMMENT '组id',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='任务处理人';

-- ----------------------------
-- Table structure for proc_variables
-- ----------------------------
DROP TABLE IF EXISTS `proc_variables`;
CREATE TABLE `proc_variables` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `proc_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `node_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程任务实例id',
  `var_scope` varchar(100) NOT NULL DEFAULT '' COMMENT '变量作用范围',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '变量名称',
  `var_type` varchar(100) NOT NULL DEFAULT '' COMMENT '类型',
  `value` varchar(100) NOT NULL DEFAULT '' COMMENT '变量值',
  `bytes_value` longblob COMMENT '存储序列化变量值',
  `complex_value` json DEFAULT NULL COMMENT '存储复杂的变量值',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人id',
  `create_time` varchar(40) NOT NULL DEFAULT '' COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人id',
  `modify_time` varchar(40) NOT NULL DEFAULT '' COMMENT '更新时间',
  `tenant_id` varchar(40) NOT NULL DEFAULT '' COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='流程变量';

SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE proc_instance  ADD  app_status varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT 'app状态' after STATUS;