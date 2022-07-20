CREATE DATABASE faas DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

use faas

create table dockers
(
    id         varchar(64)  not null
        primary key,
    host       varchar(200) null,
    user_name  varchar(64)  null,
    name_space varchar(64)  null,
    secret     text         null,
    name       varchar(64)  null,
    created_at bigint       null,
    updated_at bigint       null,
    deleted_at bigint       null,
    created_by varchar(64)  null,
    updated_by varchar(64)  null,
    deleted_by varchar(64)  null,
    tenant_id  varchar(64)  null
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table event
(
    id        varchar(64)  not null comment 'unique id'
        primary key,
    name      varchar(200) null comment 'name of event',
    type      varchar(64)  null comment 'type of event',
    state     varchar(64)  null comment 'state of event',
    message   varchar(512) null comment 'msg of async',
    create_by varchar(64)  null,
    create_at bigint       null comment 'create time',
    update_at bigint       null comment 'update time',
    delete_at bigint       null comment 'delete time'
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table functions
(
    id           varchar(64)  not null
        primary key,
    group_id     varchar(64)  null,
    project_id   varchar(64)  null,
    version      varchar(200) null,
    `describe`   text         null,
    status       varchar(200) null,
    doc_status   int          null,
    doc          int          null comment 'status of function doc',
    env          text         null,
    created_at   bigint       null,
    updated_at   bigint       null,
    deleted_at   bigint       null,
    created_by   varchar(64)  null,
    updated_by   varchar(64)  null,
    deleted_by   varchar(64)  null,
    tenant_id    varchar(64)  null,
    resource_ref varchar(200) null,
    name         varchar(200) null,
    built_at     bigint       null,
    constraint functions_name_uindex
        unique (name)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table gits
(
    id          varchar(64)  not null
        primary key,
    host        varchar(200) null,
    token       text         null,
    name        varchar(200) null,
    created_at  bigint       null,
    updated_at  bigint       null,
    deleted_at  bigint       null,
    created_by  varchar(64)  null,
    updated_by  varchar(64)  null,
    deleted_by  varchar(64)  null,
    tenant_id   varchar(64)  null,
    known_hosts varchar(1000) null,
    key_scan_known_hosts text,
    ssh         text         null
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table groups
(
    id         varchar(64) not null
        primary key,
    group_id   int         null,
    group_name varchar(40) null,
    Title      varchar(64),
    `describe` text        null,
    created_at bigint      null,
    updated_at bigint      null,
    created_by varchar(64) null,
    updated_by varchar(64) null,
    deleted_by varchar(64) null,
    app_id     varchar(64) null
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table projects
(
    id           varchar(64)  not null
        primary key,
    group_id     varchar(64)  null,
    project_id   int          null,
    project_name varchar(40)  null,
    alias        varchar(40)  null,
    `describe`   text         null,
    created_at   bigint       null,
    updated_at   bigint       null,
    created_by   varchar(64)  null,
    updated_by   varchar(64)  null,
    deleted_by   varchar(64)  null,
    language     varchar(20)  null,
    version      varchar(30)  null,
    status       int          null,
    user_id      varchar(64)  null,
    repo_url     varchar(200) null
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table users
(
    id         varchar(64) not null
        primary key,
    user_id    varchar(64) null,
    git_name   varchar(64) null,
    git_id     int         null,
    created_at bigint      null,
    updated_at bigint      null,
    created_by varchar(64) null,
    updated_by varchar(64) null,
    deleted_by varchar(64) null,
    token      varchar(64) null
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table user_group
(
    id         varchar(64) not null
        primary key,
    user_id    varchar(64) null,
    git_id     int         null,
    group_id   varchar(64) null,
    created_at bigint      null,
    updated_at bigint      null,
    created_by varchar(64) null,
    updated_by varchar(64) null,
    deleted_by varchar(64) null
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
