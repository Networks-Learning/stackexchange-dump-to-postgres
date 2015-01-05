DROP TABLE IF EXISTS Tags;
CREATE TABLE Tags (
    Id                    int  PRIMARY KEY ,
    TagName               text not NULL    ,
    Count                 int,
    ExcerptPostId         int,
    WikiPostId            int
);
