drop database if exists bedrock;

create database bedrock;

drop user if exists fred;

create user 'fred'@'%' identified by 'flintstone';

grant all privileges on *.* to 'fred'@'%';

use bedrock;

create table session
 (
  id           int(11)      not null auto_increment primary key,
  session      varchar(50)  default null,
  login_cookie varchar(50)  not null default '',
  username     varchar(50)  not null default '',
  password     varchar(64)  default null,
  firstname    varchar(30)  default null,
  lastname     varchar(50)  default null,
  email        varchar(100) default null,
  prefs        text,
  updated      timestamp    not null default current_timestamp on update current_timestamp,
  added        datetime     default null,
  expires      datetime     default null
);

