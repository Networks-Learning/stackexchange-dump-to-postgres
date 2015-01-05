CREATE INDEX badges_id_idx on Badges USING hash (Id)
       WITH (FILLFACTOR = 100);
CREATE INDEX badges_user_id_idx on Badges USING hash (UserId)
       WITH (FILLFACTOR = 100);
CREATE INDEX badges_name_idx on Badges USING hash (Name)
       WITH (FILLFACTOR = 100);
CREATE INDEX badges_date_idx on Badges USING btree (Date)
       WITH (FILLFACTOR = 100);

