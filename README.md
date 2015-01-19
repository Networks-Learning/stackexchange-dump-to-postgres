# StackOverflow data to postgres

This is a quick script to move the Stackoverflow data from the [StackExchange data dump (Sept '14)](https://archive.org/details/stackexchange) to a Postgres SQL database.

Schema hints are taken from [a post on Meta.StackExchange](http://meta.stackexchange.com/questions/2677/database-schema-documentation-for-the-public-data-dump-and-sede) and from [StackExchange Data Explorer](http://data.stackexchange.com).

## Dependencies

 - [`lxml`](http://lxml.de/installation.html)
 - [`psychopg2`](http://initd.org/psycopg/docs/install.html)
 - Python 2.7 compatible

## Usage

 - Create the database `stackoverflow` in your database: `CREATE DATABASE stackoverflow;`
 - Move the following files to the folder from where the program is executed:
   `Badges.xml`, `Votes.xml`, `Posts.xml`, `Users.xml`, `Tags.xml`.
 - Execute in the current folder (in parallel, if desired):
   - `python load_into_pg.py Badges`
   - `python load_into_pg.py Posts`
   - `python load_into_pg.py Tags` (only present in later dumps)
   - `python load_into_pg.py Users`
   - `python load_into_pg.py Votes`
 - Finally, after all the initial tables have been created:
   - `psql stackoverflow < ./sql/final_post.sql`

## Caveats and TODOs

 - It prepares some indexes and views which may not be necessary for your analysis.
 - The `body` field in `Posts` table is NOT populated.
 - The `emailhash` field in `Users` table is NOT populated.
 - Some tables (e.g. `PostHistory` and `Comments`) are missing.

### Sept 2011 data dump

 - The `tags.xml` is missing from the data dump. Hence, the `PostTag` and `UserTagQA` tables will be empty after `final_post.sql`.
 - The `ViewCount` in `Posts` is sometimes equal to an `empty` value. It is replaced by `NULL` in those cases.
