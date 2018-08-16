ALTER TABLE Posthistory ADD CONSTRAINT fk_posthistory_userid FOREIGN KEY (userid) REFERENCES users (id);
ALTER TABLE Posthistory ADD CONSTRAINT fk_posthistory_postid FOREIGN KEY (postid) REFERENCES posts (id);
