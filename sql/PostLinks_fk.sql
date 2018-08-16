-- impossible to enforce so set NULL
UPDATE Postlinks SET postid=NULL WHERE postid NOT IN (SELECT DISTINCT id FROM Posts);
ALTER TABLE Postlinks ADD CONSTRAINT fk_postlinks_postid FOREIGN KEY (postid) REFERENCES posts (id);
UPDATE Postlinks SET relatedpostid=NULL WHERE relatedpostid NOT IN (SELECT DISTINCT id FROM Posts);
ALTER TABLE Postlinks ADD CONSTRAINT fk_postlinks_relatedpostid FOREIGN KEY (relatedpostid) REFERENCES posts (id);
