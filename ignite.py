from flask import Flask, request, session, redirect, url_for, \
    abort, render_template, flash
import MySQLdb

DEBUG = True
SECRET_KEY = 'development key'

app = Flask(__name__)
app.config.from_object(__name__)

@app.route('/')
def index():
    data = query_db('select * from entries_with_author order by id desc')
    entries = [dict(title=row['title'], text=row['entry'], author=row['username']) for row in data]
    return render_template('show_entries.html', entries=entries)

@app.route('/user/<int:user_id>')
def show_user_profile(user_id):
    # show the user profile for that user
    return 'User %s' % user_id

@app.route('/torch/<int:marker_id>')
def show_marker(marker_id):
    # show the user profile for that user
    return 'Marker %s' % marker_id

@app.route('/house/<int:house_id>')
def show_house(house_id):
    # show the user profile for that user
    return 'House %s' % house_id


@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if session.get('username'):
        return redirect(url_for('index'))

    ## TODO: allow entry by email address
    if request.method == "POST":
        username = clean_str(request.form['username'])
        password = clean_str(request.form['password'])
        data = query_db('SELECT * FROM users WHERE username = %s',[username])
        if len(data) == 0:
            error = 'Invalid username'
        elif data[0]['password'] == password:
            session['username'] = username
            session['user_id'] = query_db('SELECT id FROM users where username = %s',[username])[0]['id']
            flash('You were logged in')
            return redirect(url_for('index'))
        else:
            error = 'Invalid Password'

    return render_template('login.html', error=error)

@app.route('/adduser', methods=['GET', 'POST'])
def add_user():
    error = None
    if session.get('username'):
        return redirect(url_for('index'))
    if request.method == "POST":
        username = request.form['username']
        password = clean_str(request.form['password'])
        if not is_clean_username(username):
            error = "Username must contain only alpha-numeric characters, and must be between 5 and 12 characters"
        elif password != request.form['repassword']:
            error = "Passwords must match"
        elif request.form['email'] != request.form['reemail']:
            error = "Emails must match"
        elif not email_validate(request.form['email']):
            error = "Invalid Email Address"
        elif username and password: ## basically not null
            #return str(username) + " " + str(password)
            try:
                data = query_db('INSERT INTO users(username, password) values(%s, %s, %s)',[username, password, request.form['email']])
                session['username'] = username
                session['user_id'] = query_db('SELECT id FROM users where username = %s',[username])[0]['id']
                flash('You were logged in')
                return redirect(url_for('index'))
            except MySQLdb.Error, e:
                if e.args[0] == 1604:
                    error = "Username already in use. Be more creative"
                else:
                    error = "Database Error. %s %s" % (e.args[0], e.args[1])
        else:
            error = "Invalid Username Or Password"
    return render_template('adduser.html', error=error)


@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('user_id', None)
    flash('You were logged out')
    return redirect(url_for('index'))

@app.route('/add', methods=['POST'])
def add_entry():
    if not session.get('username'):
        abort(401)
    query_db('insert into entries (title, entry, user_id) values (%s, %s, %s)',
                 [request.form['title'], request.form['text'], session['user_id']])
    flash('New entry was successfully posted')
    return redirect(url_for('index'))

@app.route('/forgotpass', methods=['GET','POST'])
def lost_password():
    if session.get('username'):
        return redirect(url_for('index'))
    flash("testing password")
    return redirect(url_for('login'))

## Context Processors
@app.context_processor
def utility_processor():
    def most_recent_scans(type, id, amount=20):
        return "This is a list of the most recent scans"
    return dict(format_price=format_price)

## Error Handlers
@app.errorhandler(404)
def error_404(error):
    return render_template('errorpage.html', errorcode="404", message="Page not found on this server. Maybe check the URL?"), 404

@app.errorhandler(401)
def error_401(error):
    return render_template('errorpage.html', errorcode="401", message="Login brah. Unauthorised."), 401

@app.errorhandler(405)
def error_405(error):
    return render_template('errorpage.html', errorcode="405", message="What are you even trying to do? Wrong method"), 405


# Database shisazt
def connect_db():
    return MySQLdb.connect(host="localhost",    # your host, usually localhost
                         user="root",         # your username
                         passwd="4Bl@@psSake",  # your password
                         db="ignite")        # name of the data base

def query_db(query, values=0):
    """ Query DB & commit """
    db = connect_db()
    cur = db.cursor(MySQLdb.cursors.DictCursor)
    if isinstance(values, (list, tuple)):
        cur.execute(query, values)
    else:
        cur.execute(query)
    output = cur.fetchall()
    db.commit()
    db.close()
    return output

### Users More like losers amirite?
# TODO: this, better, less convoluted
def clean_str(s):
    try:
        s.decode('ascii')
    except:
        return False
    ## Check For html
    return s

def is_clean_username(s):
    return s.isalnum() and len(s) >= 5 and len(s) <= 12

def bad_password_check(s):
    if(len(clean_str(s)) >= 5):
        return clean_str(s)
    return False

def email_validate(s):
    #[^@]+@[^@]+\.[^@]+
    return re.match("[^@]+@[^@]+\.[^@]+", s) and clean_str(s)

if __name__ == '__main__':
    app.run()