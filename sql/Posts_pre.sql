DROP TABLE IF EXISTS Posts;
CREATE TABLE Posts (
    Id                     int PRIMARY KEY    ,
    PostTypeId             int not NULL       ,
    AcceptedAnswerId       int                ,
    ParentId               int                ,
    CreationDate           timestamp not NULL ,
    Score                  int                ,
    ViewCount              int                ,
 -- Not storing the body currently
 -- Body                   text not NULL      ,
    OwnerUserId            int                ,
    LastEditorUserId       int                ,
    LastEditorDisplayName  text               ,
    LastEditDate           timestamp          ,
    LastActivityDate       timestamp          ,
    Title                  text               ,
    Tags                   text               ,
    AnswerCount            int                ,
    CommentCount           int                ,
    FavoriteCount          int                ,
    ClosedDate             timestamp          ,
    CommunityOwnedDate     timestamp
);

