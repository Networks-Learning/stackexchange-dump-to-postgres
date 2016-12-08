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


CREATE TABLE accepted_answer_id as SELECT DISTINCT acceptedanswerid FROM posts;

DROP TABLE qn_ans_timing;

CREATE TABLE qn_ans_timing AS
SELECT 
	p.id, 
	p.tags, 
	p.owneruserid, 
	p.creationdate as qn_creation_ts, 
	h.creationdate as ans_creation_ts, 
	p.acceptedanswerid,
	h.userid as answered_by
FROM posts p, posthistory h
WHERE p.acceptedanswerid is not null
AND h.postid in (
				SELECT * 
				FROM accepted_answer_id
				)

AND p.acceptedanswerid=h.postid;