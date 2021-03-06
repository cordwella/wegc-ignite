from flask import Flask, request, session, redirect, url_for, \
    abort, render_template, flash, send_from_directory
import MySQLdb
from hashids import Hashids
from flask.ext.bcrypt import Bcrypt
from itsdangerous import URLSafeTimedSerializer
from decorators import async, login_required
from admin import admin

app = Flask(__name__)
app.config.from_pyfile('application.cfg', silent=True)
app.register_blueprint(admin, url_prefix='/admin')
bcrypt = Bcrypt(app)


@app.route('/')
def index():
    data = query_db("SELECT * FROM house_points")
    return render_template('index.html', house_points=data)

@app.route('/login', methods=['GET', 'POST'])
@app.route('/login/redirect/<path:nextu>', methods=['GET', 'POST'])
def login(nextu=None):
    error = None
    if session.get('username'):
        return redirect(url_for('index'))
    if request.method == "POST":
        username = clean_str(request.form['username'])
        password = clean_str(request.form['password'])
        if '@' in username:
            data = query_db('SELECT * FROM users WHERE email = %s',[username])
        else:
            data = query_db('SELECT * FROM users WHERE uname = %s',[username])

        if len(data) == 0:
            error = 'Invalid username'
        elif bcrypt.check_password_hash(data[0]['pwhash'], password):
            session['username'] = data[0]['uname']
            session['user_id'] = data[0]['id']
            flash('You were logged in')
            if nextu:
                nextu = "http://" + nextu
                return redirect(nextu)
            return redirect(url_for('index'))
        else:
            error = 'Invalid Password'
    return render_template('login.html', error=error, nextu=nextu)

@app.route('/adduser', methods=['GET', 'POST'])
def add_user():
    # TODO: add better error handling
    error = None
    username = None
    email = None
    if session.get('username'):
        return redirect(url_for('index'))
    if request.method == "POST":
        username = request.form['username']
        password = clean_str(request.form['password'])
        house_id = request.form['house']
        email = request.form['email']
        if not is_clean_username(username):
            error = "Username must contain only alpha-numeric characters, and must be between 5 and 12 characters"
        elif not email_validate(email):
            error = "Invalid Email Address"
        elif username and password: ## basically not null
            try:
                data = query_db('INSERT INTO users(uname, pwhash, email, house_id) values(%s, %s, %s, %s)',[username, bcrypt.generate_password_hash(password), email, house_id])
                session['username'] = username
                session['user_id'] = query_db('SELECT id FROM users where uname = %s',[username])[0]['id']
                flash('You were logged in')
                house = query_db('SELECT name FROM houses where id = %s',[house_id])[0]['name']
                msg = render_template("newaccount.html", username=username, email=email, house=house)
                send_email(email, msg, 'New Account Notification | Ignite')
                flash("Email Sent to " + email)
                return redirect(url_for('index'))
            except MySQLdb.Error, e:
                if e.args[0] == 1062:
                    if 'email' in e.args[1]:
                        error = "Email already in use. You may already have an account. Try the forgot password link below"
                    elif 'uname' in e.args[1]:
                        error = "Username already in use. Be more creative"
                else:
                    error = "Database Error. %s %s" % (e.args[0], e.args[1])
        else:
            error = "Invalid Username Or Password"
    houses = query_db("SELECT * FROM houses")
    return render_template('adduser.html', error=error, houses=houses, email=email, username=username)


@app.route('/logout')
def logout():
    session.pop('username', None)
    session.pop('user_id', None)
    flash('You were logged out')
    return redirect(url_for('index'))

@app.route('/forgotpass', methods=['GET','POST'])
def lost_password():
    if session.get('username'):
        flash("You've already logged in!!")
        return redirect(url_for('index'))

    if request.method == "POST":
        email = request.form['email']
        # check email address in db and get username
        try:
            username = query_db("SELECT * FROM users WHERE email = %s", [email])[0]['uname']
        except:
            flash("Email Address not found")
            return render_template('lostpass.html')

        ts = URLSafeTimedSerializer(app.config["SECRET_KEY"])
        token = ts.dumps(email)
        confirm_url = url_for("resetpassword", serial_tag=token, _external=True)

        msg = render_template("lostpassemail.html", confirm_url=confirm_url, username=username)
        send_email(email, msg, "Forgot Password? | Ignite")
        flash("Email Sent to " + email)
        return redirect(url_for('login'))

    return render_template('lostpass.html')

@app.route('/resetpassword/<serial_tag>', methods=['GET','POST'])
def resetpassword(serial_tag):
    ts = URLSafeTimedSerializer(app.config["SECRET_KEY"])
    try:
        email = ts.loads(serial_tag, max_age=14400)
        username = query_db("SELECT * FROM users WHERE email = %s", [email])[0]['uname']
    except:
        abort(404)

    if request.method == "POST":
        password = request.form['password']
        if password == request.form['confpassword']:
            try:
                data = query_db('UPDATE users SET pwhash = %s WHERE email = %s', [bcrypt.generate_password_hash(password), email])
            except:
                abort(500)
            flash("Password has been reset")
            return redirect(url_for('login'))
        flash("Passwords do not match")
    return render_template("resetpass.html",username=username, url=request.url)

@async
def send_email(toadrr,message, subject, fromaddr="ignite.wegc@gmail.com",):
    import smtplib
    from email.mime.multipart import MIMEMultipart
    from email.mime.text import MIMEText
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = "Ignite Admin"
    msg['To'] = toadrr
    part2 = MIMEText(message, 'html')
    msg.attach(part2)

    username = app.config['EMAIL_USER']
    password = app.config['EMAIL_PASS']

    # Sending the mail

    server = smtplib.SMTP('smtp.gmail.com:587')
    server.starttls()
    server.login(username,password)
    if app.config['DEBUG']:
        server.sendmail(fromaddr, app.config['TEST_EMAIL'],msg.as_string())
    else:
        server.sendmail(fromaddr, msg['To'], msg.as_string())
    server.quit()


@app.route('/user/<int:user_id>')
def show_user_profile(user_id):
    # show the user profile for that user
    try:
        user = query_db("SELECT * FROM users_with_house WHERE id = %s", [user_id])[0]
    except MySQLdb.Error, e:
        abort(404)
    except IndexError, e:
        abort(404)
    return render_template("user.html", user=user)

@app.route('/torch/<int:marker_id>')
def show_marker(marker_id):
    # show the marker profile
    try:
        marker = query_db("SELECT * FROM markers_with_houses WHERE id = %s", [marker_id])[0]
    except MySQLdb.Error, e:
        abort(404)
    except IndexError, e:
        abort(404)
    return render_template("marker.html", marker=marker)

@app.route('/house/<int:house_id>')
def show_house(house_id):
    # show the user profile for that user
    try:
        house = query_db("SELECT * FROM houses WHERE id = %s", [house_id])[0]
    except MySQLdb.Error, e:
        abort(404)
    except IndexError, e:
        abort(404)
    return render_template("house.html", house=house)

@app.route('/scan/<scan_id>')
@login_required
def scan_marker(scan_id):
    hashid = Hashids(min_length=6, salt=app.config['HASHID_KEY'])
    try:
        marker_id = hashid.decode(scan_id)[0]
    except IndexError:
        abort(404)
    try:
        asas = query_db("INSERT INTO scans (user_id, marker_id) values(%s, %s)", [str(session.get('user_id')), str(marker_id)])
    except MySQLdb.Error, e:
        if e.args[0] == 1452:
            abort(404)
        elif e.args[0] == 1062:
            flash("You've already scanned this torch.")
        else:
            flash("Database Error. %s %s" % (e.args[0], e.args[1]))

    return redirect(url_for("show_marker", marker_id=marker_id))

## Context Processors
@app.context_processor
def utility_processor():
    def recent_scans(column="all", wid=None, amount=20):
        # TODO: date-timehandeling
        data = []
        if(column == "user"):
            data = query_db("SELECT * FROM scan_info WHERE user_id = %s order by scan_time desc limit 20", [wid])
        elif(column == "house"):
            data = query_db("SELECT * FROM scan_info WHERE uhouse_id = %s order by scan_time desc limit 20", [wid])
        elif(column == "marker"):
            data = query_db("SELECT * FROM scan_info WHERE marker_id = %s order by scan_time desc limit 20", [wid])
        else:
            data = query_db("SELECT * FROM scan_info order by scan_time desc limit 20")
        return render_template("recent_scans.html", scans=data)

    def generate_graph():
        houses = query_db("SELECT * FROM houses ORDER BY name")
        data = []
        graph_data = []

        lowest_hour = None
        highest_hour = None
        no_houses = 0

        if(len(query_db("SELECT * FROM scans")) < 1):
            return "No Scans Yet. </br>"
        for house in houses:
            # We need to know the range of the data but not all houses will have the same range
            # Normally a long query like this would be put inside a view but due to how its calculated
            # that is impossible in this case
            current_data = query_db("SELECT sum(point_value) as points, (hour(scan_time) + day(scan_time)*24) as hour from scan_info where uhouse_id = %s group by hour(scan_time) order by (hour(scan_time) + day(scan_time)*24)", [house['id']] )
            data.append(current_data)
            no_houses = no_houses + 1

            if len(current_data) > 0: ## IE if there has been scans try to get the times
                if lowest_hour == None or current_data[0]['hour'] < lowest_hour:
                    lowest_hour = current_data[0]['hour']

                if highest_hour == None or current_data[len(current_data)-1]['hour'] > highest_hour:
                    highest_hour = current_data[len(current_data)-1]['hour']

        house_pos = [0,0,0,0]

        for i in range(highest_hour - lowest_hour +2):
            row = dict()
            row["hour"] = i
            for n in range(no_houses):
                try:
                    prevvalue = graph_data[i-1][n]
                except:
                    prevvalue = 0

                if house_pos[n] < len(data[n]):
                    if int(data[n][house_pos[n]].get('hour', 0) - lowest_hour) == i:

                        row[n] = data[n][house_pos[n]].get('points', 0) + prevvalue
                        house_pos[n] = house_pos[n] + 1

                    else:
                        row[n] = prevvalue
                else:
                    row[n] = prevvalue
            graph_data.append(row)
        return render_template("time-graph.html", houses=houses, graph_data=graph_data)

    return dict(recent_scans=recent_scans, generate_graph=generate_graph)

##STATIC PAGES
@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/gameplay')
def gameplay():
    return render_template('gameplay.html')

@app.route('/support')
def support():
    return render_template('support.html')

@app.route('/housegraph')
def housegraph():
    return render_template('housegraph.html')

@app.route('/recent_scans_page')
def recent_scans_page():
    return render_template('recent_scans_page.html')

@app.route('/torch_registry')
def torch_registry():
    torches = query_db("SELECT * from markers_with_houses")
    return render_template('torch_registry.html', torches=torches)

@app.route('/topusers')
def topusers():
    users = query_db("SELECT * from users_with_house ORDER BY points DESC limit 30")
    return render_template('topuser.html', users=users)


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

@app.errorhandler(500)
def error_401(error):
    return render_template('errorpage.html', errorcode="500", message="Error (sorry, contact the site admins for more info)"), 500


# Database shisazt
def connect_db():
    return MySQLdb.connect(host=app.config['DB_HOST'],    # your host, usually localhost
                         user=app.config['DB_USER'],         # your username
                         passwd=app.config['DB_PASS'],  # your password
                         db=app.config['DB_NAME'])        # name of the data base

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
    import pkg_resources, os
    resource_package = __name__  ## Could be any module/package name.
    resource_path = os.path.join('banned-words.csv')
    text = pkg_resources.resource_string(resource_package, resource_path)
    banned_words = text.split(',')
    for word in banned_words:
        if word in s:
            return False
    return s.isalnum() and len(s) >= 5 and len(s) <= 12

def bad_password_check(s):
    if(len(clean_str(s)) >= 5):
        return clean_str(s)
    return False

def email_validate(s):
    import re
    #[^@]+@[^@]+\.[^@]+
    return re.match("[^@]+@[^@]+\.[^@]+", s) and clean_str(s)

if __name__ == '__main__':
    app.run(host='0.0.0')
