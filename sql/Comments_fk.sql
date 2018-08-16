ALTER TABLE Comments ADD CONSTRAINT fk_comments_userid FOREIGN KEY (userid) REFERENCES users (id);
ALTER TABLE Comments ADD CONSTRAINT fk_comments_postid FOREIGN KEY (postid) REFERENCES posts (id);
