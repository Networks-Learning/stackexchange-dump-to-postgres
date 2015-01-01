import psycopg2 as pg
import row_processor as Processor

choice = raw_input('This will drop the Users table. Are you sure [y/n]?')
conn   = pg.connect("dbname=stackoverflow")
cur    = conn.cursor()

defUsersValues = {
    'Id'             : None
  , 'Reputation'     : None
  , 'CreationDate'   : None
  , 'DisplayName'    : None
  , 'LastAccessDate' : None
  , 'WebsiteUrl'     : None
  , 'Location'       : None
  , 'AboutMe'        : None
  , 'Views'          : None
  , 'UpVotes'        : None
  , 'DownVotes'      : None
  , 'AccountId'      : None
};

def createCmdTuple(attribs):
    safeAttribs = defUsersValues.copy()
    safeAttribs.update(attribs)
    return cur.mogrify(
         '( %(Id)s            ' +
         ', %(Reputation)s    ' +
         ', %(CreationDate)s  ' +
         ', %(DisplayName)s   ' +
         ', %(LastAccessDate)s' +
         ', %(WebsiteUrl)s    ' +
         ', %(Location)s      ' +
         ', %(AboutMe)s       ' +
         ', %(Views)s         ' +
         ', %(UpVotes)s       ' +
         ', %(DownVotes)s     ' +
         ', %(AccountId)s     ' +
         ')',
         safeAttribs
    )

if choice[0].lower() == 'y':
    users_pre  = file('Users_pre.sql').read()
    users_post = file('Users_post.sql').read()

    users_xml  = file('Users.xml')

    if users_pre != '':
        cur.execute(users_pre)
        conn.commit()

    for rows in Processor.batch(Processor.parse(users_xml), 50):
        values = ',\n'.join(
                [ createCmdTuple(row_attribs) for row_attribs in rows ]
              )

        # There is a chance that `rows` were empty
        if len(values) > 0:
            cmd = 'INSERT INTO Users VALUES \n' + values + ';'
            cur.execute(cmd)
            conn.commit()

    if users_post != '':
        cur.execute(users_post)
        conn.commit()
else:
    print ('Cancelled')


