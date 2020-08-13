# StackOverflow data to postgres

This is a quick script to move the Stackoverflow data from the [StackExchange data dump (Sept '14)](https://archive.org/details/stackexchange) to a Postgres SQL database.

Schema hints are taken from [a post on Meta.StackExchange](http://meta.stackexchange.com/questions/2677/database-schema-documentation-for-the-public-data-dump-and-sede) and from [StackExchange Data Explorer](http://data.stackexchange.com).

## Dependencies

 - [`lxml`](http://lxml.de/installation.html)
 - [`psycopg2`](http://initd.org/psycopg/docs/install.html)
 - [`libarchive-c`](https://pypi.org/project/libarchive-c/)

## Usage

 - Create the database `stackoverflow` in your database: `CREATE DATABASE stackoverflow;`
   - You can use a custom database name as well. Make sure to explicitly give
     it while executing the script later.
 - Move the following files to the folder from where the program is executed:
   `Badges.xml`, `Votes.xml`, `Posts.xml`, `Users.xml`, `Tags.xml`.
   - In some old dumps, the cases in the filenames are different.
 - Execute in the current folder (in parallel, if desired):
   - `python load_into_pg.py -t Badges`
   - `python load_into_pg.py -t Posts`
   - `python load_into_pg.py -t Tags` (not present in earliest dumps)
   - `python load_into_pg.py -t Users`
   - `python load_into_pg.py -t Votes`
   - `python load_into_pg.py -t PostLinks`
   - `python load_into_pg.py -t PostHistory`
   - `python load_into_pg.py -t Comments`
 - Finally, after all the initial tables have been created:
   - `psql stackoverflow < ./sql/final_post.sql`
   - If you used a different database name, make sure to use that instead of
     `stackoverflow` while executing this step.
 - For some additional indexes and tables, you can also execute the the following;
   - `psql stackoverflow < ./sql/optional_post.sql`
   - Again, remember to user the correct database name here, if not `stackoverflow`.

## Loading a complete stackexchange project

You can use the script to download a given stackexchange compressed file from
[archive.org](https://ia800107.us.archive.org/27/items/stackexchange/) and load
all the tables at once, using the `-s` switch.

You will need the `urllib` and `libarchive-c` modules.

If you give a schema name using the `-n` switch, all the tables will be moved
to the given schema. This schema will be created in the script.

To load the _dba.stackexchange.com_ project in the `dba` schema, you would execute:
`./load_into_pg.py -s dba -n dba`

The paths are not changed in the final scripts `sql/final_post.sql` and
`sql/optional_post.sql`. To run them, first set the _search_path_ to your
schema name: `SET search_path TO <myschema>;`

## Caveats and TODOs

 - It prepares some indexes and views which may not be necessary for your analysis.
 - The `Body` field in `Posts` table is NOT populated by default. You have to use `--with-post-body` argument to include it.
 - The `EmailHash` field in `Users` table is NOT populated.

### Sept 2011 data dump

 - The `tags.xml` is missing from the data dump. Hence, the `PostTag` and `UserTagQA` tables will be empty after `final_post.sql`.
 - The `ViewCount` in `Posts` is sometimes equal to an `empty` value. It is replaced by `NULL` in those cases.


## Acknowledgement

[@madtibo](https://github.com/madtibo) made significant contributions by adding `jsonb` and Foreign Key support.
