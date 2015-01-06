DROP TABLE IF EXISTS Votes CASCADE;
CREATE TABLE Votes (
   Id                int         PRIMARY KEY ,
   PostId            int         not NULL    ,
   VoteTypeId        int         not NULL    ,
   UserId            int                     ,
   CreationDate      timestamp   not NULL    ,
   BountyAmount      int
);

