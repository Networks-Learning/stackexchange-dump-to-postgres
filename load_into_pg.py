import sys
import time
import psycopg2 as pg
import row_processor as Processor

def show_help():
    print "Usage: " + sys.argv[0] + " <Users|Badges|Posts|Tags|Votes> "

def _makeDefValues(keys):
    """Returns a dictionary containing None for all keys."""
    return dict(( (k, None) for k in keys ))

def _createMogrificationTemplate(keys):
    """Return the template string for mogrification for the given keys."""
    return '(' + ', '.join( [ '%(' + k + ')s' for k in keys ] ) + ')'

def _createCmdTuple(cursor, keys, templ, attribs):
    """Use the cursor to mogrify a tuple of data.
    The passed data in `attribs` is augmented with default data (NULLs) and the
    order of data in the tuple is the same as in the list of `keys`. The
    `cursor` is used toe mogrify the data and the `templ` is the template used
    for the mogrification.
    """
    defs = _makeDefValues(keys)
    defs.update(attribs)
    return cursor.mogrify(templ, defs)

def handleTable(table, keys):
    """Handle the table including the post/pre processing."""
    conn   = pg.connect("dbname=stackoverflow")
    cur    = conn.cursor()
    pre    = file(table + '_pre.sql').read()
    post   = file(table + '_post.sql').read()

    xml    = file(table + '.xml')
    tmpl   = _createMogrificationTemplate(keys)

    start_time = time.time()

    # Pre-processing (dropping/creation of tables)
    print 'Pre-processing ...'
    if pre != '':
        cur.execute(pre)
        conn.commit()
    print 'Pre-processing took {} seconds'.format(time.time() - start_time)

    # Handle content of the table
    start_time = time.time()
    print 'Processing data ...'
    for rows in Processor.batch(Processor.parse(xml), 50):
        values = ',\n'.join(
                    [ _createCmdTuple(cur, keys, tmpl, row_attribs)
                        for row_attribs in rows
                    ]
                 )

        if len(values) > 0:
            cmd = 'INSERT INTO ' + table + ' VALUES\n' + values + ';'
            cur.execute(cmd)
            conn.commit()
    print 'Table processing took {} seconds'.format(time.time() - start_time)

    # Post-processing (creation of indexes)
    start_time = time.time()
    print 'Post processing ...'
    if post != '':
        cur.execute(post)
        conn.commit()
    print 'Post processing took {} seconds'.format(time.time() - start_time)

    # Clean up
    cur.close()
    conn.close()


if len(sys.argv) < 2:
    show_help()
else:
    table = sys.argv[1]
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
          , 'AccountId'
        ]
    elif table == 'Badges':
        keys = [
            'Id'
          , 'UserId'
          , 'Name'
          , 'Date'
        ]
    elif table == 'Votes':
        keys = [
            'Id'
          , 'PostId'
          , 'VoteTypeId'
          , 'CreationDate'
        ]
    elif table == 'Posts':
        keys = [
            'Id'
          , 'PostTypeId'
          , 'AcceptedAnswerId'
          , 'CreationDate'
          , 'Score'
          , 'ViewCount'
          # , 'Body'
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

    if keys is None:
        show_help()
    else:
        choice = raw_input('This will drop the {} table. Are you sure [y/n]?'.format(table))

        if len(choice) > 0 and choice[0].lower() == 'y':
            handleTable(table, keys)
        else:
            print "Cancelled"

