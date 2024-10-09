 create table session
  (
   id           integer primary key autoincrement not null,
   session      varchar(50)  not null default '',
   login_cookie varchar(50)  not null default '',
   username     varchar(50)  not null default '',
   password     varchar(30)  default null,
   firstname    varchar(30)  default null,
   lastname     varchar(50)  default null,
   email        varchar(100) default null,
   prefs        text,
   updated      timestamp    not null default current_timestamp,
   added        datetime     default null,
   expires      datetime     default null
 );

CREATE TRIGGER session_updates AFTER UPDATE ON session
  BEGIN
    UPDATE session SET updated=CURRENT_TIMESTAMP where rowid=new.rowid;
  END;
