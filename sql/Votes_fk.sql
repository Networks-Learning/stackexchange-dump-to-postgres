ALTER TABLE Votes ADD CONSTRAINT fk_votes_userid FOREIGN KEY (userid) REFERENCES users (id);
-- impossible to enforce this constraint, set as 'not valid' to disable
-- initial test.
--
-- This constaint can be forced running the following queries:
-- ALTER TABLE votes ALTER PostId DROP NOT NULL;
-- UPDATE votes SET postid=NULL WHERE postid NOT IN (SELECT DISTINCT id FROM Posts);
-- ALTER TABLE votes VALIDATE CONSTRAINT fk_votes_postid;
--
ALTER TABLE Votes ADD CONSTRAINT fk_votes_postid FOREIGN KEY (postid) REFERENCES posts (id) NOT VALID;
