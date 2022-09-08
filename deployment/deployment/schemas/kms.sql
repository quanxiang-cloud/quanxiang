CREATE DATABASE kms;
USE kms;

DROP TABLE IF EXISTS secret_key;
CREATE TABLE `secret_key` (
                              `id`            VARCHAR(64)                 COMMENT 'unique id',
                              `owner`         VARCHAR(64)                 COMMENT 'owner id',
                              `owner_name`    VARCHAR(64)                 COMMENT 'owner name',
                              `name`          VARCHAR(64),
                              `title`         VARCHAR(64),
                              `description`   VARCHAR(255),
                              `key_id`        VARCHAR(128)    NOT NULL,
                              `key_secret`    VARCHAR(128)    NOT NULL,
                              `active`        INT(11)         NOT NULL    COMMENT '1 active 0 disable',
                              `assignee`      VARCHAR(64)                 COMMENT 'assignee name',
                              `create_at`     BIGINT(20)                  COMMENT 'create time',
                              `update_at`     BIGINT(20)                  COMMENT 'update time',
                              `delete_at`     BIGINT(20)                  COMMENT 'delete time',
                              UNIQUE KEY `idx_key_id` (`key_id`),
                              PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `customer_secret_key`;
CREATE TABLE `customer_secret_key` (
                                       `id`            VARCHAR(64)                 COMMENT 'unique id',
                                       `owner`         VARCHAR(64)                 COMMENT 'owner id',
                                       `owner_name`    VARCHAR(64)                 COMMENT 'owner name',
                                       `name`          VARCHAR(128),
                                       `title`         VARCHAR(128),
                                       `description`   VARCHAR(255),
                                       `service`       VARCHAR(128)    NOT NULL    COMMENT 'belong service, eg: system_form',
                                       `host`          VARCHAR(256)    NOT NULL    COMMENT 'service host, eg: api.xxx.com:8080',
                                       `auth_type`     VARCHAR(64)     NOT NULL    COMMENT 'signature/cookie/oauth2...',
                                       `auth_content`  TEXT            NOT NULL    COMMENT 'authorize detail',
                                       `key_id`        VARCHAR(512)    NOT NULL,
                                       `key_secret`    TEXT            NOT NULL    COMMENT 'crypt key secret',
                                       `key_content`   TEXT            NOT NULL    COMMENT 'key content',
                                       `active`        INT(11)         NOT NULL    COMMENT '1 active 0 disable',
                                       `parsed`        INT(11)         NOT NULL    COMMENT '1 parsed 0 not parse',
                                       `create_at`     BIGINT(20)                  COMMENT 'create time',
                                       `update_at`     BIGINT(20)                  COMMENT 'update time',
                                       `delete_at`     BIGINT(20)                  COMMENT 'delete time',
                                       UNIQUE KEY `idx_global_key`(`service`,`key_id`),
                                       PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `secret_key_config`;
CREATE TABLE `secret_key_config` (
                                     `id`                VARCHAR(64)             COMMENT 'unique id',
                                     `owner`             VARCHAR(64) NOT NULL    COMMENT 'owner id',
                                     `owner_name`        VARCHAR(64) NOT NULL    COMMENT 'owner name',
                                     `config_content`    VARCHAR(64) NOT NULL    COMMENT 'config content',
                                     `create_at`         BIGINT(20)              COMMENT 'create time',
                                     `update_at`         BIGINT(20)              COMMENT 'update time',
                                     `delete_at`         BIGINT(20)              COMMENT 'delete time',
                                     UNIQUE KEY `idx_owner`(`owner`),
                                     PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `secret_key_config` VALUES ('1', 'system', '系统', '{"keyNum": "5"}', unix_timestamp(NOW())*1000, unix_timestamp(NOW())*1000, NULL)
