/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : flow

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 15:55:52
*/

CREATE DATABASE flow;
USE flow;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dispatcher_callback
-- ----------------------------
DROP TABLE IF EXISTS `dispatcher_callback`;
CREATE TABLE `dispatcher_callback` (
  `id` varchar(40) NOT NULL,
  `type` varchar(10) NOT NULL COMMENT '回调类型',
  `task_def_key` varchar(64) DEFAULT NULL,
  `process_instance_id` varchar(64) DEFAULT NULL,
  `other_info` varchar(255) DEFAULT NULL COMMENT '其他信息',
  `creator_id` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for flow
-- ----------------------------
DROP TABLE IF EXISTS `flow`;
CREATE TABLE `flow` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `app_id` varchar(100) NOT NULL DEFAULT '' COMMENT '应用id',
  `source_id` varchar(100) NOT NULL DEFAULT '' COMMENT '源头流程id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '流程名称',
  `trigger_mode` varchar(10) NOT NULL DEFAULT '' COMMENT '触发方式',
  `form_id` varchar(100) NOT NULL DEFAULT '',
  `bpmn_text` text NOT NULL COMMENT '流程xml文件内容',
  `process_key` varchar(200) NOT NULL DEFAULT '' COMMENT '流程key',
  `status` varchar(10) NOT NULL DEFAULT '' COMMENT '状态',
  `can_cancel` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许撤回',
  `can_urge` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许催办',
  `can_view_status_msg` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许查看状态和留言',
  `can_msg` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否允许留言',
  `can_cancel_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '允许撤回类型',
  `can_cancel_nodes` varchar(1000) NOT NULL DEFAULT '' COMMENT '指定节点允许撤回',
  `instance_name` varchar(1000) NOT NULL DEFAULT '' COMMENT '流程实例标题',
  `key_fields` varchar(1000) NOT NULL DEFAULT '' COMMENT '流程摘要',
  `process_id` varchar(40) NOT NULL DEFAULT '' COMMENT 'process中流程的id',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程表';

-- ----------------------------
-- Table structure for flow_abnormal_task
-- ----------------------------
DROP TABLE IF EXISTS `flow_abnormal_task`;
CREATE TABLE `flow_abnormal_task` (
  `id` varchar(40) NOT NULL DEFAULT '',
  `flow_instance_id` varchar(100) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `process_instance_id` varchar(100) NOT NULL DEFAULT '' COMMENT 'camunda流程实例id',
  `task_id` varchar(100) NOT NULL DEFAULT '' COMMENT '任务id',
  `task_name` varchar(100) NOT NULL DEFAULT '' COMMENT '任务名称',
  `task_def_key` varchar(100) NOT NULL DEFAULT '' COMMENT '任务key',
  `reason` varchar(100) NOT NULL DEFAULT '' COMMENT '异常原因',
  `remark` varchar(100) NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='异常任务';

-- ----------------------------
-- Table structure for flow_comment
-- ----------------------------
DROP TABLE IF EXISTS `flow_comment`;
CREATE TABLE `flow_comment` (
  `id` varchar(40) NOT NULL COMMENT '主键',
  `flow_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `comment_user_id` varchar(40) NOT NULL DEFAULT '' COMMENT '讨论人id',
  `content` text NOT NULL COMMENT '讨论内容',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `flow_comment_flow_instance_id_index` (`flow_instance_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for flow_comment_attachment
-- ----------------------------
DROP TABLE IF EXISTS `flow_comment_attachment`;
CREATE TABLE `flow_comment_attachment` (
  `id` varchar(40) NOT NULL COMMENT '主键',
  `flow_comment_id` varchar(40) NOT NULL COMMENT '流程讨论表id',
  `attachment_name` varchar(300) NOT NULL DEFAULT '' COMMENT '附件名称',
  `attachment_url` varchar(500) NOT NULL DEFAULT '' COMMENT '附件地址',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `flow_comment_attachment_flow_comment_id_index` (`flow_comment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for flow_form_field
-- ----------------------------
DROP TABLE IF EXISTS `flow_form_field`;
CREATE TABLE `flow_form_field` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT '主键',
  `flow_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `form_id` varchar(50) NOT NULL DEFAULT '' COMMENT '表单id',
  `field_name` varchar(50) NOT NULL DEFAULT '' COMMENT '字段名',
  `field_value_path` varchar(100) NOT NULL DEFAULT '' COMMENT '字段值path',
  `creator_id` varchar(40) NOT NULL DEFAULT '',
  `create_time` varchar(40) DEFAULT NULL,
  `modifier_id` varchar(40) NOT NULL DEFAULT '',
  `modify_time` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_id` (`flow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工作流表单字段';

-- ----------------------------
-- Table structure for flow_instance
-- ----------------------------
DROP TABLE IF EXISTS `flow_instance`;
CREATE TABLE `flow_instance` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `app_id` varchar(100) NOT NULL DEFAULT '' COMMENT '应用id',
  `app_name` varchar(100) NOT NULL DEFAULT '' COMMENT '应用名称',
  `flow_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `process_instance_id` varchar(100) NOT NULL DEFAULT '' COMMENT 'camunda流程实例id',
  `form_id` varchar(100) DEFAULT '' COMMENT '表单id',
  `form_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '表单数据id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '流程名称',
  `apply_no` varchar(500) NOT NULL DEFAULT '' COMMENT '流水号',
  `apply_user_id` varchar(40) NOT NULL DEFAULT '' COMMENT '申请人id',
  `apply_user_name` varchar(100) NOT NULL DEFAULT '' COMMENT '申请人姓名',
  `status` varchar(30) NOT NULL DEFAULT '' COMMENT '审批单状态',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程实例';

-- ----------------------------
-- Table structure for flow_instance_step
-- ----------------------------
DROP TABLE IF EXISTS `flow_instance_step`;
CREATE TABLE `flow_instance_step` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `process_instance_id` varchar(64) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `task_id` varchar(64) NOT NULL DEFAULT '' COMMENT '任务id',
  `task_type` varchar(20) NOT NULL DEFAULT '' COMMENT '节点类型：或签、会签、任填、全填、开始、结束',
  `task_def_key` varchar(255) NOT NULL DEFAULT '' COMMENT '流程节点定义key',
  `task_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `node_instance_id` varchar(64) NOT NULL DEFAULT '' COMMENT '节点实例ID',
  `handle_user_ids` varchar(4000) NOT NULL DEFAULT '' COMMENT '处理人',
  `status` varchar(20) NOT NULL DEFAULT '' COMMENT '步骤处理结果，通过、拒绝、完成填写、已回退、打回重填、自动跳过、自动交给管理员',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程实例步骤表';

-- ----------------------------
-- Table structure for flow_instance_variables
-- ----------------------------
DROP TABLE IF EXISTS `flow_instance_variables`;
CREATE TABLE `flow_instance_variables` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT '主键',
  `process_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '变量名称SYSTEM：系统变量 CUSTOM：自定义变量',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '变量类型',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '变量标识',
  `field_type` varchar(50) NOT NULL DEFAULT '' COMMENT '字段类型',
  `format` varchar(50) NOT NULL DEFAULT '' COMMENT '字段格式',
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT '变量值',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '注释',
  `creator_id` varchar(40) NOT NULL DEFAULT '',
  `create_time` varchar(40) DEFAULT NULL,
  `modifier_id` varchar(40) NOT NULL DEFAULT '',
  `modify_time` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_id` (`process_instance_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程实例变量表';

-- ----------------------------
-- Table structure for flow_operation_record
-- ----------------------------
DROP TABLE IF EXISTS `flow_operation_record`;
CREATE TABLE `flow_operation_record` (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `process_instance_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `instance_step_id` varchar(64) NOT NULL DEFAULT '' COMMENT '流程实例环节表主键',
  `handle_user_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '处理人',
  `handle_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `handle_desc` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `task_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `task_name` varchar(100) NOT NULL DEFAULT '',
  `task_def_key` varchar(255) NOT NULL DEFAULT '' COMMENT '任务定义的ID',
  `remark` varchar(4000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `correlation_data` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT '',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  `rel_node_def_key` varchar(255) NOT NULL DEFAULT '' COMMENT '关联的node节点'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程操作记录';

-- ----------------------------
-- Table structure for flow_trigger_rule
-- ----------------------------
DROP TABLE IF EXISTS `flow_trigger_rule`;
CREATE TABLE `flow_trigger_rule` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT 'id',
  `flow_id` varchar(100) NOT NULL DEFAULT '' COMMENT '流程id',
  `form_id` varchar(100) NOT NULL DEFAULT '' COMMENT '表单id',
  `rule` text NOT NULL COMMENT '规则',
  `creator_id` varchar(40) NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='流程触发规则';

-- ----------------------------
-- Table structure for flow_urge
-- ----------------------------
DROP TABLE IF EXISTS `flow_urge`;
CREATE TABLE `flow_urge` (
  `id` varchar(40) NOT NULL,
  `task_id` varchar(64) DEFAULT NULL COMMENT '任务id',
  `process_instance_id` varchar(64) DEFAULT NULL COMMENT '流程实例id',
  `creator_id` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '创建人',
  `create_time` varchar(40) DEFAULT NULL COMMENT '创建时间',
  `modifier_id` varchar(40) CHARACTER SET utf8 NOT NULL DEFAULT '' COMMENT '更新人',
  `modify_time` varchar(40) DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for flow_variables
-- ----------------------------
DROP TABLE IF EXISTS `flow_variables`;
CREATE TABLE `flow_variables` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT '主键',
  `flow_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '变量名称SYSTEM：系统变量 CUSTOM：自定义变量',
  `type` varchar(20) NOT NULL DEFAULT '' COMMENT '变量类型',
  `code` varchar(50) NOT NULL DEFAULT '' COMMENT '变量标识',
  `field_type` varchar(50) NOT NULL DEFAULT '' COMMENT '字段类型',
  `format` varchar(50) NOT NULL DEFAULT '' COMMENT '字段格式',
  `default_value` varchar(255) NOT NULL DEFAULT '' COMMENT '默认值',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '注释',
  `creator_id` varchar(40) NOT NULL DEFAULT '',
  `create_time` varchar(40) DEFAULT NULL,
  `modifier_id` varchar(40) NOT NULL DEFAULT '',
  `modify_time` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `flow_id` (`flow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工作流变量表';

-- ----------------------------
-- Table structure for instance_execution
-- ----------------------------
DROP TABLE IF EXISTS `instance_execution`;
CREATE TABLE `instance_execution` (
  `id` varchar(40) NOT NULL DEFAULT '' COMMENT '主键',
  `process_instance_id` varchar(40) NOT NULL DEFAULT '' COMMENT '流程实例id',
  `execution_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'executionid',
  `result` varchar(20) NOT NULL DEFAULT '' COMMENT '分支结果：通过、拒绝',
  `creator_id` varchar(40) NOT NULL DEFAULT '',
  `create_time` varchar(40) DEFAULT NULL,
  `modifier_id` varchar(40) NOT NULL DEFAULT '',
  `modify_time` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO flow_variables (id,flow_id,name,`type`,code,field_type,format,default_value,`desc`,creator_id,create_time,modifier_id,modify_time) VALUES
	 ('1','0','流程发起人','SYSTEM','flowVar_instanceCreatorName','string','','','','0','2021-09-14T14:30:18+0000','0','2021-09-14T14:30:18+0000'),
	 ('2','0','流程发起时间','SYSTEM','flowVar_instanceCreateTime','datetime','','','','0','2021-09-14T14:30:18+0000','0','2021-09-14T14:30:18+0000'),
	 ('3','0','流程状态','SYSTEM','flowVar_instanceStatus','string','','','','0','2021-09-14T14:30:18+0000','0','2021-09-14T14:30:18+0000');

ALTER TABLE flow  ADD  app_status varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT 'app状态' after app_id;
ALTER TABLE flow_instance  ADD  app_status varchar(20) NOT NULL DEFAULT 'ACTIVE' COMMENT 'app状态' after app_id;

alter table flow add cron varchar(20) null;

alter table flow_variables
    modify code varchar(200) default '' not null comment '变量标识';

alter table flow_instance_variables
    modify code varchar(200) default '' not null comment '变量标识';

alter table flow_instance add request_id varchar(200) null;