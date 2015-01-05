DROP TABLE IF EXISTS Votes;
CREATE TABLE Votes (
   Id                int         PRIMARY KEY ,
   PostId            int         not NULL    ,
   VoteTypeId        int         not NULL    ,
   CreationDate      timestamp   not NULL
);

