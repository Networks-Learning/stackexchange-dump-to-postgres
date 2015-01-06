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
   - `python load_into_pg.py Tags`
   - `python load_into_pg.py Users`
   - `python load_into_pg.py Votes`
 - Finally, after all the initial tables have been created:
   - `psql stackoverflow < ./sql/final_post.sql`

## Caveats and TODOs

 - It prepares some indexes which may not be necessary for your analysis.
 - The `body` field in `Posts` table is NOT populated.
 - The database settings are not configurable.
 - Some tables (e.g. `PostHistory` and `Comments`) are missing.

