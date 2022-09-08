/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2021/3/28 20:01:33                           */
/*==============================================================*/
CREATE DATABASE entrepot;
USE entrepot;

DROP TABLE IF EXISTS `task`;


/*==============================================================*/
/* Table: task                                          */
/*==============================================================*/
CREATE TABLE  `task`
(
    `id`                  VARCHAR(36) NOT NULL COMMENT 'id',
    `created_at`          BIGINT(20) COMMENT 'create time',
    `finish_at`           BIGINT(20) COMMENT 'finish time',
    `creator_id`          VARCHAR(36) COMMENT 'creator id',
    `creator_name`        VARCHAR(16) COMMENT 'creator name',
    `title`               VARCHAR(64) COMMENT 'task title',
    `types`               VARCHAR(16) COMMENT 'form app org' ,
    `command`             VARCHAR(16) COMMENT 'task command eg: formExport' ,
    `file_addr`           VARCHAR(128) COMMENT 'task import file-server path',
    `file_size`           INT(11) COMMENT 'file size',
    `file_opt`            VARCHAR(16) COMMENT 'eg:mino ',
    `value`              TEXT COMMENT 'task parameter key value json',
    `result`              TEXT COMMENT 'task result  key value json',
    `status`              SMALLINT COMMENT '1 ing ,2 success 3 fail',
    `ratio`               FLOAT COMMENT 'progress eg 50 is 50%',
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
