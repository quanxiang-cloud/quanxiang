/*
 Navicat Premium Data Transfer

 Source Server         : staging
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : 192.168.208.253:3306
 Source Schema         : app_center

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 26/10/2021 15:47:39
*/

CREATE DATABASE app_center;
USE app_center;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

create table t_app_center
(
    id          varchar(64)  not null
        primary key,
    app_name    varchar(80)  null,
    access_url  varchar(200) null,
    app_icon    text         null,
    create_by   varchar(64)  null,
    update_by   varchar(64)  null,
    create_time bigint       null,
    update_time bigint       null,
    use_status  bigint       null,
    constraint t_app_center_app_name_uindex
        unique (app_name)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

create table t_app_user_relation
(
    user_id varchar(64) null,
    app_id  varchar(64) null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

create table t_app_scope(
                            app_id varchar(64) null ,
                            scope_id varchar(64) null
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER table t_app_center ADD del_flag TINYINT;

UPDATE t_app_center set del_flag = 0;

ALTER table t_app_center ADD delete_time BIGINT;

UPDATE t_app_center set delete_time = 0;

DROP INDEX t_app_center_app_name_uindex ON t_app_center;

-- auto-generated definition
create table t_app_template
(
    id           varchar(64)  not null,
    name         varchar(80)  null comment 'template name',
    app_icon     text         null comment 'app icon',
    path         varchar(200) null comment 'file server path',
    source_id    varchar(64)  null comment 'source app id',
    source_name  varchar(80)  null comment 'source app name',
    version      varchar(64)  null comment 'template version',
    group_id     varchar(64)  null comment 'group id',
    created_by   varchar(64)  null,
    created_name varchar(64)  null,
    created_time bigint       null,
    updated_by   varchar(64)  null,
    updated_name varchar(64)  null,
    updated_time bigint       null,
    status       int          null comment 'publish status：0:private 1:public',
    constraint t_app_template_id_uindex
        unique (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment 'app template table';

alter table t_app_center add app_sign varchar(30) null;

alter table t_app_template
    add primary key (id);


alter table t_app_center
    add extension text null;

alter table t_app_center
    add description text null;


ALTER TABLE t_app_center ADD COLUMN server INT COMMENT 'initialized modules of app' AFTER use_status;

-- update t_app_center set use_status = -5;