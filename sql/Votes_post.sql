CREATE INDEX votes_post_id_idx on Votes USING hash (PostId)
       WITH (FILLFACTOR = 100);
CREATE INDEX votes_type_idx on Votes USING btree (VoteTypeId)
       WITH (FILLFACTOR = 100);
CREATE INDEX votes_creation_date_idx on Votes USING btree (CreationDate)
       WITH (FILLFACTOR = 100);

