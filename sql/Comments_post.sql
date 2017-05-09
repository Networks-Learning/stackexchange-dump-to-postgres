-- hash index takes too long to create
CREATE INDEX cmnts_score_idx ON Comments USING btree (Score)
       WITH (FILLFACTOR = 100);
CREATE INDEX cmnts_postid_idx ON Comments USING hash (PostId)
       WITH (FILLFACTOR = 100);
CREATE INDEX cmnts_creation_date_idx ON Comments USING btree (CreationDate)
       WITH (FILLFACTOR = 100);
CREATE INDEX cmnts_userid_idx ON Comments USING btree (UserId)
       WITH (FILLFACTOR = 100);