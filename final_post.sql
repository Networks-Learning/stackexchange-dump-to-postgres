-- This file creates additional tables (and indexes) for the
-- tables to mimic the tables available on data.stackexchange.com

-- The `LATERAL` keyword requires PostgresSQL 9.3
DROP IF EXISTS PostTags;
CREATE TABLE PostTags (
    PostId  int not NULL,
    TagId   int not NULL
);

INSERT INTO PostTags
  ( SELECT P.Id, Tags.Id
    FROM Posts P, LATERAL
        ( SELECT regexp_split_to_table(
                    -- Remove the '</>' from the ends
                    substr(P.Tags, 2, length(P.Tags) - 2)
                    -- Then split on '><'
                  , '><'
                  ) AS TagName
        ) AS PostTag
        JOIN Tags
        ON Tags.TagName = PostTag.TagName
  );

CREATE INDEX posttags_postId_idx ON PostTags USING hash (PostId)
       WITH (FILLFACTOR = 100);
-- hash index takes too long to create
CREATE INDEX posttags_tagId_idx ON PostTags USING btree (TagId)
       WITH (FILLFACTOR = 100);
