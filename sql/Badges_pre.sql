DROP TABLE IF EXISTS Badges;
CREATE TABLE Badges (
   Id                int         PRIMARY KEY ,
   UserId            int         not NULL    ,
   Name              text        not NULL    ,
   Date              timestamp   not NULL
);
