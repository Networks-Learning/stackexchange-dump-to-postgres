# StackOverflow data to postgres

This is a quick script to move the Stackoverflow data from the [StackExchange
data dump (Sept '14)](https://archive.org/details/stackexchange) to a Postgres
SQL database.

Schema hints are taken from [a post on
Meta.StackExchange](http://meta.stackexchange.com/questions/2677/database-schema-documentation-for-the-public-data-dump-and-sede)
and from [StackExchange Data Explorer](http://data.stackexchange.com).

## Quickstart

Install requirements, create a new database (e.g. `beerSO` below), and use `load_into_pg.py` script:

``` console
$ pip install -r requirements.txt
...
Successfully installed argparse-1.2.1 libarchive-c-2.9 lxml-4.5.2 psycopg2-binary-2.8.4 six-1.10.0
$ createdb beerSO
$ python load_into_pg.py -s beer -d beerSO
```

This will download compressed files from
[archive.org](https://ia800107.us.archive.org/27/items/stackexchange/) and load
all the tables at once.


## Advanced Usage

You can use a custom database name as well. Make sure to explicitly give it
while executing the script later.

Each table data is archived in an XML file. Available tables varies accross
history. `load_into_pg.py` knows how to handle the following tables:

- `Badges`.
- `Posts`.
- `Tags` (not present in earliest dumps).
- `Users`.
- `Votes`.
- `PostLinks`.
- `PostHistory`.
- `Comments`.

You can download manually the files to the folder from where the program is
executed: `Badges.xml`, `Votes.xml`, `Posts.xml`, `Users.xml`, `Tags.xml`. In
some old dumps, the cases in the filenames are different.

Then load each file with e.g. `python load_into_pg.py -t Badges`.

After all the initial tables have been created:

``` console
$ psql beerSO < ./sql/final_post.sql
```

For some additional indexes and tables, you can also execute the the following;

``` console
$ psql beerSO < ./sql/optional_post.sql
```

If you give a schema name using the `-n` switch, all the tables will be moved
to the given schema. This schema will be created in the script.

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

 - [@madtibo](https://github.com/madtibo) made significant contributions by adding `jsonb` and Foreign Key support.
 - [@bersace](https://github.com/bersace) brought the dependencies and the `README.md` instructions into 2020s.
 - [@rdrg109](https://github.com/rdrg109) simplified handling of non-public schemas and fixed bugs associated with re-importing tables.
