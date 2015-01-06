DROP TABLE IF EXISTS Tags CASCADE;
CREATE TABLE Tags (
    Id                    int  PRIMARY KEY ,
    TagName               text not NULL    ,
    Count                 int,
    ExcerptPostId         int,
    WikiPostId            int
);
