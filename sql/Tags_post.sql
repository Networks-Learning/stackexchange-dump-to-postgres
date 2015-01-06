CREATE INDEX tags_count_idx on Tags USING btree (Count)
       WITH (FILLFACTOR = 100);
CREATE INDEX tags_name_idx on Tags USING hash (TagName)
       WITH (FILLFACTOR = 100);
