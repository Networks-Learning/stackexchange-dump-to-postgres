-- This file creates additional tables (and indexes) for the
-- tables to mimic the tables available on data.stackexchange.com

-- The `LATERAL` keyword requires PostgresSQL 9.3
DROP TABLE IF EXISTS PostTags;
CREATE TABLE PostTags (
    PostId  int not NULL,
    TagId   int not NULL,
    PRIMARY KEY (PostId, TagId)
);
INSERT INTO PostTags
  -- Some old posts are tagged twice with the same tag
  ( SELECT DISTINCT P.Id, Tags.Id
    FROM Posts P, LATERAL
        ( SELECT regexp_split_to_table(
                    -- Remove the '</>' from the ends
                    substr(P.Tags, 2, length(P.Tags) - 2)
                    -- Then split on '><'
                  , '><'
                  ) AS TagName
        ) AS PostTag
        JOIN Tags
        ON Tags.TagName = PostTag.TagName
  );
CREATE INDEX posttags_postId_idx ON PostTags USING hash (PostId)
       WITH (FILLFACTOR = 100);
-- hash index takes too long to create
CREATE INDEX posttags_tagId_idx ON PostTags USING btree (TagId)
       WITH (FILLFACTOR = 100);


-- Tables containing static values

-- CloseAsOffTopicReasonTypes TABLE
DROP TABLE IF EXISTS CloseAsOffTopicReasonTypes;
CREATE TABLE CloseAsOffTopicReasonTypes (
    Id                      int  PRIMARY KEY ,
    IsUniversal             bool NOT NULL    ,
    MarkdownMini            text NOT NULL    ,
    CreationDate            timestamp        ,
    CreationModeratorId     int              ,
    ApprovalDate            timestamp        ,
    ApprovalModeratorId     int              ,
    DeactivationDate        timestamp        ,
    DeactivationModeratorId int
);
INSERT INTO CloseAsOffTopicReasonTypes VALUES
  ( 4, false, 'Questions about **specific programming problems encountered while writing code** are off-topic, but can be asked on [Stack Overflow](http://stackoverflow.com/about).', TIMESTAMP 'epoch' + 1372193477927 * INTERVAL '1 millisecond', 102, TIMESTAMP 'epoch' + 1372193510130 * INTERVAL '1 millisecond', 102, TIMESTAMP 'epoch' + 1373250154427 * INTERVAL '1 millisecond', 28988 ),
  ( 5, false, 'Questions about **the use of general computer hardware or software** are off-topic, but can be asked on [Super User](http://superuser.com/about).', TIMESTAMP 'epoch' + 1372193495707 * INTERVAL '1 millisecond', 102, TIMESTAMP 'epoch' + 1372193512067 * INTERVAL '1 millisecond', 102, TIMESTAMP 'epoch' + 1373250129923 * INTERVAL '1 millisecond', 28988 ),
  ( 6, false, 'Questions seeking **career advice or help with office politics** are off-topic here unless they''re specific to the programming profession. If people in other professions face similar problems, ask about it on [The Workplace Stack Exchange](http://workplace.stackexchange.com/about).', TIMESTAMP 'epoch' + 1372193506270 * INTERVAL '1 millisecond', 102, TIMESTAMP 'epoch' + 1372193514053 * INTERVAL '1 millisecond', 102, TIMESTAMP 'epoch' + 1373252033750 * INTERVAL '1 millisecond', 25936 ),
  ( 7, false, 'Questions about **what language, technology, or project one should take up next** are off topic on Programmers, as they can only attract subjective opinions for answers. There are too many individual factors behind the question to create answers that will have lasting value. You may be able to get help in [The Whiteboard](http://chat.stackexchange.com/rooms/21/the-whiteboard), our chat room.', TIMESTAMP 'epoch' + 1373134263690 * INTERVAL '1 millisecond', 25936, TIMESTAMP 'epoch' + 1373251180337 * INTERVAL '1 millisecond', 28988, NULL, NULL),
  ( 8, false, 'Questions asking us to **recommend a tool, library or favorite off-site resource** are off-topic for Programmers as they tend to attract opinionated answers and spam. Instead, describe the problem and what has been done so far to solve it.', TIMESTAMP 'epoch' + 1373135086080 * INTERVAL '1 millisecond', 25936, TIMESTAMP 'epoch' + 1373251185397 * INTERVAL '1 millisecond', 28988, NULL, NULL ),
  ( 9, false, 'Questions seeking **career or education advice** are off topic on Programmers. They are only meaningful to the asker and do not generate lasting value for the broader programming community. Furthermore, in most cases, any answer is going to be a subjective opinion that may not take into account all the nuances of a (your) particular circumstance.', TIMESTAMP 'epoch' + 1373251862347 * INTERVAL '1 millisecond', 25936, TIMESTAMP 'epoch' + 1373252173850 * INTERVAL '1 millisecond', 28988, NULL, NULL );


-- PostType TABLE
DROP TABLE IF EXISTS PostTypes;
CREATE TABLE PostTypes (
    Id   int  PRIMARY KEY ,
    Name text NOT NULL
);
INSERT INTO PostTypes VALUES
  ( 1, 'Question'            ),
  ( 2, 'Answer'              ),
  ( 3, 'Wiki'                ),
  ( 4, 'TagWikiExcerpt'      ),
  ( 5, 'TagWiki'             ),
  ( 6, 'ModeratorNomination' ),
  ( 7, 'WikiPlaceholder'     ),
  ( 8, 'PrivilegeWiki'       );

-- FlagTypes TABLE
DROP TABLE IF EXISTS FlagTypes;
CREATE TABLE FlagTypes (
    Id            int  PRIMARY KEY ,
    Name          text NOT NULL    ,
    Description   text NOT NULL
);
INSERT INTO FlagTypes VALUES
  ( 13, 'Question Recommend Close', 'User without close privileges suggests a question should be closed' ),
  ( 14, 'Question Close', 'User with close privileges is voting to close a question' ),
  ( 15, 'Question Reopen', 'User with close privileges is voting to reopen a question');

-- PostHistoryTypes TABLE
DROP TABLE IF EXISTS PostHistoryTypes;
CREATE TABLE PostHistoryTypes (
    Id   int  PRIMARY KEY,
    Name text NOT NULL
);
INSERT INTO PostHistoryTypes VALUES
  ( 1  , 'Initial Title'             ) ,
  ( 2  , 'Initial Body'              ) ,
  ( 3  , 'Initial Tags'              ) ,
  ( 4  , 'Edit Title'                ) ,
  ( 5  , 'Edit Body'                 ) ,
  ( 6  , 'Edit Tags'                 ) ,
  ( 7  , 'Rollback Title'            ) ,
  ( 8  , 'Rollback Body'             ) ,
  ( 9  , 'Rollback Tags'             ) ,
  ( 10 , 'Post Closed'               ) ,
  ( 11 , 'Post Reopened'             ) ,
  ( 12 , 'Post Deleted'              ) ,
  ( 13 , 'Post Undeleted'            ) ,
  ( 14 , 'Post Locked'               ) ,
  ( 15 , 'Post Unlocked'             ) ,
  ( 16 , 'Community Owned'           ) ,
  ( 17 , 'Post Migrated'             ) ,
  ( 18 , 'Question Merged'           ) ,
  ( 19 , 'Question Protected'        ) ,
  ( 20 , 'Question Unprotected'      ) ,
  ( 22 , 'Question Unmerged'         ) ,
  ( 24 , 'Suggested Edit Applied'    ) ,
  ( 25 , 'Post Tweeted'              ) ,
  ( 31 , 'Discussion moved to chat'  ) ,
  ( 33 , 'Post Notice Added'         ) ,
  ( 34 , 'Post Notice Removed'       ) ,
  ( 35 , 'Post Migrated Away'        ) ,
  ( 36 , 'Post Migrated Here'        ) ,
  ( 37 , 'Post Merge Source'         ) ,
  ( 38 , 'Post Merge Destination'    );

-- CloseReasonTypes TABLE
DROP TABLE IF EXISTS CloseReasonTypes;
CREATE TABLE CloseReasonTypes (
    Id          int  PRIMARY KEY,
    Name        text NOT NULL   ,
    Description text
);
INSERT INTO CloseReasonTypes VALUES
  ( 1, 'exact duplicate', 'This question covers exactly the same content as earlier questions on this topic; its answers may be merged with another identical question.' ),
  ( 2, 'off topic', 'Questions on $SiteName are expected to relate to $Topic within the scope defined in the <a href="/faq">FAQ</a>. Consider editing the question or leaving comments for improvement if you believe the question can be reworded to fit within the scope. Read more about <a href="/faq#close">closed questions</a> here.' ),
  ( 3, 'not constructive', 'As it currently stands, this question is not a good fit for our Q&A format. We expect answers to be supported by facts, references, or specific expertise, but this question will likely solicit debate, arguments, polling, or extended discussion. If you feel that this question can be improved and possibly reopened, <a href="/faq#close">see the FAQ</a> for guidance.' ),
  ( 4, 'not a real question', 'It''s difficult to tell what is being asked here. This question is ambiguous, vague, incomplete, overly broad, or rhetorical and cannot be reasonably answered in its current form. For help clarifying this question so that it can be reopened, <a href="/faq#close">see the FAQ</a>.' ),
  ( 7, 'too localized', 'This question is unlikely to help any future visitors; it is only relevant to a small geographic area, a specific moment in time, or an extraordinarily narrow situation that is not generally applicable to the worldwide audience of the internet. For help making this question more broadly applicable, <a href="/faq#close">see the FAQ</a>.' ),
  ( 10, 'general reference', NULL ),
  ( 20, 'noise of pointless', NULL ),
  ( 101, 'duplicate', NULL ),
  ( 102, 'off-topic', NULL ),
  ( 103, 'unclear what you''re asking', NULL ),
  ( 104, 'too broad', NULL ),
  ( 105, 'primarily opinion-based', NULL );


-- VoteType TABLE
DROP TABLE IF EXISTS VoteTypes;
CREATE TABLE VoteTypes (
     Id     int PRIMARY KEY,
     Name   text
);
INSERT INTO VoteTypes VALUES
  ( 1, 'AcceptedByOriginator'   ),
  ( 2, 'UpMod'                  ),
  ( 3, 'DownMod'                ),
  ( 4, 'Offensive'              ),
  ( 5, 'Favorite'               ),
  ( 6, 'Close'                  ),
  ( 7, 'Reopen'                 ),
  ( 8, 'BountyStart'            ),
  ( 9, 'BountyClose'            ),
  ( 10, 'Deletion'              ),
  ( 11, 'Undeletion'            ),
  ( 12, 'Spam'                  ),
  ( 15, 'ModeratorReview'       ),
  ( 16, 'ApproveEditSuggestion' );

-- ReviewTaskTypes TABLE
DROP TABLE IF EXISTS ReviewTaskTypes;
CREATE TABLE ReviewTaskTypes (
    Id            int  PRIMARY KEY,
    Name          text            ,
    Description   text
);
INSERT INTO ReviewTaskTypes VALUES
  ( 1, 'Suggested Edit', 'Approve, reject, or improve edits suggested by users' ),
  ( 2, 'Close Votes', 'Review questions with close votes' ),
  ( 3, 'Low Quality Posts', 'Review automatically detected low-quality posts' ),
  ( 4, 'First Post', 'Review first posts by new users' ),
  ( 5, 'Late Answer', 'Review late answers by new users' ),
  ( 6, 'Reopen Vote', 'Review questions with reopen votes' ),
  ( 7, 'Community Evaluation', 'Review the quality of questions randomly selected from the site' ),
  ( 8, 'Link Validation', 'Review and suggest fixes for possibly-broken links' ),
  ( 9, 'Flagged Posts', 'Moderators review posts with active flags' ),
  ( 10, 'Triage', 'Help identify the quality of questions' );

-- ReviewTaskResultType TABLE
DROP TABLE IF EXISTS ReviewTaskResultType;
CREATE TABLE ReviewTaskResultType (
    Id            int  PRIMARY KEY ,
    Name          text             ,
    Description   text
);
INSERT INTO ReviewTaskResultType VALUES
  ( 1, 'Not Sure', 'Skipped the review task' ),
  ( 2, 'Approve', 'Voted to approve the suggested edit' ),
  ( 3, 'Reject', 'Voted to reject the suggested edit' ),
  ( 4, 'Delete', 'Voted to delete the post' ),
  ( 5, 'Edit', 'Edited the post' ),
  ( 6, 'Close', 'Voted to close the question' ),
  ( 7, 'Looks Good', 'Nothing looked wrong with the post' ),
  ( 8, 'Do Not Close', 'Nothing looked wrong with the question' ),
  ( 9, 'Recommend Deletion', 'Recommended that the post be deleted (user didn''t have delete privileges)' ),
  ( 10, 'Recommend Close', 'Recommended that the question be closed (user didn''t have close privileges)' ),
  ( 11, 'I''m Done', 'Finished reviewing the post' ),
  ( 12, 'Reopen', 'Voted to reopen the question' ),
  ( 13, 'Leave Closed', 'Do not reopen the question' ),
  ( 14, 'Edit and Reopen', 'Edited and voted to reopen the question' ),
  ( 15, 'Excellent', 'Reviewed the content quality as "excellent"' ),
  ( 16, 'Satisfactory', 'Reviewed the content quality as "satisfactory"' ),
  ( 17, 'Needs Improvement', 'Reviewed the content quality as "needs improvement"' ),
  ( 18, 'No Action Needed', 'Reviewed the content and no action was needed' ),
  ( 19, 'Reject and Edit', 'Reject the suggested edit and provide a new edit' ),
  ( 20, 'Should Be Improved', 'Questions that would benefit from futher revision by the author or others' ),
  ( 21, 'Unsalvageable', 'Questions that are unsalvagable and should be removed from the site' );
