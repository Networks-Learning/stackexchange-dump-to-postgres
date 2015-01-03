CREATE INDEX posts_id_idx on Posts USING hash (Id)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_post_type_id_idx on Posts USING btree (PostTypeId)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_score_idx on Posts USING btree (Score)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_creation_date_idx on Posts USING btree (CreationDate)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_owner_user_id_idx on Posts USING hash (OwnerUserId)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_answer_count_idx on Posts USING btree (AnswerCount)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_comment_count_idx on Posts USING btree (CommentCount)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_favorite_count_idx on Posts USING btree (FavoriteCount)
       WITH (FILLFACTOR = 100);
