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
