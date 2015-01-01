CREATE TABLE Users (
   Id                int,
   Reputation        int,
   CreationDate      datetime,
   DisplayName       varchar(40),
   LastAccessDate    datetime,
   WebsiteUrl        varchar(200),
   Location          varchar(100),
   AboutMe           varchar(max),
   Views             int,
   UpVotes           int,
   DownVotes         int,
   ProfileImageUrl   varchar(200),
   EmailHash         varchar(32),
   Age               int,
   AccountId         int
);

