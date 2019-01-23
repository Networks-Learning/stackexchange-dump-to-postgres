#!/usr/bin/env python
import sys
import time
import argparse
import psycopg2 as pg
import row_processor as Processor
import six
import json

# Special rules needed for certain tables (esp. for old database dumps)
specialRules = {
    ('Posts', 'ViewCount'): "NULLIF(%(ViewCount)s, '')::int"
}

def _makeDefValues(keys):
    """Returns a dictionary containing None for all keys."""
    return dict(( (k, None) for k in keys ))

def _createMogrificationTemplate(table, keys, insertJson):
    """Return the template string for mogrification for the given keys."""
    table_keys = ', '.join( [ '%(' + k + ')s' if (table, k) not in specialRules
                              else specialRules[table, k]
                              for k in keys ])
    if insertJson:
        return ('(' + table_keys + ', %(jsonfield)s' + ')')
    else:
        return ('(' + table_keys + ')')

def _createCmdTuple(cursor, keys, templ, attribs, insertJson):
    """Use the cursor to mogrify a tuple of data.
    The passed data in `attribs` is augmented with default data (NULLs) and the
    order of data in the tuple is the same as in the list of `keys`. The
    `cursor` is used to mogrify the data and the `templ` is the template used
    for the mogrification.
    """
    defs = _makeDefValues(keys)
    defs.update(attribs)

    if insertJson:
        dict_attribs = { }
        for name, value in attribs.items():
            dict_attribs[name] = value
        defs['jsonfield'] = json.dumps(dict_attribs)

    values_to_insert = cursor.mogrify(templ, defs)
    return cursor.mogrify(templ, defs)

def _getTableKeys(table):
    """Return an array of the keys for a given table"""
    keys = None
    if table == 'Users':
        keys = [
            'Id'
            , 'Reputation'
            , 'CreationDate'
            , 'DisplayName'
            , 'LastAccessDate'
            , 'WebsiteUrl'
            , 'Location'
            , 'AboutMe'
            , 'Views'
            , 'UpVotes'
            , 'DownVotes'
            , 'ProfileImageUrl'
            , 'Age'
            , 'AccountId'
        ]
    elif table == 'Badges':
        keys = [
            'Id'
            , 'UserId'
            , 'Name'
            , 'Date'
        ]
    elif table == 'PostLinks':
        keys = [
            'Id'
            , 'CreationDate'
            , 'PostId'
            , 'RelatedPostId'
            , 'LinkTypeId'
        ]
    elif table == 'Comments':
        keys = [
            'Id'
            , 'PostId'
            , 'Score'
            , 'Text'
            , 'CreationDate'
            , 'UserId'
        ]
    elif table == 'Votes':
        keys = [
            'Id'
            , 'PostId'
            , 'VoteTypeId'
            , 'UserId'
            , 'CreationDate'
            , 'BountyAmount'
        ]
    elif table == 'Posts':
        keys = [
            'Id'
            , 'PostTypeId'
            , 'AcceptedAnswerId'
            , 'ParentId'
            , 'CreationDate'
            , 'Score'
            , 'ViewCount'
            , 'Body'
            , 'OwnerUserId'
            , 'LastEditorUserId'
            , 'LastEditorDisplayName'
            , 'LastEditDate'
            , 'LastActivityDate'
            , 'Title'
            , 'Tags'
            , 'AnswerCount'
            , 'CommentCount'
            , 'FavoriteCount'
            , 'ClosedDate'
            , 'CommunityOwnedDate'
        ]
    elif table == 'Tags':
        keys = [
            'Id'
            , 'TagName'
            , 'Count'
            , 'ExcerptPostId'
            , 'WikiPostId'
        ]
    elif table == 'PostHistory':
        keys = [
            'Id',
            'PostHistoryTypeId',
            'PostId',
            'RevisionGUID',
            'CreationDate',
            'UserId',
            'Text'
        ]
    elif table == 'Comments':
        keys = [
            'Id',
            'PostId',
            'Score',
            'Text',
            'CreationDate',
            'UserId',
        ]
    return keys

def handleTable(table, insertJson, createFk, dbname, mbDbFile, mbHost, mbPort, mbUsername, mbPassword):
    """Handle the table including the post/pre processing."""
    keys       = _getTableKeys(table)
    dbFile     = mbDbFile if mbDbFile is not None else table + '.xml'
    tmpl       = _createMogrificationTemplate(table, keys, insertJson)
    start_time = time.time()

    try:
        pre    = open('./sql/' + table + '_pre.sql').read()
        post   = open('./sql/' + table + '_post.sql').read()
        fk     = open('./sql/' + table + '_fk.sql').read()
    except IOError as e:
        six.print_("Could not load pre/post/fk sql. Are you running from the correct path?", file=sys.stderr)
        sys.exit(-1)

    dbConnectionParam = "dbname={}".format(dbname)

    if mbPort is not None:
        dbConnectionParam += ' port={}'.format(mbPort)

    if mbHost is not None:
        dbConnectionParam += ' host={}'.format(mbHost)

    # TODO Is the escaping done here correct?
    if mbUsername is not None:
        dbConnectionParam += ' user={}'.format(mbUsername)

    # TODO Is the escaping done here correct?
    if mbPassword is not None:
        dbConnectionParam += ' password={}'.format(mbPassword)


    try:
        with pg.connect(dbConnectionParam) as conn:
            with conn.cursor() as cur:
                try:
                    with open(dbFile, 'rb') as xml:
                        # Pre-processing (dropping/creation of tables)
                        six.print_('Pre-processing ...')
                        if pre != '':
                            cur.execute(pre)
                            conn.commit()
                        six.print_('Pre-processing took {:.1f} seconds'.format(time.time() - start_time))

                        # Handle content of the table
                        start_time = time.time()
                        six.print_('Processing data ...')
                        for rows in Processor.batch(Processor.parse(xml), 500):
                            valuesStr = ',\n'.join(
                                            [ _createCmdTuple(cur, keys, tmpl, row_attribs, insertJson).decode('utf-8')
                                                for row_attribs in rows
                                            ]
                                        )
                            if len(valuesStr) > 0:
                                cmd = 'INSERT INTO ' + table + \
                                      ' VALUES\n' + valuesStr + ';'
                                cur.execute(cmd)
                                conn.commit()
                        six.print_('Table {0} processing took {1:.1f} seconds'.format(table, time.time() - start_time))

                        # Post-processing (creation of indexes)
                        start_time = time.time()
                        six.print_('Post processing ...')
                        if post != '':
                            cur.execute(post)
                            conn.commit()
                        six.print_('Post processing took {} seconds'.format(time.time() - start_time))
                        if createFk:
                            # fk-processing (creation of foreign keys)
                            start_time = time.time()
                            six.print_('fk processing ...')
                            if post != '':
                                cur.execute(fk)
                                conn.commit()
                            six.print_('fk processing took {} seconds'.format(time.time() - start_time))

                except IOError as e:
                    six.print_("Could not read from file {}.".format(dbFile), file=sys.stderr)
                    six.print_("IOError: {0}".format(e.strerror), file=sys.stderr)
    except pg.Error as e:
        six.print_("Error in dealing with the database.", file=sys.stderr)
        six.print_("pg.Error ({0}): {1}".format(e.pgcode, e.pgerror), file=sys.stderr)
        six.print_(str(e), file=sys.stderr)
    except pg.Warning as w:
        six.print_("Warning from the database.", file=sys.stderr)
        six.print_("pg.Warning: {0}".format(str(w)), file=sys.stderr)

#############################################################

parser = argparse.ArgumentParser()
parser.add_argument( 'table'
                   , help    = 'The table to work on.'
                   , choices = ['Users', 'Badges', 'Posts', 'Tags', 'Votes', 'PostLinks', 'PostHistory', 'Comments']
                   )

parser.add_argument( '-d', '--dbname'
                   , help    = 'Name of database to create the table in. The database must exist.'
                   , default = 'stackoverflow'
                   )

parser.add_argument( '-f', '--file'
                   , help    = 'Name of the file to extract data from.'
                   , default = None
                   )

parser.add_argument( '-u', '--username'
                   , help    = 'Username for the database.'
                   , default = None
                   )

parser.add_argument( '-p', '--password'
                   , help    = 'Password for the database.'
                   , default = None
                   )

parser.add_argument( '-P', '--port'
                   , help    = 'Port to connect with the database on.'
                   , default = None
                   )

parser.add_argument( '-H', '--host'
                   , help    = 'Hostname for the database.'
                   , default = None
                   )

parser.add_argument( '--with-post-body'
                   , help   = 'Import the posts with the post body. Only used if importing Posts.xml'
                   , action = 'store_true'
                   , default = False
                   )

parser.add_argument( '-j', '--insert-json'
                   , help    = 'Insert raw data as JSON.'
                   , action = 'store_true'
                   , default = False
                   )

parser.add_argument( '--foreign-keys'
                   , help    = 'Create foreign keys.'
                   , action = 'store_true'
                   , default = False
                   )

args = parser.parse_args()

table = args.table

try:
    # Python 2/3 compatibility
    input = raw_input
except NameError:
    pass


if table == 'Posts':
    # If the user has not explicitly asked for loading the body, we replace it with NULL
    if not args.with_post_body:
        specialRules[('Posts', 'Body')] = 'NULL'

choice = input('This will drop the {} table. Are you sure [y/n]? '.format(table))
if len(choice) > 0 and choice[0].lower() == 'y':
    handleTable(table, args.insert_json, args.foreign_keys, args.dbname, args.file, args.host, args.port, args.username, args.password)
else:
    six.print_("Cancelled.")
