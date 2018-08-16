ALTER TABLE badges ADD CONSTRAINT fk_badges_userid FOREIGN KEY (userid) REFERENCES users (id);
