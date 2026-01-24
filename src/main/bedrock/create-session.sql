CREATE DATABASE IF NOT EXISTS bedrock;

CREATE USER IF NOT EXISTS 'fred'@'%' IDENTIFIED BY 'flintstone';

GRANT ALL PRIVILEGES ON *.* TO 'fred'@'%';

USE bedrock;

CREATE TABLE IF NOT EXISTS session
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

CREATE OR REPLACE VIEW v_active_sessions AS
  SELECT id, session, username, expires
    FROM session
    WHERE expires > now() AND username <> '';

CREATE OR REPLACE VIEW v_expired_sesssion AS
  SELECT id, session, username, expires
    FROM session
    WHERE expires < now();

