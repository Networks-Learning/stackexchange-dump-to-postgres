DROP TABLE IF EXISTS Badges CASCADE;
CREATE TABLE Badges (
   Id                int         PRIMARY KEY ,
   UserId            int         not NULL    ,
   Name              text        not NULL    ,
   Date              timestamp   not NULL
);
