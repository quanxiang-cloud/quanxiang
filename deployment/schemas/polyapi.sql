CREATE DATABASE polyapi;
USE polyapi;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_namespace`;
CREATE TABLE `api_namespace` (
    `id` 		    VARCHAR(64) 	NOT NULL COMMENT 'unique id',
    `owner` 	    VARCHAR(64) 	COMMENT 'owner id',
    `owner_name` 	VARCHAR(64) 	COMMENT 'owner name',
    `parent`        VARCHAR(320) 	NOT NULL DEFAULT '' COMMENT 'full namespace path, eg: /a/b/c',
    `namespace`     VARCHAR(64) 	NOT NULL  COMMENT 'global namespace, inmutable',
    `sub_count`     INT(10) DEFAULT 0 NOT NULL COMMENT 'count of sub namespace',
    `title` 	    VARCHAR(64) 	COMMENT 'alias of namespace, mutable',
    `desc` 		    VARCHAR(256) 	DEFAULT '',

    `access` 	    INT(11) 	    NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`        TINYINT         DEFAULT 1 COMMENT '1 ok, 0 disable',
    `valid`         TINYINT         DEFAULT 1 COMMENT '1 valid, 0 invalid',

    `create_at`     DATETIME 		COMMENT 'create time',
    `update_at`     DATETIME 		COMMENT 'update time',
    `delete_at`     DATETIME 		COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`parent`, `namespace`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_service`;
CREATE TABLE `api_service` (
    `id` 		    VARCHAR(64) 	COMMENT 'unique id',
    `owner` 	    VARCHAR(64) 	COMMENT 'owner id',
    `owner_name` 	VARCHAR(64) 	COMMENT 'owner name',
    `namespace`     VARCHAR(384) 	NOT NULL COMMENT 'full namespace path, eg: a/b/c',
    `name`	        VARCHAR(64) 	NOT NULL COMMENT 'service name, unique in namespace',
    `title` 	    VARCHAR(64) 	COMMENT 'alias of service, mutable',
    `desc` 		    VARCHAR(256) 	DEFAULT '',

    `access` 	    INT(11) 	 	NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`        TINYINT         DEFAULT 1 COMMENT '1 ok, 0 disable',
    `schema` 	    VARCHAR(16) 	NOT NULL COMMENT 'http/https',
    `host` 		    VARCHAR(128) 	NOT NULL COMMENT 'eg: api.xxx.com:8080',
    `auth_type`     VARCHAR(32)     NOT NULL COMMENT 'none/system/signature/cookie/oauth2...',
    `authorize`     TEXT            COMMENT 'JSON',

    `create_at`     DATETIME 		COMMENT 'create time',
    `update_at`     DATETIME 		COMMENT 'update time',
    `delete_at`     DATETIME 		COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`, `name`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE  INTO `api_namespace`(`id`,`owner`,`owner_name`,`parent`,`namespace`,`title`,`desc`,`access`,`active`,`create_at`,`update_at`,`delete_at`) VALUES
('1','system','系统','-','system','内部系统','系统自动注册的API',0,1,NOW(),NOW(),NULL),
('1-0','system','系统','/system','poly','内部聚合','内部生成的聚合API',0,1,NOW(),NOW(),NULL),
('1-1','system','系统','/system','faas','函数服务','通过faas注册的API',0,1,NOW(),NOW(),NULL),
('1-2','system','系统','/system','app','app根目录','app根目录',0,1,NOW(),NOW(),NULL),
('1-3','system','系统','/system','form','表单模型','通过form注册的API',0,1,NOW(),NOW(),NULL);

UPDATE `api_namespace` SET `sub_count`=0;
UPDATE `api_namespace` u,
(SELECT `parent`, COUNT(1) cnt FROM `api_namespace` GROUP BY `parent`) t
SET u.`sub_count`=t.`cnt` WHERE CONCAT(u.`parent`,'/',u.`namespace`)=t.`parent`;
UPDATE `api_namespace` u,
(SELECT `parent`, COUNT(1) cnt FROM `api_namespace` GROUP BY `parent`) t
SET u.`sub_count`=t.`cnt` WHERE CONCAT('/',u.`namespace`)=t.`parent`;

REPLACE  INTO `api_service`(`id`,`owner`,`owner_name`,`namespace`,`name`,`title`,`desc`,`access`,`active`,`schema`,`host`,`auth_type`,`authorize`,`create_at`,`update_at`,`delete_at`) VALUES
('1','system','系统','/system/app','form','表单','表单接口',0,1,'http','form','system',NULL,NOW(),NOW(),NULL),
('2','system','系统','/system/app','structor','表单底层','表单底层接口',0,1,'http','structor','system',NULL,NOW(),NOW(),NULL);

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_raw`;
CREATE TABLE `api_raw` (
    `id`        VARCHAR(64)  COMMENT 'unique id',
    `owner`     VARCHAR(64)  COMMENT 'owner id',
    `owner_name`VARCHAR(64)  COMMENT 'owner name',
    `namespace` VARCHAR(384) NOT NULL COMMENT 'belong full namespace, eg: /a/b/c',
    `name`      VARCHAR(64) NOT NULL COMMENT 'unique name',
    `service`   VARCHAR(512) NOT NULL COMMENT 'belong service full path, eg: /a/b/c/servicesX',
    `title` 	VARCHAR(64)  COMMENT 'alias of name, mutable',
    `desc`      TEXT         ,
    `version`   VARCHAR(32),
    `path`      VARCHAR(512) NOT NULL COMMENT 'relative path, eg: /api/foo/bar',
    `url`       VARCHAR(512) NOT NULL COMMENT 'full path, eg: https://api.xxx.com/api/foo/bar',
    `action`    VARCHAR(64) DEFAULT '' COMMENT 'action on path',
    `method`    VARCHAR(16) NOT NULL COMMENT 'method',
    `content`   TEXT,
    `doc`   	TEXT COMMENT 'api doc',

    `access` 	INT(11) 	 NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`    TINYINT      DEFAULT 1 COMMENT '1 ok, 0 disable',
    `valid`         TINYINT         DEFAULT 1 COMMENT '1 valid, 0 invalid',

    `schema` 	VARCHAR(16) 	NOT NULL COMMENT 'from service, http/https',
    `host` 		VARCHAR(128) 	NOT NULL COMMENT 'eg: api.xxx.com:8080',
    `auth_type` VARCHAR(32)     NOT NULL COMMENT 'none/system/signature/cookie/oauth2...',

    `create_at` DATETIME 	COMMENT 'create time',
    `update_at` DATETIME 	COMMENT 'update time',
    `delete_at` DATETIME 	COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`,`name`),
    KEY `idx_service` (`service`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_poly`;
CREATE TABLE `api_poly` (
    `id`        VARCHAR(64)  COMMENT 'unique id',
    `owner`     VARCHAR(64)  COMMENT 'owner id',
    `owner_name`VARCHAR(64)  COMMENT 'owner name',
    `namespace` VARCHAR(384) NOT NULL COMMENT 'belong full namespace, eg: /a/b/c',
    `name`      VARCHAR(64) NOT NULL COMMENT 'name',
    `title` 	VARCHAR(64)  COMMENT 'alias of name, mutable',
    `desc`      VARCHAR(256) DEFAULT '',

    `access` 	INT(11) 	NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`    TINYINT     DEFAULT 1 COMMENT '1 ok, 0 disable',
    `valid`         TINYINT         DEFAULT 1 COMMENT '1 valid, 0 invalid',

    `method`    VARCHAR(16) NOT NULL COMMENT 'method',
    `arrange`   TEXT 		COMMENT 'arrange',
    `doc`       TEXT 		COMMENT 'api doc',
    `script`    TEXT,

    `create_at` DATETIME 	COMMENT 'create time',
    `update_at` DATETIME 	COMMENT 'update time',
    `build_at`  DATETIME 	COMMENT 'build time',
    `delete_at` DATETIME 	COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`,`name`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_permit_group`;
CREATE TABLE `api_permit_group` (
    `id` 		VARCHAR(64) 	COMMENT 'unique id',
    `owner` 	VARCHAR(64) 	COMMENT 'owner id',
    `owner_name`VARCHAR(64)     COMMENT 'owner name',
    `namespace` VARCHAR(384) 	NOT NULL  COMMENT 'belong namespace',
    `name`      VARCHAR(64)    NOT NULL COMMENT 'permit group name',
    `title` 	VARCHAR(64) 	COMMENT 'alias, mutable',
    `desc` 		VARCHAR(256) 	DEFAULT '',

    `access` 	INT(11) 		NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`    TINYINT     	DEFAULT 1 COMMENT '1 ok, 0 disable',

    `create_at` DATETIME 	    COMMENT 'create time',
    `update_at` DATETIME 	    COMMENT 'update time',
    `delete_at` DATETIME 	    COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`,`name`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_permit_elem`;
CREATE TABLE `api_permit_elem` (
    `id` 		VARCHAR(64) 	COMMENT 'unique id',
    `owner` 	VARCHAR(64) 	COMMENT 'owner id',
    `owner_name`VARCHAR(64)  COMMENT 'owner name',

    `group_path` VARCHAR(448) 	COMMENT 'permitgroup path',
    `elem_type` VARCHAR(10)     COMMENT 'raw/poly/ckey/ns/service',
    `elem_id` 	VARCHAR(64) 	COMMENT 'element id',
    `elem_path` VARCHAR(512) 	COMMENT 'element path',
    `desc`      VARCHAR(256)    DEFAULT '',
    `elem_pri`  INT(11) 		NOT NULL COMMENT 'privilege for this elem, 1,2,4,8,16,32 CRUDGX',
    `content` 	TEXT            COMMENT 'permission detail JSON, for api field control',
    `active`    TINYINT         DEFAULT 1 COMMENT '1 ok, 0 disable',

    `create_at` DATETIME 	    COMMENT 'create time',
    `update_at` DATETIME 	    COMMENT 'update time',
    `delete_at` DATETIME 	    COMMENT 'delete time',
    UNIQUE KEY `idx_group_elem` (`group_path`,`elem_type`, `elem_id`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_permit_grant`;
CREATE TABLE `api_permit_grant` (
    `id`         VARCHAR(64)    COMMENT 'unique id',
    `owner`      VARCHAR(64)    COMMENT 'owner id',
    `owner_name` VARCHAR(64)  COMMENT 'owner name',

    `group_path` VARCHAR(448) 	COMMENT 'permitgroup path',
    `grant_type` VARCHAR(10)    COMMENT 'app/user/key/usergroup',
    `grant_id`   VARCHAR(64) 	COMMENT 'element id',
    `grant_name` VARCHAR(64) 	COMMENT 'element name',
    `grant_pri`  INT(11) 		NOT NULL COMMENT 'privilege for this group, 1,2,4,8,16,32 CRUDGX',
    `desc`       VARCHAR(256)   DEFAULT '',
    `active`     TINYINT        DEFAULT 1 COMMENT '1 ok, 0 disable',

    `create_at`     DATETIME 	COMMENT 'create time',
    `update_at`     DATETIME 	COMMENT 'update time',
    `delete_at`     DATETIME 	COMMENT 'delete time',
    UNIQUE KEY `idx_group_grant` (`group_path`, `grant_type`, `grant_id`),
    KEY `idx_grant`(`grant_type`, `grant_id`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_raw_poly`;
Create TABLE `api_raw_poly` (
    `id`        VARCHAR(64)     NOT NULL COMMENT 'unique id',
    `raw_api`   VARCHAR(512)    NOT NULL COMMENT 'raw api full-path, eg: /a/b/c/rawApiName',
    `poly_api`  VARCHAR(512)    NOT NULL COMMENT 'poly api full-path, eg: /a/b/c/polyApiName',
    INDEX `idx_rawapi` (`raw_api`),
    INDEX `idx_polyapi` (`poly_api`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;



/*Data for the table `api_poly` */

insert  into `api_poly`(`id`,`owner`,`owner_name`,`namespace`,`name`,`title`,`desc`,`access`,`active`,`valid`,`method`,`arrange`,`doc`,`script`,`create_at`,`update_at`,`build_at`,`delete_at`) values
('poly_ABIJPi2ckYlIKgMEKiTbFDw0CCpLxLLvf1_eSzIS4S_p','system','系统','/system/poly','permissionInit','初始化权限组','',3,1,1,'POST','','','// qyTmpScript_/system/poly/permissionInit_permissionInit_2021-11-10T14:06:00CST\nvar _tmp = function(){\n  var d = { \"__input\": __input, } // qyAllLocalData\n\n  d.start = __input.body\n\n  d.start.header = d.start.header || {}\n  d.start._ = [\n    pdCreateNS(\'/system/app\',d.start.appID),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'customer\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'poly\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'faas\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'form\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/form\',\'form\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/form\',\'custom\'),\n  ]\n  if (true) { // req1, create\n    var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/create\" ,d.start.appID)\n    var _t = {\n        \"name\": d.start.name,\n        \"description\": d.start.description,\n        \"types\": d.start.types,\n      }\n    var _th = pdNewHttpHeader()\n    pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n    var _tk = \'\';\n    var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n    d.req1 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n  }\n  d.cond1 = { y: false, }\n  if (d.req1.code==0) {\n    d.cond1.y = true\n    if (true) { // req2, update\n      var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/update\" ,d.start.appID)\n      var _t = {\n          \"id\": d.req1.data.id,\n          \"scopes\": d.start.scopes,\n        }\n      var _th = pdNewHttpHeader()\n      pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n      var _tk = \'\';\n      var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n      d.req2 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n    }\n  }\n\n  d.end = {\n    \"createNamespaces\": d.start._,\n    \"req1\": d.req1,\n    \"req2\": sel(d.cond1.y,d.req2,undefined),\n  }\n  return pdToJsonP(d.end)\n}; _tmp();\n','2021-11-10 14:05:50','2021-11-10 14:06:00','2021-11-10 14:06:01',NULL);

/*Data for the table `api_raw` */

insert  into `api_raw`(`id`,`owner`,`owner_name`,`namespace`,`name`,`service`,`title`,`desc`,`version`,`path`,`url`,`action`,`method`,`content`,`doc`,`access`,`active`,`valid`,`schema`,`host`,`auth_type`,`create_at`,`update_at`,`delete_at`) values
('raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R','system','系统','/system/form','base_pergroup_create','','创建用户组','','last','/api/v1/structor/:appID/base/permission/perGroup/create','http://structor/api/v1/structor/:appID/base/permission/perGroup/create','','POST','{\"x-id\":\"raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/create\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"创建用户组\",\"desc\":\"\"}','{\"x-id\":\"\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/raw/request/system/form/base_pergroup_create\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"Signature\",\"title\":\"参数签名\",\"desc\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"data\":null,\"in\":\"header\",\"mock\":\"J834jkhwrwkkjhkYIUYU9886876387\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2\",\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"data\":\"application/json\",\"in\":\"header\",\"required\":true,\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"data\":null,\"in\":\"path\",\"required\":true},{\"type\":\"object\",\"name\":\"root\",\"data\":[{\"type\":\"object\",\"name\":\"_signature\",\"title\":\"签名参数\",\"desc\":\"signature paramters of poly api server\",\"data\":[{\"type\":\"timestamp\",\"name\":\"timestamp\",\"title\":\"时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"data\":null},{\"type\":\"number\",\"name\":\"version\",\"title\":\"版本\",\"desc\":\"1 only current\",\"data\":\"1\"},{\"type\":\"string\",\"name\":\"method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"data\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"access_key_id\",\"title\":\"密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"data\":\"KeiIY8098435rty\"}]},{\"type\":\"string\",\"name\":\"name\",\"data\":null},{\"type\":\"string\",\"name\":\"description\",\"data\":null}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"新增后，权限用户组id\",\"data\":null}]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"Signature\":[\"J834jkhwrwkkjhkYIUYU9886876387\"]},\"body\":{\"_hide\":{\"appID\":\"2zvCI5n\"},\"_signature\":{\"access_key_id\":\"KeiIY8098435rty\",\"method\":\"HmacSHA256\",\"timestamp\":\"2020-12-31T05:43:21CST\",\"version\":1},\"description\":\"KJ5xJY2xOa\",\"name\":\"yR3QX\"}},{\"header\":{\"参数签名\":[\"J834jkhwrwkkjhkYIUYU9886876387\"],\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"]},\"body\":{\"_hide\":{\"appID\":\"cUL6M\"},\"description\":\"6CM\",\"name\":\"iOF03-rW\",\"签名参数\":{\"密钥序号\":\"KeiIY8098435rty\",\"时间戳\":\"2020-12-31T05:43:21CST\",\"版本\":1,\"签名方法\":\"HmacSHA256\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{\"id\":\"yw\"},\"msg\":\"D3Y\"}},{\"resp\":{\"code\":17,\"data\":{\"新增后，权限用户组id\":\"b4isGakqSG\"},\"msg\":\"cndS8bZcqAx\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generate at 2021-11-10T14:05:39CST\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/create\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_create\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"},\"description\":{\"type\":\"string\"}},\"required\":[]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"新增后，权限用户组id\"}}},\"msg\":{\"type\":\"string\"}},\"required\":[\"code\"]}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"创建用户组\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none','2021-11-10 14:05:24','2021-11-10 14:05:41',NULL),
('raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n','system','系统','/system/form','base_pergroup_update','','给用户组加入人员或者部门','','last','/api/v1/structor/:appID/base/permission/perGroup/update','http://structor/api/v1/structor/:appID/base/permission/perGroup/update','','POST','{\"x-id\":\"raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/update\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"给用户组加入人员或者部门\",\"desc\":\"\"}','{\"x-id\":\"\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/raw/request/system/form/base_pergroup_update\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"Signature\",\"title\":\"参数签名\",\"desc\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"data\":null,\"in\":\"header\",\"mock\":\"J834jkhwrwkkjhkYIUYU9886876387\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2\",\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"data\":\"application/json\",\"in\":\"header\",\"required\":true,\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"data\":null,\"in\":\"path\",\"required\":true},{\"type\":\"object\",\"name\":\"root\",\"data\":[{\"type\":\"object\",\"name\":\"_signature\",\"title\":\"签名参数\",\"desc\":\"signature paramters of poly api server\",\"data\":[{\"type\":\"timestamp\",\"name\":\"timestamp\",\"title\":\"时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"data\":null},{\"type\":\"number\",\"name\":\"version\",\"title\":\"版本\",\"desc\":\"1 only current\",\"data\":\"1\"},{\"type\":\"string\",\"name\":\"method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"data\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"access_key_id\",\"title\":\"密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"data\":\"KeiIY8098435rty\"}]},{\"type\":\"string\",\"name\":\"id\",\"desc\":\"用户组权限id\",\"data\":null},{\"type\":\"array\",\"name\":\"scopes\",\"data\":[{\"type\":\"object\",\"name\":\"\",\"data\":[{\"type\":\"number\",\"name\":\"type\",\"desc\":\"1 人员 2 部门\",\"data\":null},{\"type\":\"string\",\"name\":\"id\",\"desc\":\"人员或者部门id\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"desc\":\"人员或者部门名字\",\"data\":null}]}]}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"Signature\":[\"J834jkhwrwkkjhkYIUYU9886876387\"]},\"body\":{\"_hide\":{\"appID\":\"qy\"},\"_signature\":{\"access_key_id\":\"KeiIY8098435rty\",\"method\":\"HmacSHA256\",\"timestamp\":\"2020-12-31T05:43:21CST\",\"version\":1},\"id\":\"Xi7\",\"scopes\":[{\"id\":\"wSV\",\"name\":\"voq9RePDc\",\"type\":1}]}},{\"header\":{\"参数签名\":[\"J834jkhwrwkkjhkYIUYU9886876387\"],\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"]},\"body\":{\"_hide\":{\"appID\":\"LWJDq3n08h\"},\"scopes\":[{\"1 人员 2 部门\":9,\"人员或者部门id\":\"F8Nixa\",\"人员或者部门名字\":\"aoPbs3xIh\"}],\"用户组权限id\":\"rQfaczv6\",\"签名参数\":{\"密钥序号\":\"KeiIY8098435rty\",\"时间戳\":\"2020-12-31T05:43:21CST\",\"版本\":1,\"签名方法\":\"HmacSHA256\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":0,\"data\":{},\"msg\":\"IOt0SF7a_P\"}},{\"resp\":{\"code\":14,\"data\":{},\"msg\":\"9TTVavSr\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generate at 2021-11-10T14:05:39CST\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/update\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_update\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"type\":\"object\",\"title\":\"empty object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"用户组权限id\"},\"scopes\":{\"type\":\"array\",\"items\":{\"type\":\"object\",\"properties\":{\"type\":{\"type\":\"integer\",\"description\":\"1 人员 2 部门\"},\"id\":{\"type\":\"string\",\"description\":\"人员或者部门id\"},\"name\":{\"type\":\"string\",\"description\":\"人员或者部门名字\"}},\"required\":[\"type\",\"id\",\"name\"]}}},\"required\":[\"id\",\"scopes\"]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{}},\"msg\":{\"type\":\"string\"}}}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"给用户组加入人员或者部门\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none','2021-11-10 14:05:22','2021-11-10 14:05:40',NULL);

/*v0.7.2*/

ALTER TABLE `api_poly` MODIFY COLUMN `desc` text;
ALTER TABLE `api_raw` MODIFY COLUMN `desc` text;
ALTER TABLE `api_namespace` MODIFY COLUMN `desc` text;
ALTER TABLE `api_service` MODIFY COLUMN `desc` text;
ALTER TABLE `api_permit_group` MODIFY COLUMN `desc` text;
ALTER TABLE `api_permit_elem` MODIFY COLUMN `desc` text;
ALTER TABLE `api_permit_grant` MODIFY COLUMN `desc` text;

/*Data for the table `api_poly` */

REPLACE  into `api_poly`(`id`,`owner`,`owner_name`,`namespace`,`name`,`title`,`desc`,`access`,`active`,`valid`,`method`,`arrange`,`doc`,`script`,`create_at`,`update_at`,`build_at`,`delete_at`) values
('poly_ABIJPi2ckYlIKgMEKiTbFDw0CCpLxLLvf1_eSzIS4S_p','system','系统','/system/poly','permissionInit','应用初始化','',3,1,1,'POST','{}','{\"x-id\":\"\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/poly/request/system/poly/permissionInit\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"Signature\",\"title\":\"参数签名\",\"desc\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"data\":null,\"in\":\"header\",\"mock\":\"J834jkhwrwkkjhkYIUYU9886876387\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2\",\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"data\":\"application/json\",\"in\":\"header\",\"required\":true,\"mock\":\"application/json\"},{\"type\":\"object\",\"name\":\"root\",\"desc\":\"body inputs\",\"data\":[{\"type\":\"object\",\"name\":\"_signature\",\"title\":\"签名参数\",\"desc\":\"signature paramters of poly api server\",\"data\":[{\"type\":\"timestamp\",\"name\":\"timestamp\",\"title\":\"时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"data\":null},{\"type\":\"number\",\"name\":\"version\",\"title\":\"版本\",\"desc\":\"1 only current\",\"data\":\"1\"},{\"type\":\"string\",\"name\":\"method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"data\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"access_key_id\",\"title\":\"密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"data\":\"KeiIY8098435rty\"}]},{\"type\":\"object\",\"name\":\"_signature\",\"desc\":\"signature paramters of poly api server\",\"data\":[{\"type\":\"string\",\"name\":\"access_key_id\",\"desc\":\"access_key_id dispatched by poly api server\",\"data\":null},{\"type\":\"string\",\"name\":\"method\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"data\":null},{\"type\":\"string\",\"name\":\"timestamp\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"data\":null},{\"type\":\"number\",\"name\":\"version\",\"desc\":\"1 only current\",\"data\":null}]},{\"type\":\"string\",\"name\":\"appID\",\"data\":null},{\"type\":\"string\",\"name\":\"description\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"data\":null},{\"type\":\"array\",\"name\":\"scopes\",\"data\":[{\"type\":\"object\",\"name\":\"\",\"data\":[{\"type\":\"number\",\"name\":\"type\",\"data\":null},{\"type\":\"string\",\"name\":\"id\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"data\":null}]}]},{\"type\":\"string\",\"name\":\"types\",\"data\":null}],\"in\":\"body\"},{\"type\":\"string\",\"name\":\"Signature\",\"desc\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"data\":null,\"in\":\"header\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"desc\":\"Access-Token from oauth2\",\"data\":null,\"in\":\"header\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"desc\":\"application/json\",\"data\":null,\"in\":\"header\",\"required\":true}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"data\":[{\"type\":\"object\",\"name\":\"data\",\"desc\":\"body response\",\"data\":[]},{\"type\":\"string\",\"name\":\"msg\",\"title\":\"error message when code is not 0\",\"data\":null},{\"type\":\"number\",\"name\":\"code\",\"title\":\"0:success, others: error\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\",\"iuXsnOqNgy\"],\"Content-Type\":[\"application/json\",\"0qhEjJSOIn\"],\"Signature\":[\"J834jkhwrwkkjhkYIUYU9886876387\",\"yiSTDhmGFk\"]},\"body\":{\"_signature\":{\"access_key_id\":\"x1yW\",\"method\":\"9C\",\"timestamp\":\"lfSBcyq3NI\",\"version\":11},\"appID\":\"RyapSk\",\"description\":\"xhRtB\",\"name\":\"1olev\",\"scopes\":[{\"id\":\"hDVVd\",\"name\":\"bHXjBliu2AB\",\"type\":19}],\"types\":\"BYSdW\"}},{\"header\":{\"Access-Token from oauth2\":[\"X_RmLh-3ie\"],\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\":[\"Ra9ToOePEs\"],\"application/json\":[\"gjPn6uaWuL\"],\"参数签名\":[\"J834jkhwrwkkjhkYIUYU9886876387\"],\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"]},\"body\":{\"appID\":\"M37\",\"description\":\"5tj4\",\"name\":\"1_L_ZigRy\",\"scopes\":[{\"id\":\"b7pz\",\"name\":\"ni\",\"type\":19}],\"signature paramters of poly api server\":{\"\\\"HmacSHA256\\\" only current\":\"XygCVdA\",\"1 only current\":0,\"access_key_id dispatched by poly api server\":\"2H\",\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\":\"Md0i-iRy\"},\"types\":\"mlqji8JE-\",\"签名参数\":{\"密钥序号\":\"KeiIY8098435rty\",\"时间戳\":\"2020-12-31T05:43:21CST\",\"版本\":1,\"签名方法\":\"HmacSHA256\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":12,\"data\":{},\"msg\":\"02UhWgS-t\"}},{\"resp\":{\"0:success, others: error\":1,\"body response\":{},\"error message when code is not 0\":\"dw2G6r2\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"polyapi\",\"swagger\":\"2.0\",\"info\":{\"title\":\"polyapi\",\"version\":\"v1.0.0\",\"description\":\"auto generate at 2021-11-20T09:32:40CST\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/polyapi/poly/request//system/poly/permissionInit\":{\"post\":{\"x-consts\":[{\"type\":\"array\",\"name\":\"_\",\"data\":[{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app\',start.appID,\'应用\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID,\'poly\',\'API编排\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID,\'raw\',\'原生API\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID+\'/raw\',\'customer\',\'代理第三方API\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID+\'/raw\',\'inner\',\'平台API\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID+\'/raw/inner\',\'form\',\'表单模型API\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID+\'/raw/inner/form\',\'form\',\'表单API\')\"},{\"type\":\"direct_expr\",\"name\":\"\",\"data\":\"pdCreateNS(\'/system/app/\'+start.appID+\'/raw/inner/form\',\'custom\',\'模型API\')\"}],\"in\":\"\"}],\"operationId\":\"permissionInit\",\"parameters\":[{\"description\":\"body inputs\",\"in\":\"body\",\"name\":\"root\",\"schema\":{\"properties\":{\"_signature\":{\"description\":\"signature paramters of poly api server\",\"properties\":{\"access_key_id\":{\"description\":\"access_key_id dispatched by poly api server\",\"type\":\"string\"},\"method\":{\"description\":\"\\\"HmacSHA256\\\" only current\",\"type\":\"string\"},\"timestamp\":{\"description\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"type\":\"string\"},\"version\":{\"description\":\"1 only current\",\"type\":\"number\"}},\"type\":\"object\"},\"appID\":{\"tile\":\"应用ID\",\"type\":\"string\"},\"description\":{\"tile\":\"应用描述\",\"type\":\"string\"},\"name\":{\"tile\":\"应用名\",\"type\":\"string\"},\"scopes\":{\"items\":{\"properties\":{\"id\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"type\":{\"type\":\"number\"}},\"type\":\"object\"},\"type\":\"array\"},\"types\":{\"tile\":\"应用描述\",\"type\":\"string\"}},\"required\":[\"appID\",\"name\",\"scopes\"],\"type\":\"object\"}},{\"description\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"in\":\"header\",\"name\":\"Signature\",\"type\":\"string\"},{\"description\":\"Access-Token from oauth2\",\"in\":\"header\",\"name\":\"Access-Token\",\"type\":\"string\"},{\"description\":\"application/json\",\"in\":\"header\",\"name\":\"Content-Type\",\"required\":true,\"type\":\"string\"}],\"responses\":{\"200\":{\"description\":\"\",\"schema\":{\"description\":\"response schema.\",\"properties\":{\"code\":{\"title\":\"0:success, others: error\",\"type\":\"number\"},\"data\":{\"description\":\"body response\",\"properties\":{},\"type\":\"object\"},\"msg\":{\"title\":\"error message when code is not 0\",\"type\":\"string\"}},\"type\":\"object\"},\"headers\":{}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"permissionInit\",\"description\":\"structor permissionInit\"}}}}}','// qyTmpScript_/system/poly/permissionInit_permissionInit_2021-11-20T09:32:39CST\nvar _tmp = function(){\n  var d = { \"__input\": __input, } // qyAllLocalData\n\n  d.start = __input.body\n\n  d.start.header = d.start.header || {}\n  d.start._ = [\n    pdCreateNS(\'/system/app\',d.start.appID,\'应用\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'poly\',\'API编排\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'raw\',\'原生API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw\',\'customer\',\'代理第三方API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw\',\'inner\',\'平台API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner\',\'form\',\'表单模型API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner/form\',\'form\',\'表单API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner/form\',\'custom\',\'模型API\'),\n  ]\n  if (true) { // req1, create\n    var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/create\" ,d.start.appID)\n    var _t = {\n        \"name\": d.start.name,\n        \"description\": d.start.description,\n        \"types\": d.start.types,\n      }\n    var _th = pdNewHttpHeader()\n    pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n    var _tk = \'\';\n    var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n    d.req1 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n  }\n  d.cond1 = { y: false, }\n  if (d.req1.code==0) {\n    d.cond1.y = true\n    if (true) { // req2, update\n      var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/update\" ,d.start.appID)\n      var _t = {\n          \"id\": d.req1.data.id,\n          \"scopes\": d.start.scopes,\n        }\n      var _th = pdNewHttpHeader()\n      pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n      var _tk = \'\';\n      var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n      d.req2 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n    }\n  }\n\n  d.end = {\n    \"createNamespaces\": d.start._,\n    \"req1\": d.req1,\n    \"req2\": sel(d.cond1.y,d.req2,undefined),\n  }\n  return pdToJsonP(d.end)\n}; _tmp();\n','2021-11-20 09:32:29','2021-11-20 09:32:42','2021-11-20 09:32:41',NULL);

/*Data for the table `api_raw` */

REPLACE  into `api_raw`(`id`,`owner`,`owner_name`,`namespace`,`name`,`service`,`title`,`desc`,`version`,`path`,`url`,`action`,`method`,`content`,`doc`,`access`,`active`,`valid`,`schema`,`host`,`auth_type`,`create_at`,`update_at`,`delete_at`) values
('raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R','system','系统','/system/form','base_pergroup_create','','创建用户组','','last','/api/v1/structor/:appID/base/permission/perGroup/create','http://structor/api/v1/structor/:appID/base/permission/perGroup/create','','POST','{\"x-id\":\"raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/create\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"创建用户组\",\"desc\":\"\"}','{\"x-id\":\"\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/raw/request/system/form/base_pergroup_create\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"Signature\",\"title\":\"参数签名\",\"desc\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"data\":null,\"in\":\"header\",\"mock\":\"J834jkhwrwkkjhkYIUYU9886876387\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2\",\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"data\":\"application/json\",\"in\":\"header\",\"required\":true,\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"data\":null,\"in\":\"path\",\"required\":true},{\"type\":\"object\",\"name\":\"root\",\"data\":[{\"type\":\"object\",\"name\":\"_signature\",\"title\":\"签名参数\",\"desc\":\"signature paramters of poly api server\",\"data\":[{\"type\":\"timestamp\",\"name\":\"timestamp\",\"title\":\"时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"data\":null},{\"type\":\"number\",\"name\":\"version\",\"title\":\"版本\",\"desc\":\"1 only current\",\"data\":\"1\"},{\"type\":\"string\",\"name\":\"method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"data\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"access_key_id\",\"title\":\"密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"data\":\"KeiIY8098435rty\"}]},{\"type\":\"string\",\"name\":\"name\",\"data\":null},{\"type\":\"string\",\"name\":\"description\",\"data\":null}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"新增后，权限用户组id\",\"data\":null}]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"Signature\":[\"J834jkhwrwkkjhkYIUYU9886876387\"]},\"body\":{\"_hide\":{\"appID\":\"5X\"},\"_signature\":{\"access_key_id\":\"KeiIY8098435rty\",\"method\":\"HmacSHA256\",\"timestamp\":\"2020-12-31T05:43:21CST\",\"version\":1},\"description\":\"ShQ\",\"name\":\"F75\"}},{\"header\":{\"参数签名\":[\"J834jkhwrwkkjhkYIUYU9886876387\"],\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"]},\"body\":{\"_hide\":{\"appID\":\"0ciAEDhUfP\"},\"description\":\"4LTKK4dp\",\"name\":\"WG2lQSAaEW\",\"签名参数\":{\"密钥序号\":\"KeiIY8098435rty\",\"时间戳\":\"2020-12-31T05:43:21CST\",\"版本\":1,\"签名方法\":\"HmacSHA256\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{\"id\":\"t7dlp9Spy\"},\"msg\":\"sC\"}},{\"resp\":{\"code\":9,\"data\":{\"新增后，权限用户组id\":\"YM4anF\"},\"msg\":\"v61XiERsW\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generate at 2021-11-20T09:32:16CST\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/create\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_create\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"},\"description\":{\"type\":\"string\"}},\"required\":[]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"新增后，权限用户组id\"}}},\"msg\":{\"type\":\"string\"}},\"required\":[\"code\"]}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"创建用户组\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none','2021-11-20 09:32:17','2021-11-20 09:32:17',NULL),
('raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n','system','系统','/system/form','base_pergroup_update','','给用户组加入人员或者部门','','last','/api/v1/structor/:appID/base/permission/perGroup/update','http://structor/api/v1/structor/:appID/base/permission/perGroup/update','','POST','{\"x-id\":\"raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/update\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"给用户组加入人员或者部门\",\"desc\":\"\"}','{\"x-id\":\"\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/raw/request/system/form/base_pergroup_update\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"Signature\",\"title\":\"参数签名\",\"desc\":\"HmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\\neg: \\n_signature.key_id=ACCESS_KEY_ID\\u0026_signature.method=HmacSHA256\\u0026_signature.timestamp=2021-06-25T16%3A12%3A34%2B0800\\u0026_signature.version=1\\u0026action.1=foo\\u0026action.2=bar\\u0026age=18\\u0026name=bob\\nxRls5M1li+XrZKiJFn60cW5rd3+n4uzZCPxukRkWM7A=\\n\",\"data\":null,\"in\":\"header\",\"mock\":\"J834jkhwrwkkjhkYIUYU9886876387\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2\",\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"data\":\"application/json\",\"in\":\"header\",\"required\":true,\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"data\":null,\"in\":\"path\",\"required\":true},{\"type\":\"object\",\"name\":\"root\",\"data\":[{\"type\":\"object\",\"name\":\"_signature\",\"title\":\"签名参数\",\"desc\":\"signature paramters of poly api server\",\"data\":[{\"type\":\"timestamp\",\"name\":\"timestamp\",\"title\":\"时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"data\":null},{\"type\":\"number\",\"name\":\"version\",\"title\":\"版本\",\"desc\":\"1 only current\",\"data\":\"1\"},{\"type\":\"string\",\"name\":\"method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"data\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"access_key_id\",\"title\":\"密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"data\":\"KeiIY8098435rty\"}]},{\"type\":\"string\",\"name\":\"id\",\"desc\":\"用户组权限id\",\"data\":null},{\"type\":\"array\",\"name\":\"scopes\",\"data\":[{\"type\":\"object\",\"name\":\"\",\"data\":[{\"type\":\"number\",\"name\":\"type\",\"desc\":\"1 人员 2 部门\",\"data\":null},{\"type\":\"string\",\"name\":\"id\",\"desc\":\"人员或者部门id\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"desc\":\"人员或者部门名字\",\"data\":null}]}]}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"Signature\":[\"J834jkhwrwkkjhkYIUYU9886876387\"]},\"body\":{\"_hide\":{\"appID\":\"8ZVpAr\"},\"_signature\":{\"access_key_id\":\"KeiIY8098435rty\",\"method\":\"HmacSHA256\",\"timestamp\":\"2020-12-31T05:43:21CST\",\"version\":1},\"id\":\"TijjAlSN\",\"scopes\":[{\"id\":\"woZz5\",\"name\":\"uhJcsOhhSc\",\"type\":15}]}},{\"header\":{\"参数签名\":[\"J834jkhwrwkkjhkYIUYU9886876387\"],\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"]},\"body\":{\"_hide\":{\"appID\":\"hnc\"},\"scopes\":[{\"1 人员 2 部门\":16,\"人员或者部门id\":\"S5Y\",\"人员或者部门名字\":\"WfdVSPEm8\"}],\"用户组权限id\":\"57gOi\",\"签名参数\":{\"密钥序号\":\"KeiIY8098435rty\",\"时间戳\":\"2020-12-31T05:43:21CST\",\"版本\":1,\"签名方法\":\"HmacSHA256\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{},\"msg\":\"Fk\"}},{\"resp\":{\"code\":18,\"data\":{},\"msg\":\"HAVMzxobCzq\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generate at 2021-11-20T09:32:16CST\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/update\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_update\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"type\":\"object\",\"title\":\"empty object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"用户组权限id\"},\"scopes\":{\"type\":\"array\",\"items\":{\"type\":\"object\",\"properties\":{\"type\":{\"type\":\"integer\",\"description\":\"1 人员 2 部门\"},\"id\":{\"type\":\"string\",\"description\":\"人员或者部门id\"},\"name\":{\"type\":\"string\",\"description\":\"人员或者部门名字\"}},\"required\":[\"type\",\"id\",\"name\"]}}},\"required\":[\"id\",\"scopes\"]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{}},\"msg\":{\"type\":\"string\"}}}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"给用户组加入人员或者部门\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none','2021-11-20 09:32:19','2021-11-20 09:32:19',NULL);

DELIMITER $$
DROP PROCEDURE IF EXISTS `fix_app_path` $$
CREATE PROCEDURE fix_app_path()
BEGIN
    DECLARE  app_id VARCHAR(255);
    DECLARE tm DATETIME;
    DECLARE sid INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_app CURSOR FOR SELECT `namespace` FROM api_namespace WHERE `parent` = '/system/app';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

DELETE FROM `api_namespace` WHERE `parent` REGEXP '^/system/app/[-a-zA-Z0-9]+(/raw)?$' AND `namespace` IN ('raw','inner');

SET tm=NOW();
    SET sid=1;
OPEN cur_app;
app_loop: LOOP
        FETCH cur_app INTO app_id;
        IF done THEN
            LEAVE app_loop;
END IF;
INSERT  INTO `api_namespace`(`id`,`owner`,`owner_name`,`parent`,`namespace`,`title`,`desc`,`access`,`active`,`create_at`,`update_at`,`delete_at`) VALUES
                                                                                                                                                      (CONCAT(tm,'_',sid),'system','系统',CONCAT('/system/app/',app_id),'raw','原生API','原生API',0,1,NOW(),NOW(),NULL),
                                                                                                                                                      (CONCAT(tm,'_',sid+1),'system','系统',CONCAT('/system/app/',app_id,'/raw'),'inner','平台API','平台API',0,1,NOW(),NOW(),NULL);
SET sid=sid+2;
END LOOP app_loop;
CLOSE cur_app;

DELETE FROM `api_namespace` WHERE `namespace`='faas' AND `parent` != '/system';
DELETE FROM `api_namespace` WHERE `parent` LIKE '%/structor%' OR `namespace` LIKE '%structor%';
DELETE FROM `api_raw` WHERE `namespace` LIKE '%/structor%';

UPDATE `api_namespace` SET `parent`=CONCAT(`parent`,'/raw') WHERE parent REGEXP '^/system/app/[-a-zA-Z0-9]+$' AND `namespace`='customer';
UPDATE `api_namespace` SET `parent`=CONCAT(`parent`,'/raw/inner') WHERE parent REGEXP '^/system/app/[-a-zA-Z0-9]+$' AND `namespace`='form';
UPDATE `api_namespace` SET `parent`=INSERT(`parent`,LOCATE('/form',`parent`),CHAR_LENGTH('/form'),'/raw/inner/form') WHERE `parent` REGEXP '^/system/app/[-a-zA-Z0-9]+/form.*$';
UPDATE `api_namespace` SET `parent`=INSERT(`parent`,LOCATE('/customer',`parent`),CHAR_LENGTH('/customer'),'/raw/customer')  WHERE `parent` REGEXP '^/system/app/[-a-zA-Z0-9]+/customer.*$';

UPDATE `api_namespace` SET `sub_count`=0;
UPDATE `api_namespace` u,
    (SELECT `parent`, COUNT(1) cnt FROM `api_namespace` GROUP BY `parent`) t
SET u.`sub_count`=t.`cnt` WHERE CONCAT(u.`parent`,'/',u.`namespace`)=t.`parent`;
UPDATE `api_namespace` u,
    (SELECT `parent`, COUNT(1) cnt FROM `api_namespace` GROUP BY `parent`) t
SET u.`sub_count`=t.`cnt` WHERE CONCAT('/',u.`namespace`)=t.`parent`;

UPDATE `api_service` SET `namespace`=INSERT(`namespace`,LOCATE('/customer',`namespace`),CHAR_LENGTH('/customer'),'/raw/customer')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/customer.*$';
UPDATE `api_raw` SET `service`=INSERT(`service`,LOCATE('/customer',`service`),CHAR_LENGTH('/customer'),'/raw/customer')  WHERE `service` REGEXP '^/system/app/[-a-zA-Z0-9]+/customer.*$';
UPDATE `api_raw` SET `namespace`=INSERT(`namespace`,LOCATE('/customer',`namespace`),CHAR_LENGTH('/customer'),'/raw/customer')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/customer.*$';
UPDATE `api_raw` SET `namespace`=INSERT(`namespace`,LOCATE('/form',`namespace`),CHAR_LENGTH('/form'),'/raw/inner/form') WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/form.*$';

UPDATE  `api_raw` SET `doc`=REPLACE(`doc`,'/customer/','/raw/customer/')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/raw/customer.*$';
UPDATE  `api_raw` SET `doc`=REPLACE(`doc`,'/form/form/','/raw/inner/form/form/')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/raw/inner/form/form.*$';
UPDATE  `api_raw` SET `doc`=REPLACE(`doc`,'/form/custom/','/raw/inner/form/custom/')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/raw/inner/form/custom.*$';
UPDATE  `api_raw` SET `doc`=REPLACE(`doc`,'/raw/inner/raw/inner/','/raw/inner/')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/raw/inner/form.*$';
UPDATE  `api_raw` SET `doc`=REPLACE(`doc`,'/raw/raw/','/raw/')  WHERE `namespace` REGEXP '^/system/app/[-a-zA-Z0-9]+/raw/customer.*$';

UPDATE `api_raw_poly` SET `raw_api`=INSERT(`raw_api`,LOCATE('/customer',`raw_api`),CHAR_LENGTH('/customer'),'/raw/customer')  WHERE `raw_api` REGEXP '^/system/app/[-a-zA-Z0-9]+/customer.*$';
END;
$$
DELIMITER ;
CALL fix_app_path();
DROP PROCEDURE IF EXISTS `fix_app_path`;

/*v0.7.3*/

/*
SQLyog Community
MySQL - 5.7.36-0ubuntu0.18.04.1 : Database - allytest
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Data for the table `api_poly` */

DELETE FROM `api_poly` WHERE `namespace`='/system/poly';
DELETE FROM `api_raw` WHERE `namespace`='/system/form';

/*Data for the table `api_poly` */

REPLACE  into `api_poly`(`id`,`owner`,`owner_name`,`namespace`,`name`,`title`,`desc`,`access`,`active`,`valid`,`method`,`arrange`,`doc`,`script`,`create_at`,`update_at`,`build_at`,`delete_at`) values
('poly_AAxfxhEZG2epwoUU1cmAYIKZGyq_xFs3llI4eJcXKMVG','system','系统','/system/poly','permissionInit.p','应用初始化','',0,1,1,'POST','{}','{}','// polyTmpScript_/system/poly/permissionInit.p_2021-12-29T10:12:35CST\nvar _tmp = function(){\n  var d = { \"__input\": __input, } // qyAllLocalData\n\n  d.start = __input.body\n\n  d.start.header = d.start.header || {}\n  d.start._ = [\n    pdCreateNS(\'/system/app\',d.start.appID,\'应用\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'poly\',\'API编排\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'raw\',\'原生API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw\',\'customer\',\'代理第三方API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw\',\'inner\',\'平台API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner\',\'form\',\'表单模型API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner/form\',\'form\',\'表单API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner/form\',\'custom\',\'模型API\'),\n  ]\n  if (true) { // req1, create\n    var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/create\" ,d.start.appID)\n    var _t = {\n        \"name\": d.start.name,\n        \"description\": d.start.description,\n        \"types\": d.start.types,\n      }\n    var _th = pdNewHttpHeader()\n    pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n    var _tk = \'\';\n    var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n    d.req1 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n  }\n  d.cond1 = { y: false, }\n  if (d.req1.code==0) {\n    d.cond1.y = true\n    if (true) { // req2, update\n      var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/update\" ,d.start.appID)\n      var _t = {\n          \"id\": d.req1.data.id,\n          \"scopes\": d.start.scopes,\n        }\n      var _th = pdNewHttpHeader()\n      pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n      var _tk = \'\';\n      var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n      d.req2 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n    }\n  }\n\n  d.end = {\n    \"createNamespaces\": d.start._,\n    \"req1\": d.req1,\n    \"req2\": sel(d.cond1.y,d.req2,undefined),\n  }\n  return pdToJsonP(d.end)\n}; _tmp();\n','2021-12-29 10:12:33','2021-12-29 10:12:38','2021-12-29 10:12:40',NULL);

/*Data for the table `api_raw` */

REPLACE  into `api_raw`(`id`,`owner`,`owner_name`,`namespace`,`name`,`service`,`title`,`desc`,`version`,`path`,`url`,`action`,`method`,`content`,`doc`,`access`,`active`,`valid`,`schema`,`host`,`auth_type`,`create_at`,`update_at`,`delete_at`) values
('raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R','system','系统','/system/form','base_pergroup_create.r','','创建用户组','','last','/api/v1/structor/:appID/base/permission/perGroup/create','http://structor/api/v1/structor/:appID/base/permission/perGroup/create','','POST','{\"x-id\":\"raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/create\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"创建用户组\",\"desc\":\"\"}','{\"x-id\":\"\",\"version\":\"v0.7.3(2021-12-21@20e03e7)\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/request/system/form/base_pergroup_create.r\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"X-Polysign-Access-Key-Id\",\"title\":\"签名密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"$appendix$\":true,\"data\":\"KeiIY8098435rty\",\"in\":\"header\",\"mock\":\"KeiIY8098435rty\"},{\"type\":\"string\",\"name\":\"X-Polysign-Timestamp\",\"title\":\"签名时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"$appendix$\":true,\"data\":\"2020-12-31T12:34:56+0800\",\"in\":\"header\",\"mock\":\"2020-12-31T12:34:56+0800\"},{\"type\":\"string\",\"name\":\"X-Polysign-Version\",\"title\":\"签名版本\",\"desc\":\"\\\"1\\\" only current\",\"$appendix$\":true,\"data\":\"1\",\"in\":\"header\",\"mock\":\"1\"},{\"type\":\"string\",\"name\":\"X-Polysign-Method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"$appendix$\":true,\"data\":\"HmacSHA256\",\"in\":\"header\",\"mock\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2 if use token access mode\",\"$appendix$\":true,\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"required\":true,\"data\":\"application/json\",\"in\":\"header\",\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"required\":true,\"data\":null,\"in\":\"path\"},{\"type\":\"object\",\"name\":\"root\",\"data\":[{\"type\":\"string\",\"name\":\"description\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"data\":null},{\"type\":\"string\",\"name\":\"x_polyapi_signature\",\"title\":\"参数签名\",\"desc\":\"required if Access-Token doesn\'t use.\\nHmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\",\"$appendix$\":true,\"data\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"},{\"type\":\"object\",\"name\":\"$polyapi_hide$\",\"title\":\"隐藏参数\",\"desc\":\"polyapi reserved hide args like path args in raw api.\",\"$appendix$\":true,\"data\":[]}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"新增后，权限用户组id\",\"data\":null}]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"X-Polysign-Access-Key-Id\":[\"KeiIY8098435rty\"],\"X-Polysign-Method\":[\"HmacSHA256\"],\"X-Polysign-Timestamp\":[\"2020-12-31T12:34:56+0800\"],\"X-Polysign-Version\":[\"1\"]},\"body\":{\"$polyapi_hide$\":{\"appID\":\"K8\"},\"description\":\"tj5\",\"name\":\"9IM\",\"x_polyapi_signature\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"}},{\"header\":{\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"],\"签名密钥序号\":[\"KeiIY8098435rty\"],\"签名方法\":[\"HmacSHA256\"],\"签名时间戳\":[\"2020-12-31T12:34:56+0800\"],\"签名版本\":[\"1\"]},\"body\":{\"description\":\"UsW5lqZpuh\",\"name\":\"XiVkxuQv\",\"参数签名\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\",\"隐藏参数\":{\"appID\":\"b3JJvXJKGM\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{\"id\":\"pM05RAVyQ\"},\"msg\":\"hC\"}},{\"resp\":{\"code\":9,\"data\":{\"id\":\"JHIf5c\"},\"msg\":\"c6CQ7Vhaw\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generated\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/create\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_create\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"},\"description\":{\"type\":\"string\"}},\"required\":[]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"新增后，权限用户组id\"}}},\"msg\":{\"type\":\"string\"}},\"required\":[\"code\"]}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"创建用户组\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none','2021-12-29 10:12:30','2021-12-29 10:12:30',NULL),
('raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n','system','系统','/system/form','base_pergroup_update.r','','给用户组加入人员或者部门','','last','/api/v1/structor/:appID/base/permission/perGroup/update','http://structor/api/v1/structor/:appID/base/permission/perGroup/update','','POST','{\"x-id\":\"raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/update\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"给用户组加入人员或者部门\",\"desc\":\"\"}','{\"x-id\":\"\",\"version\":\"v0.7.3(2021-12-21@20e03e7)\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/request/system/form/base_pergroup_update.r\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"X-Polysign-Access-Key-Id\",\"title\":\"签名密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"$appendix$\":true,\"data\":\"KeiIY8098435rty\",\"in\":\"header\",\"mock\":\"KeiIY8098435rty\"},{\"type\":\"string\",\"name\":\"X-Polysign-Timestamp\",\"title\":\"签名时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"$appendix$\":true,\"data\":\"2020-12-31T12:34:56+0800\",\"in\":\"header\",\"mock\":\"2020-12-31T12:34:56+0800\"},{\"type\":\"string\",\"name\":\"X-Polysign-Version\",\"title\":\"签名版本\",\"desc\":\"\\\"1\\\" only current\",\"$appendix$\":true,\"data\":\"1\",\"in\":\"header\",\"mock\":\"1\"},{\"type\":\"string\",\"name\":\"X-Polysign-Method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"$appendix$\":true,\"data\":\"HmacSHA256\",\"in\":\"header\",\"mock\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2 if use token access mode\",\"$appendix$\":true,\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"required\":true,\"data\":\"application/json\",\"in\":\"header\",\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"required\":true,\"data\":null,\"in\":\"path\"},{\"type\":\"object\",\"name\":\"root\",\"title\":\"empty object\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"用户组权限id\",\"data\":null},{\"type\":\"array\",\"name\":\"scopes\",\"data\":[{\"type\":\"object\",\"name\":\"\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"人员或者部门id\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"desc\":\"人员或者部门名字\",\"data\":null},{\"type\":\"number\",\"name\":\"type\",\"desc\":\"1 人员 2 部门\",\"data\":null}]}]},{\"type\":\"string\",\"name\":\"x_polyapi_signature\",\"title\":\"参数签名\",\"desc\":\"required if Access-Token doesn\'t use.\\nHmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\",\"$appendix$\":true,\"data\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"},{\"type\":\"object\",\"name\":\"$polyapi_hide$\",\"title\":\"隐藏参数\",\"desc\":\"polyapi reserved hide args like path args in raw api.\",\"$appendix$\":true,\"data\":[]}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"X-Polysign-Access-Key-Id\":[\"KeiIY8098435rty\"],\"X-Polysign-Method\":[\"HmacSHA256\"],\"X-Polysign-Timestamp\":[\"2020-12-31T12:34:56+0800\"],\"X-Polysign-Version\":[\"1\"]},\"body\":{\"$polyapi_hide$\":{\"appID\":\"Yy0-yO\"},\"id\":\"yUDfG7Bp\",\"scopes\":[{\"id\":\"8UUEG_S\",\"name\":\"nQoLc\",\"type\":8}],\"x_polyapi_signature\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"}},{\"header\":{\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"],\"签名密钥序号\":[\"KeiIY8098435rty\"],\"签名方法\":[\"HmacSHA256\"],\"签名时间戳\":[\"2020-12-31T12:34:56+0800\"],\"签名版本\":[\"1\"]},\"body\":{\"id\":\"-rFaW\",\"scopes\":[{\"id\":\"GKj0k7EJ\",\"name\":\"QO7\",\"type\":17}],\"参数签名\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\",\"隐藏参数\":{\"appID\":\"OZI\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{},\"msg\":\"YW\"}},{\"resp\":{\"code\":18,\"data\":{},\"msg\":\"rDhpCYscAuK\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generated\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/update\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_update\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"type\":\"object\",\"title\":\"empty object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"用户组权限id\"},\"scopes\":{\"type\":\"array\",\"items\":{\"type\":\"object\",\"properties\":{\"type\":{\"type\":\"integer\",\"description\":\"1 人员 2 部门\"},\"id\":{\"type\":\"string\",\"description\":\"人员或者部门id\"},\"name\":{\"type\":\"string\",\"description\":\"人员或者部门名字\"}},\"required\":[\"type\",\"id\",\"name\"]}}},\"required\":[\"id\",\"scopes\"]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{}},\"msg\":{\"type\":\"string\"}}}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"给用户组加入人员或者部门\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none','2021-12-29 10:12:31','2021-12-29 10:12:31',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

DROP TABLE IF EXISTS `api_schema`;
CREATE TABLE `api_schema` (
    `ID`        VARCHAR(64)     COMMENT 'unique id',
    `namespace` VARCHAR(384)    NOT NULL COMMENT 'belong full namespace, eg: /a/b/c',
    `name`      VARCHAR(64)     NOT NULL COMMENT 'unique name',
    `title`     VARCHAR(64)     COMMENT 'alias of name',
    `desc`      TEXT,
    `schema`    TEXT            NOT NULL COMMENT 'api schema',
    `create_at` DATETIME        COMMENT 'create time',
    `update_at` DATETIME        COMMENT 'update time',
    UNIQUE KEY `idx_global_name` (`namespace`, `name`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

ALTER TABLE `api_raw_poly` ADD COLUMN `delete_at` DATETIME COMMENT 'delete time' AFTER `poly_api`;

ALTER TABLE `api_schema` ADD COLUMN `delete_at` DATETIME COMMENT 'delete time' AFTER `update_at`;

/*v1.0.0*/

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_namespace`;
CREATE TABLE `api_namespace` (
    `id` 		    VARCHAR(64) 	NOT NULL COMMENT 'unique id',
    `owner` 	    VARCHAR(64) 	COMMENT 'owner id',
    `owner_name` 	VARCHAR(64) 	COMMENT 'owner name',
    `parent`        VARCHAR(320) 	NOT NULL DEFAULT '' COMMENT 'full namespace path, eg: /a/b/c',
    `namespace`     VARCHAR(64) 	NOT NULL  COMMENT 'global namespace, inmutable',
    `sub_count`     INT(10) DEFAULT 0 NOT NULL COMMENT 'count of sub namespace',
    `title` 	    VARCHAR(64) 	COMMENT 'alias of namespace, mutable',
    `desc` 		    TEXT,

    `access` 	    INT(11) 	    NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`        TINYINT         DEFAULT 1 COMMENT '1 ok, 0 disable',
    `valid`         TINYINT         DEFAULT 1 COMMENT '1 valid, 0 invalid',

    `create_at`     BIGINT(20) 		COMMENT 'create time',
    `update_at`     BIGINT(20) 		COMMENT 'update time',
    `delete_at`     BIGINT(20) 		COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`parent`, `namespace`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_service`;
CREATE TABLE `api_service` (
    `id` 		    VARCHAR(64) 	COMMENT 'unique id',
    `owner` 	    VARCHAR(64) 	COMMENT 'owner id',
    `owner_name` 	VARCHAR(64) 	COMMENT 'owner name',
    `namespace`     VARCHAR(384) 	NOT NULL COMMENT 'full namespace path, eg: a/b/c',
    `name`	        VARCHAR(64) 	NOT NULL COMMENT 'service name, unique in namespace',
    `title` 	    VARCHAR(64) 	COMMENT 'alias of service, mutable',
    `desc` 		    TEXT,

    `access` 	    INT(11) 	 	NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`        TINYINT         DEFAULT 1 COMMENT '1 ok, 0 disable',
    `schema` 	    VARCHAR(16) 	NOT NULL COMMENT 'http/https',
    `host` 		    VARCHAR(128) 	NOT NULL COMMENT 'eg: api.xxx.com:8080',
    `auth_type`     VARCHAR(32)     NOT NULL COMMENT 'none/system/signature/cookie/oauth2...',
    `authorize`     TEXT            COMMENT 'JSON',

    `create_at`     BIGINT(20) 		COMMENT 'create time',
    `update_at`     BIGINT(20) 		COMMENT 'update time',
    `delete_at`     BIGINT(20) 		COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`, `name`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

REPLACE  INTO `api_namespace`(`id`,`owner`,`owner_name`,`parent`,`namespace`,`title`,`desc`,`access`,`active`,`create_at`,`update_at`,`delete_at`) VALUES
('1','system','系统','-','system','内部系统','系统自动注册的API',0,1,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL),
('1-0','system','系统','/system','poly','内部聚合','内部生成的聚合API',0,1,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL),
('1-1','system','系统','/system','faas','函数服务','通过faas注册的API',0,1,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL),
('1-2','system','系统','/system','app','app根目录','app根目录',0,1,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL),
('1-3','system','系统','/system','form','表单模型','通过form注册的API',0,1,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL);

UPDATE `api_namespace` SET `sub_count`=0;
UPDATE `api_namespace` u,
(SELECT `parent`, COUNT(1) cnt FROM `api_namespace` GROUP BY `parent`) t
SET u.`sub_count`=t.`cnt` WHERE CONCAT(u.`parent`,'/',u.`namespace`)=t.`parent`;
UPDATE `api_namespace` u,
(SELECT `parent`, COUNT(1) cnt FROM `api_namespace` GROUP BY `parent`) t
SET u.`sub_count`=t.`cnt` WHERE CONCAT('/',u.`namespace`)=t.`parent`;

REPLACE  INTO `api_service`(`id`,`owner`,`owner_name`,`namespace`,`name`,`title`,`desc`,`access`,`active`,`schema`,`host`,`auth_type`,`authorize`,`create_at`,`update_at`,`delete_at`) VALUES
('1','system','系统','/system/app','form','表单','表单接口',0,1,'http','form','system',NULL,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL),
('2','system','系统','/system/app','structor','表单底层','表单底层接口',0,1,'http','structor','system',NULL,unix_timestamp(NOW())*1000,unix_timestamp(NOW())*1000,NULL);

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_raw`;
CREATE TABLE `api_raw` (
    `id`        VARCHAR(64)  COMMENT 'unique id',
    `owner`     VARCHAR(64)  COMMENT 'owner id',
    `owner_name`VARCHAR(64)  COMMENT 'owner name',
    `namespace` VARCHAR(384) NOT NULL COMMENT 'belong full namespace, eg: /a/b/c',
    `name`      VARCHAR(64) NOT NULL COMMENT 'unique name',
    `service`   VARCHAR(512) NOT NULL COMMENT 'belong service full path, eg: /a/b/c/servicesX',
    `title` 	VARCHAR(64)  COMMENT 'alias of name, mutable',
    `desc`      TEXT,
    `version`   VARCHAR(32),
    `path`      VARCHAR(512) NOT NULL COMMENT 'relative path, eg: /api/foo/bar',
    `url`       VARCHAR(512) NOT NULL COMMENT 'full path, eg: https://api.xxx.com/api/foo/bar',
    `action`    VARCHAR(64) DEFAULT '' COMMENT 'action on path',
    `method`    VARCHAR(16) NOT NULL COMMENT 'method',
    `content`   TEXT,
    `doc`   	TEXT COMMENT 'api doc',

    `access` 	INT(11) 	 NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`    TINYINT      DEFAULT 1 COMMENT '1 ok, 0 disable',
    `valid`         TINYINT         DEFAULT 1 COMMENT '1 valid, 0 invalid',

    `schema` 	VARCHAR(16) 	NOT NULL COMMENT 'from service, http/https',
    `host` 		VARCHAR(128) 	NOT NULL COMMENT 'eg: api.xxx.com:8080',
    `auth_type` VARCHAR(32)     NOT NULL COMMENT 'none/system/signature/cookie/oauth2...',

    `create_at` BIGINT(20) 	COMMENT 'create time',
    `update_at` BIGINT(20) 	COMMENT 'update time',
    `delete_at` BIGINT(20) 	COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`,`name`),
    KEY `idx_service` (`service`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_poly`;
CREATE TABLE `api_poly` (
    `id`        VARCHAR(64)  COMMENT 'unique id',
    `owner`     VARCHAR(64)  COMMENT 'owner id',
    `owner_name`VARCHAR(64)  COMMENT 'owner name',
    `namespace` VARCHAR(384) NOT NULL COMMENT 'belong full namespace, eg: /a/b/c',
    `name`      VARCHAR(64) NOT NULL COMMENT 'name',
    `title` 	VARCHAR(64)  COMMENT 'alias of name, mutable',
    `desc`      TEXT,

    `access` 	INT(11) 	NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`    TINYINT     DEFAULT 1 COMMENT '1 ok, 0 disable',
    `valid`         TINYINT         DEFAULT 1 COMMENT '1 valid, 0 invalid',

    `method`    VARCHAR(16) NOT NULL COMMENT 'method',
    `arrange`   TEXT,
    `doc`       TEXT 		COMMENT 'api doc',
    `script`    TEXT,

    `create_at` BIGINT(20) 	COMMENT 'create time',
    `update_at` BIGINT(20) 	COMMENT 'update time',
    `build_at`  BIGINT(20) 	COMMENT 'build time',
    `delete_at` BIGINT(20) 	COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`,`name`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_permit_group`;
CREATE TABLE `api_permit_group` (
    `id` 		VARCHAR(64) 	COMMENT 'unique id',
    `owner` 	VARCHAR(64) 	COMMENT 'owner id',
    `owner_name`VARCHAR(64)     COMMENT 'owner name',
    `namespace` VARCHAR(384) 	NOT NULL  COMMENT 'belong namespace',
    `name`      VARCHAR(64)    NOT NULL COMMENT 'permit group name',
    `title` 	VARCHAR(64) 	COMMENT 'alias, mutable',
    `desc` 		TEXT,

    `access` 	INT(11) 		NOT NULL COMMENT 'privilege for public access, 1,2,4,8,16,32 CRUDGX',
    `active`    TINYINT     	DEFAULT 1 COMMENT '1 ok, 0 disable',

    `create_at` BIGINT(20) 	    COMMENT 'create time',
    `update_at` BIGINT(20) 	    COMMENT 'update time',
    `delete_at` BIGINT(20) 	    COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`,`name`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_permit_elem`;
CREATE TABLE `api_permit_elem` (
    `id` 		VARCHAR(64) 	COMMENT 'unique id',
    `owner` 	VARCHAR(64) 	COMMENT 'owner id',
    `owner_name`VARCHAR(64)  COMMENT 'owner name',

    `group_path` VARCHAR(448) 	COMMENT 'permitgroup path',
    `elem_type` VARCHAR(10)     COMMENT 'raw/poly/ckey/ns/service',
    `elem_id` 	VARCHAR(64) 	COMMENT 'element id',
    `elem_path` VARCHAR(512) 	COMMENT 'element path',
    `desc`      TEXT,
    `elem_pri`  INT(11) 		NOT NULL COMMENT 'privilege for this elem, 1,2,4,8,16,32 CRUDGX',
    `content` 	TEXT            COMMENT 'permission detail JSON, for api field control',
    `active`    TINYINT         DEFAULT 1 COMMENT '1 ok, 0 disable',

    `create_at` BIGINT(20) 	    COMMENT 'create time',
    `update_at` BIGINT(20) 	    COMMENT 'update time',
    `delete_at` BIGINT(20) 	    COMMENT 'delete time',
    UNIQUE KEY `idx_group_elem` (`group_path`,`elem_type`, `elem_id`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_permit_grant`;
CREATE TABLE `api_permit_grant` (
    `id`         VARCHAR(64)    COMMENT 'unique id',
    `owner`      VARCHAR(64)    COMMENT 'owner id',
    `owner_name` VARCHAR(64)  COMMENT 'owner name',

    `group_path` VARCHAR(448) 	COMMENT 'permitgroup path',
    `grant_type` VARCHAR(10)    COMMENT 'app/user/key/usergroup',
    `grant_id`   VARCHAR(64) 	COMMENT 'element id',
    `grant_name` VARCHAR(64) 	COMMENT 'element name',
    `grant_pri`  INT(11) 		NOT NULL COMMENT 'privilege for this group, 1,2,4,8,16,32 CRUDGX',
    `desc`       TEXT,
    `active`     TINYINT        DEFAULT 1 COMMENT '1 ok, 0 disable',

    `create_at`     BIGINT(20) 	COMMENT 'create time',
    `update_at`     BIGINT(20) 	COMMENT 'update time',
    `delete_at`     BIGINT(20) 	COMMENT 'delete time',
    UNIQUE KEY `idx_group_grant` (`group_path`, `grant_type`, `grant_id`),
    KEY `idx_grant`(`grant_type`, `grant_id`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_raw_poly`;
Create TABLE `api_raw_poly` (
    `id`        VARCHAR(64)     NOT NULL COMMENT 'unique id',
    `raw_api`   VARCHAR(512)    NOT NULL COMMENT 'raw api full-path, eg: /a/b/c/rawApiName',
    `poly_api`  VARCHAR(512)    NOT NULL COMMENT 'poly api full-path, eg: /a/b/c/polyApiName',
    `delete_at` BIGINT(20)        COMMENT 'delete time',
    INDEX `idx_rawapi` (`raw_api`),
    INDEX `idx_polyapi` (`poly_api`),
    PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*--------------------------------------------------------------------------------------------------------------------------*/
DROP TABLE IF EXISTS `api_schema`;
CREATE TABLE `api_schema` (
    `ID`        VARCHAR(64)     COMMENT 'unique id',
    `namespace` VARCHAR(384)    NOT NULL COMMENT 'belong full namespace, eg: /a/b/c',
    `name`      VARCHAR(64)     NOT NULL COMMENT 'unique name',
    `title`     VARCHAR(64)     COMMENT 'alias of name',
    `desc`      TEXT,
    `schema`    TEXT            NOT NULL COMMENT 'api schema',
    `create_at` BIGINT(20)        COMMENT 'create time',
    `update_at` BIGINT(20)        COMMENT 'update time',
    `delete_at` BIGINT(20)        COMMENT 'delete time',
    UNIQUE KEY `idx_global_name` (`namespace`, `name`),
    PRIMARY KEY (`id`)
)ENGINE=INNODB DEFAULT CHARSET=utf8;



ALTER TABLE `api_namespace` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_namespace` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_namespace` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_poly` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_poly` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_poly` MODIFY `build_at`  BIGINT(20);
ALTER TABLE `api_poly` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_raw` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_raw` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_raw` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_raw_poly` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_permit_elem` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_permit_elem` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_permit_elem` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_permit_grant` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_permit_grant` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_permit_grant` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_permit_group` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_permit_group` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_permit_group` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_schema` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_schema` MODIFY `update_at` BIGINT(20);
-- ALTER TABLE `api_schema` MODIFY `delete_at` BIGINT(20);

ALTER TABLE `api_service` MODIFY `create_at` BIGINT(20);
ALTER TABLE `api_service` MODIFY `update_at` BIGINT(20);
ALTER TABLE `api_service` MODIFY `delete_at` BIGINT(20);

UPDATE `api_namespace` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;

UPDATE `api_poly` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`build_at`=UNIX_TIMESTAMP(STR_TO_DATE(`build_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_raw` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_raw_poly` SET
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_permit_elem` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_permit_grant` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_permit_group` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_schema` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_service` SET
	`create_at`=UNIX_TIMESTAMP(STR_TO_DATE(`create_at`,'%Y%m%d%H%i%s'))*1000,
	`update_at`=UNIX_TIMESTAMP(STR_TO_DATE(`update_at`,'%Y%m%d%H%i%s'))*1000,
	`delete_at`=UNIX_TIMESTAMP(STR_TO_DATE(`delete_at`,'%Y%m%d%H%i%s'))*1000;
UPDATE `api_namespace` SET `delete_at`=NULL WHERE `delete_at`=0;
UPDATE `api_raw` SET `delete_at`=NULL WHERE `delete_at`=0;
UPDATE `api_poly` SET `delete_at`=NULL WHERE `delete_at`=0;
-- UPDATE `api_schema` SET `delete_at`=NULL WHERE `delete_at`=0;
UPDATE `api_service` SET `delete_at`=NULL WHERE `delete_at`=0;
REPLACE  into `api_poly`(`id`,`owner`,`owner_name`,`namespace`,`name`,`title`,`desc`,`access`,`active`,`valid`,`method`,`arrange`,`doc`,`script`,`create_at`,`update_at`,`build_at`,`delete_at`) values
('poly_AAxfxhEZG2epwoUU1cmAYIKZGyq_xFs3llI4eJcXKMVG','system','系统','/system/poly','permissionInit.p','应用初始化','',0,1,1,'POST','{}','{}','// polyTmpScript_/system/poly/permissionInit.p_2022-02-09T18:09:59CST\nvar _tmp = function(){\n  var d = { \"__input\": __input, } // qyAllLocalData\n\n  d.start = __input.body\n\n  d.start.header = d.start.header || {}\n  d.start._ = [\n    pdCreateNS(\'/system/app\',d.start.appID,\'应用\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'poly\',\'API编排\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID,\'raw\',\'原生API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw\',\'customer\',\'代理第三方API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/customer\',\'default\',\'默认分组\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw\',\'inner\',\'平台API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner\',\'form\',\'表单模型API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner/form\',\'form\',\'表单API\'),\n    pdCreateNS(\'/system/app/\'+d.start.appID+\'/raw/inner/form\',\'custom\',\'模型API\'),\n  ]\n  if (true) { // req1, create\n    var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/create\" ,d.start.appID)\n    var _t = {\n        \"name\": d.start.name,\n        \"description\": d.start.description,\n        \"types\": d.start.types,\n      }\n    var _th = pdNewHttpHeader()\n    pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n    var _tk = \'\';\n    var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n    d.req1 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n  }\n  d.cond1 = { y: false, }\n  if (d.req1.code==0) {\n    d.cond1.y = true\n    if (true) { // req2, update\n      var _apiPath = format(\"http://structor/api/v1/structor/%v/base/permission/perGroup/update\" ,d.start.appID)\n      var _t = {\n          \"id\": d.req1.data.id,\n          \"scopes\": d.start.scopes,\n        }\n      var _th = pdNewHttpHeader()\n      pdAddHttpHeader(_th, \"Content-Type\", \"application/json\")\n\n      var _tk = \'\';\n      var _tb = pdAppendAuth(_tk, \'none\', _th, pdToJson(_t))\n      d.req2 = pdToJsobj(\"json\", pdHttpRequest(_apiPath, \"POST\", _tb, _th, pdQueryUser(true)))\n    }\n  }\n\n  d.end = {\n    \"createNamespaces\": d.start._,\n    \"req1\": d.req1,\n    \"req2\": sel(d.cond1.y,d.req2,undefined),\n  }\n  return pdToJsonP(d.end)\n}; _tmp();\n',1644401396775,1644401401416,1644401403301,NULL);

/*Data for the table `api_raw` */

REPLACE  into `api_raw`(`id`,`owner`,`owner_name`,`namespace`,`name`,`service`,`title`,`desc`,`version`,`path`,`url`,`action`,`method`,`content`,`doc`,`access`,`active`,`valid`,`schema`,`host`,`auth_type`,`create_at`,`update_at`,`delete_at`) values
('raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R','system','系统','/system/form','base_pergroup_create.r','','创建用户组','','last','/api/v1/structor/:appID/base/permission/perGroup/create','http://structor/api/v1/structor/:appID/base/permission/perGroup/create','','POST','{\"x-id\":\"raw_AAAxYvGEh8iIgpjBqleBRjS2J_XKkYJ9IeXyGU9xAt0R\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/create\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"创建用户组\",\"desc\":\"\"}','{\"x-id\":\"\",\"version\":\"v0.7.3(2021-12-29@f6d9b2b)\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/request/system/form/base_pergroup_create.r\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"X-Polysign-Access-Key-Id\",\"title\":\"签名密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"$appendix$\":true,\"data\":\"KeiIY8098435rty\",\"in\":\"header\",\"mock\":\"KeiIY8098435rty\"},{\"type\":\"string\",\"name\":\"X-Polysign-Timestamp\",\"title\":\"签名时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"$appendix$\":true,\"data\":\"2020-12-31T12:34:56+0800\",\"in\":\"header\",\"mock\":\"2020-12-31T12:34:56+0800\"},{\"type\":\"string\",\"name\":\"X-Polysign-Version\",\"title\":\"签名版本\",\"desc\":\"\\\"1\\\" only current\",\"$appendix$\":true,\"data\":\"1\",\"in\":\"header\",\"mock\":\"1\"},{\"type\":\"string\",\"name\":\"X-Polysign-Method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"$appendix$\":true,\"data\":\"HmacSHA256\",\"in\":\"header\",\"mock\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2 if use token access mode\",\"$appendix$\":true,\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"required\":true,\"data\":\"application/json\",\"in\":\"header\",\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"required\":true,\"data\":null,\"in\":\"path\"},{\"type\":\"object\",\"name\":\"root\",\"data\":[{\"type\":\"string\",\"name\":\"name\",\"data\":null},{\"type\":\"string\",\"name\":\"description\",\"data\":null},{\"type\":\"string\",\"name\":\"x_polyapi_signature\",\"title\":\"参数签名\",\"desc\":\"required if Access-Token doesn\'t use.\\nHmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\",\"$appendix$\":true,\"data\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"},{\"type\":\"object\",\"name\":\"$polyapi_hide$\",\"title\":\"隐藏参数\",\"desc\":\"polyapi reserved hide args like path args in raw api.\",\"$appendix$\":true,\"data\":[]}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"新增后，权限用户组id\",\"data\":null}]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"X-Polysign-Access-Key-Id\":[\"KeiIY8098435rty\"],\"X-Polysign-Method\":[\"HmacSHA256\"],\"X-Polysign-Timestamp\":[\"2020-12-31T12:34:56+0800\"],\"X-Polysign-Version\":[\"1\"]},\"body\":{\"$polyapi_hide$\":{\"appID\":\"Ex\"},\"description\":\"Yl1\",\"name\":\"lxg\",\"x_polyapi_signature\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"}},{\"header\":{\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"],\"签名密钥序号\":[\"KeiIY8098435rty\"],\"签名方法\":[\"HmacSHA256\"],\"签名时间戳\":[\"2020-12-31T12:34:56+0800\"],\"签名版本\":[\"1\"]},\"body\":{\"description\":\"bfe5cBNe\",\"name\":\"LRUcDVLkcn\",\"参数签名\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\",\"隐藏参数\":{\"appID\":\"Z3L3nqIWvr\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{\"id\":\"0947QqodR\"},\"msg\":\"Zi\"}},{\"resp\":{\"code\":9,\"data\":{\"id\":\"Mr0ic9\"},\"msg\":\"0SKkAP-_y\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generated\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/create\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_create\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"},\"description\":{\"type\":\"string\"}},\"required\":[]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"新增后，权限用户组id\"}}},\"msg\":{\"type\":\"string\"}},\"required\":[\"code\"]}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"创建用户组\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none',1644401394122,1644401394122,NULL),
('raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n','system','系统','/system/form','base_pergroup_update.r','','给用户组加入人员或者部门','','last','/api/v1/structor/:appID/base/permission/perGroup/update','http://structor/api/v1/structor/:appID/base/permission/perGroup/update','','POST','{\"x-id\":\"raw_AM51O-2rUXb1RVDXnOvAo8FRq5BJzaO4vdO8QVx-qZ1n\",\"x-action\":\"\",\"x-consts\":[],\"x-input\":{},\"x-output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null}},\"basePath\":\"/\",\"path\":\"/api/v1/structor/:appID/base/permission/perGroup/update\",\"method\":\"POST\",\"encoding-in\":\"json\",\"encoding-out\":\"json\",\"summary\":\"给用户组加入人员或者部门\",\"desc\":\"\"}','{\"x-id\":\"\",\"version\":\"v0.7.3(2021-12-29@f6d9b2b)\",\"x-fmt-inout\":{\"method\":\"POST\",\"url\":\"/api/v1/polyapi/request/system/form/base_pergroup_update.r\",\"input\":{\"inputs\":[{\"type\":\"string\",\"name\":\"X-Polysign-Access-Key-Id\",\"title\":\"签名密钥序号\",\"desc\":\"access_key_id dispatched by poly api server\",\"$appendix$\":true,\"data\":\"KeiIY8098435rty\",\"in\":\"header\",\"mock\":\"KeiIY8098435rty\"},{\"type\":\"string\",\"name\":\"X-Polysign-Timestamp\",\"title\":\"签名时间戳\",\"desc\":\"timestamp format ISO8601: 2006-01-02T15:04:05-0700\",\"$appendix$\":true,\"data\":\"2020-12-31T12:34:56+0800\",\"in\":\"header\",\"mock\":\"2020-12-31T12:34:56+0800\"},{\"type\":\"string\",\"name\":\"X-Polysign-Version\",\"title\":\"签名版本\",\"desc\":\"\\\"1\\\" only current\",\"$appendix$\":true,\"data\":\"1\",\"in\":\"header\",\"mock\":\"1\"},{\"type\":\"string\",\"name\":\"X-Polysign-Method\",\"title\":\"签名方法\",\"desc\":\"\\\"HmacSHA256\\\" only current\",\"$appendix$\":true,\"data\":\"HmacSHA256\",\"in\":\"header\",\"mock\":\"HmacSHA256\"},{\"type\":\"string\",\"name\":\"Access-Token\",\"title\":\"登录授权码\",\"desc\":\"Access-Token from oauth2 if use token access mode\",\"$appendix$\":true,\"data\":null,\"in\":\"header\",\"mock\":\"H3K56789lHIUkjfkslds\"},{\"type\":\"string\",\"name\":\"Content-Type\",\"title\":\"数据格式\",\"desc\":\"application/json\",\"required\":true,\"data\":\"application/json\",\"in\":\"header\",\"mock\":\"application/json\"},{\"type\":\"string\",\"name\":\"appID\",\"required\":true,\"data\":null,\"in\":\"path\"},{\"type\":\"object\",\"name\":\"root\",\"title\":\"empty object\",\"data\":[{\"type\":\"string\",\"name\":\"id\",\"desc\":\"用户组权限id\",\"data\":null},{\"type\":\"array\",\"name\":\"scopes\",\"data\":[{\"type\":\"object\",\"name\":\"\",\"data\":[{\"type\":\"number\",\"name\":\"type\",\"desc\":\"1 人员 2 部门\",\"data\":null},{\"type\":\"string\",\"name\":\"id\",\"desc\":\"人员或者部门id\",\"data\":null},{\"type\":\"string\",\"name\":\"name\",\"desc\":\"人员或者部门名字\",\"data\":null}]}]},{\"type\":\"string\",\"name\":\"x_polyapi_signature\",\"title\":\"参数签名\",\"desc\":\"required if Access-Token doesn\'t use.\\nHmacSHA256 signature of input body: sort query gonic asc|sha256 \\u003cSECRET_KEY\\u003e|base64 std encode\",\"$appendix$\":true,\"data\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"},{\"type\":\"object\",\"name\":\"$polyapi_hide$\",\"title\":\"隐藏参数\",\"desc\":\"polyapi reserved hide args like path args in raw api.\",\"$appendix$\":true,\"data\":[]}],\"in\":\"body\"}]},\"output\":{\"body\":{\"type\":\"\",\"name\":\"\",\"data\":null},\"doc\":[{\"type\":\"object\",\"desc\":\"successful operation\",\"data\":[{\"type\":\"number\",\"name\":\"code\",\"data\":null},{\"type\":\"object\",\"name\":\"data\",\"data\":[]},{\"type\":\"string\",\"name\":\"msg\",\"data\":null}],\"in\":\"body\"}]},\"sampleInput\":[{\"header\":{\"Access-Token\":[\"H3K56789lHIUkjfkslds\"],\"Content-Type\":[\"application/json\"],\"X-Polysign-Access-Key-Id\":[\"KeiIY8098435rty\"],\"X-Polysign-Method\":[\"HmacSHA256\"],\"X-Polysign-Timestamp\":[\"2020-12-31T12:34:56+0800\"],\"X-Polysign-Version\":[\"1\"]},\"body\":{\"$polyapi_hide$\":{\"appID\":\"pOh08X\"},\"id\":\"H3tR6_rI\",\"scopes\":[{\"id\":\"CHRR0\",\"name\":\"SYO5JAcgkU\",\"type\":15}],\"x_polyapi_signature\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\"}},{\"header\":{\"数据格式\":[\"application/json\"],\"登录授权码\":[\"H3K56789lHIUkjfkslds\"],\"签名密钥序号\":[\"KeiIY8098435rty\"],\"签名方法\":[\"HmacSHA256\"],\"签名时间戳\":[\"2020-12-31T12:34:56+0800\"],\"签名版本\":[\"1\"]},\"body\":{\"id\":\"kZ6wQ\",\"scopes\":[{\"id\":\"aMY\",\"name\":\"O3XgMO7dm\",\"type\":16}],\"参数签名\":\"EJML8aQ3BkbciPwMYHlffv2BagW0kdoI3L_qOedQylw\",\"隐藏参数\":{\"appID\":\"4PX\"}}}],\"sampleOutput\":[{\"resp\":{\"code\":11,\"data\":{},\"msg\":\"Er\"}},{\"resp\":{\"code\":18,\"data\":{},\"msg\":\"WTYjM-SlrSi\"}}]},\"x-swagger\":{\"x-consts\":null,\"host\":\"structor\",\"swagger\":\"2.0\",\"info\":{\"title\":\"\",\"version\":\"last\",\"description\":\"auto generated\",\"contact\":{\"name\":\"\",\"url\":\"\",\"email\":\"\"}},\"schemes\":[\"http\"],\"basePath\":\"/\",\"paths\":{\"/api/v1/structor/:appID/base/permission/perGroup/update\":{\"post\":{\"x-consts\":[],\"operationId\":\"base_pergroup_update\",\"parameters\":[{\"name\":\"appID\",\"in\":\"path\",\"description\":\"\",\"required\":true,\"type\":\"string\"},{\"name\":\"root\",\"in\":\"body\",\"schema\":{\"type\":\"object\",\"title\":\"empty object\",\"properties\":{\"id\":{\"type\":\"string\",\"description\":\"用户组权限id\"},\"scopes\":{\"type\":\"array\",\"items\":{\"type\":\"object\",\"properties\":{\"type\":{\"type\":\"integer\",\"description\":\"1 人员 2 部门\"},\"id\":{\"type\":\"string\",\"description\":\"人员或者部门id\"},\"name\":{\"type\":\"string\",\"description\":\"人员或者部门名字\"}},\"required\":[\"type\",\"id\",\"name\"]}}},\"required\":[\"id\",\"scopes\"]}}],\"responses\":{\"200\":{\"description\":\"successful operation\",\"schema\":{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"type\":\"object\",\"properties\":{\"code\":{\"type\":\"number\"},\"data\":{\"type\":\"object\",\"properties\":{}},\"msg\":{\"type\":\"string\"}}}}},\"consumes\":[\"application/json\"],\"produces\":[\"application/json\"],\"summary\":\"给用户组加入人员或者部门\",\"description\":\"\"}}}}}',0,1,1,'http','structor','none',1644401395110,1644401395110,NULL);
