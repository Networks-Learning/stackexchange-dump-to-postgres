# StackOverflow data to postgres

This is a quick script to move the Stackoverflow data from the [StackExchange data dump (Sept '14)](https://archive.org/details/stackexchange) to a Postgres SQL database.

## Dependencies

 - [`lxml`](http://lxml.de/installation.html)
 - [`psychopg2`](http://initd.org/psycopg/docs/install.html)
 - Python 2.7 compatible

## Usage

 - Create the database `stackoverflow` in your database: `CREATE DATABASE stackoverflow`
 - Move the following files to the folder from where the program is executed:
   `Badges.xml`, `Votes.xml`, `Posts.xml`, `Users.xml`, `Tags.xml`.
 - Execute in the current:
   - `python load_into_pg.py Badges`
   - `python load_into_pg.py Posts`
   - `python load_into_pg.py Tags`
   - `python load_into_pg.py Users`
   - `python load_into_pg.py Votes`

## Caveats and TODO

 - It prepares some indexes which may not be necessary
 - The `body` field in `Posts` table is NOT populated.
 - The database settings are not configurable.
 - In order to create more tables (e.g. other tables at [data.StackExchange](http://data.stackexchange.com/), some additional scripts are needed.

