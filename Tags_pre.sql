DROP TABLE IF EXISTS Tags;
CREATE TABLE Tags (
    Id                    int not NULL,
    TagName               text not NULL,
    Count                 int,
    ExcerptPostId         int,
    WikiPostId            int
);
