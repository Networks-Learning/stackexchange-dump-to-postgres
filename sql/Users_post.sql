CREATE INDEX user_acc_id_idx ON Users USING hash (AccountId)
       WITH (FILLFACTOR = 100);
CREATE INDEX user_display_idx ON Users USING hash (DisplayName)
       WITH (FILLFACTOR = 100);
CREATE INDEX user_up_votes_idx ON Users USING btree (UpVotes)
       WITH (FILLFACTOR = 100);
CREATE INDEX user_down_votes_idx ON Users USING btree (DownVotes)
       WITH (FILLFACTOR = 100);
CREATE INDEX user_created_at_idx ON Users USING btree (CreationDate)
       WITH (FILLFACTOR = 100);
