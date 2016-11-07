-- hash index takes too long to create
CREATE INDEX comments_post_type_id_idx ON Comments USING btree (PostId)
       WITH (FILLFACTOR = 100);
CREATE INDEX comments_score_idx ON Comments USING btree (Score)
       WITH (FILLFACTOR = 100);
