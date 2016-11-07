DROP TABLE IF EXISTS Comments CASCADE;
CREATE TABLE Comments (
    Id                     int PRIMARY KEY    ,
    PostId                 int not NULL       , 
    Score                  int not NULL       ,
    Text                   text               ,
    CreationDate           timestamp not NULL , 
    UserId                 int                
);
