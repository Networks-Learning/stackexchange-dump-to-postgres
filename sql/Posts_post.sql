-- hash index takes too long to create
CREATE INDEX posts_post_type_id_idx ON Posts USING btree (PostTypeId)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_score_idx ON Posts USING btree (Score)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_creation_date_idx ON Posts USING btree (CreationDate)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_owner_user_id_idx ON Posts USING hash (OwnerUserId)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_answer_count_idx ON Posts USING btree (AnswerCount)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_comment_count_idx ON Posts USING btree (CommentCount)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_favorite_count_idx ON Posts USING btree (FavoriteCount)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_viewcount_idx ON Posts USING btree (ViewCount)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_accepted_answer_id_idx ON Posts USING btree (AcceptedAnswerId)
       WITH (FILLFACTOR = 100);
CREATE INDEX posts_parent_id_idx ON Posts USING btree (ParentId)
       WITH (FILLFACTOR = 100);
