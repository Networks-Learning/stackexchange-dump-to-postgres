-- The hash index is too slow to create
CREATE INDEX postlinks_post_id_idx on PostLinks USING btree (PostId)
       WITH (FILLFACTOR = 100);
CREATE INDEX postlinks_related_post_id_idx on PostLinks USING btree (RelatedPostId)
       WITH (FILLFACTOR = 100);
