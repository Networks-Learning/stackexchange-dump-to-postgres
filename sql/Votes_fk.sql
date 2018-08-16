ALTER TABLE Votes ADD CONSTRAINT fk_votes_userid FOREIGN KEY (userid) REFERENCES users (id);
-- impossible to enforce so set NULL
UPDATE Votes SET postid=NULL WHERE postid NOT IN (SELECT DISTINCT id FROM Posts);
ALTER TABLE Votes ADD CONSTRAINT fk_votes_postid FOREIGN KEY (postid) REFERENCES posts (id);
