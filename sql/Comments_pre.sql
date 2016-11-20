DROP TABLE IF EXISTS Tags CASCADE;
CREATE TABLE Comments (
    Id                     int  PRIMARY KEY ,
    PostId                 int,
    Score                  int,
    Post_Text			   text,
    CreationDate 		   timestamp not NULL ,
    UserId				   int
);