DROP TABLE IF EXISTS Users CASCADE;
CREATE TABLE Users (
   Id                int         PRIMARY KEY ,
   Reputation        int         not NULL    ,
   CreationDate      timestamp   not NULL    ,
   DisplayName       varchar(40) not NULL    ,
   LastAccessDate    timestamp               ,
   WebsiteUrl        TEXT                    ,
   Location          TEXT                    ,
   AboutMe           TEXT                    ,
   Views             int         not NULL    ,
   UpVotes           int         not NULL    ,
   DownVotes         int         not NULL    ,
   ProfileImageUrl   text                    ,
   Age               int                     ,
   AccountId         int                     , -- NULL accountId == deleted account?
   jsonfield         jsonb
);

