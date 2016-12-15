DROP TABLE IF EXISTS PostHistory CASCADE;
CREATE TABLE PostHistory (
    Id                 int  PRIMARY KEY   ,
    PostHistoryTypeId  int                ,
    PostId             int                ,
    RevisionGUID       text               ,
    CreationDate       timestamp not NULL ,
    UserId             int                ,
    PostText           text
);
