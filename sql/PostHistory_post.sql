-- hash index takes too long to create
CREATE INDEX ph_post_type_id_idx ON PostHistory USING btree (PostHistoryTypeId)
       WITH (FILLFACTOR = 100);
CREATE INDEX ph_postid_idx ON PostHistory USING hash (PostId)
       WITH (FILLFACTOR = 100);
CREATE INDEX ph_revguid_idx ON PostHistory USING btree (RevisionGUID)
       WITH (FILLFACTOR = 100);
CREATE INDEX ph_creation_date_idx ON PostHistory USING btree (CreationDate)
       WITH (FILLFACTOR = 100);
CREATE INDEX ph_userid_idx ON PostHistory USING btree (UserId)
       WITH (FILLFACTOR = 100);
