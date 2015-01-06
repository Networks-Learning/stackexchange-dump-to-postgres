-- The hash index is too slow to create
CREATE INDEX badges_user_id_idx on Badges USING btree (UserId)
       WITH (FILLFACTOR = 100);
-- The hash index is too slow to create
CREATE INDEX badges_name_idx on Badges USING btree (Name)
       WITH (FILLFACTOR = 100);
CREATE INDEX badges_date_idx on Badges USING btree (Date)
       WITH (FILLFACTOR = 100);

