from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re


app = Flask(__name__)
# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'promesip'


# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'covid'

# Intialize MySQL
mysql = MySQL(app)

@app.route('/covidDB/', methods=['GET'])

def home():
	
	return render_template('index.html')	


@app.route('/covidDB/login/', methods=['GET','POST'])

def login():
    # Output message if something goes wrong...
	msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
	if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
		username = request.form['username']
		password = request.form['password']
        # Check if account exists using MySQL
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		cursor.execute('SELECT * FROM users WHERE username = %s AND passwd = %s', (username, password,))
        # Fetch one record and return result
		account = cursor.fetchone()
        # If account exists in users table in out database
		if account:
            # Create session data, we can access this data in other routes
			session['loggedin'] = True
			session['id'] = account['id']
			session['username'] = account['username']
			session['usertype'] = account['usertype']            
            
			if 	session['usertype'] == 0:
				return redirect(url_for('admin_menu',username=username),code=307)
			else:
				return redirect(url_for('profile',username=username))
			
			
		else:
            # Account doesnt exist or username/password incorrect
			msg = 'Incorrect username/password!'
    # Show the login form with message (if any)
	return render_template('login.html', msg=msg)
	

@app.route('/covidDB/profile/<username>/', methods=['GET','POST']) 	
def profile(username):
	cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
	usertype = session['usertype']
	if usertype == 1:
		qtable = 'doctors'
	elif usertype == 2:
		qtable = 'patients'
	else:
		return redirect(url_for('admin_menu'))
	cursor.execute('SELECT name,surname FROM ' + qtable + ' WHERE uid = %s',[session['id']])
	name_object = cursor.fetchone()
	session['name'] = name_object['name']
	session['surname'] = name_object['surname']
	
	if usertype == 1:
		cursor.execute('SELECT specialty FROM doctors WHERE uid = %s',[session['id']])
		spec_id = cursor.fetchone()['specialty']
		cursor.execute('SELECT specialty FROM medical_specialties WHERE id = %s',[spec_id])
		session["specialty"] = cursor.fetchone()['specialty']		
	else: 
		session["specialty"] = None


		
	return render_template('profile.html')


@app.route('/covidDB/profile/home/', methods=['GET','POST']) 	
def user_home():

	return render_template('home.html')

	
@app.route('/covidDB/insert_vitals/', methods=['GET','POST']) 
def insert_vitals():
	
	if not session["loggedin"]:
		return redirect(url_for('page_not_found'))
		
	if request.method == "GET":
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		amka = 'SELECT amka FROM patients;'
		cursor.execute(amka)
		dict_amka = cursor.fetchall()
		# find the values of a key in a list of dictionaries
		vAMKA = [a_dict['amka'] for a_dict in dict_amka]

		

	
	msg = None
	if request.method == 'POST':		
		#msg = '1 record inserted'
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		sql_doc_id = 'SELECT id FROM doctors WHERE uid = ' + str(session['id'])	
		cursor.execute(sql_doc_id)
		dict_doc_id = cursor.fetchone()
		vdoc_id = str(dict_doc_id['id'])	
		vAMKA = str(request.form['amka'])		
		vt = str(request.form['temperature'])
		vsp = str(request.form['systolic_pressure'])
		vdp = str(request.form['diastolic_pressure'])
		vrr = str(request.form['respiration_rate'])
		vhr = str(request.form['heart_rate'])
		vspo2 = str(request.form['spo2'])		
		sql = 'INSERT INTO vitals (amka,temperature,respiration_rate,systolic_pressure,diastolic_pressure,heart_rate,spo2,doc_id) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)'
		#msg = 'INSERT INTO vitals (amka,temperature,respiration_rate,systolic_pressure,diastolic_pressure,heart_rate,spo2) VALUES(' + str(vAMKA) + ',' + str(vt) + ','+ str(vrr) + ','+ str(vsp) + ',' + str(vdp) + ',' + str(vhr) + ',' + str(vspo2) +')'
		cursor.execute(sql,(vAMKA,vt,vrr,vsp,vdp,vhr,vspo2,vdoc_id,))
		mysql.connection.commit()
	return render_template('insert_vitals.html',vAMKA = vAMKA)
		

@app.route('/covidDB/insert_symptoms/', methods=['GET','POST']) 
def insert_symptoms():

	if not session["loggedin"]:
		return redirect(url_for('index.html'))
		
	msg = None
	if request.method == 'POST':		
		#msg = '1 record inserted'
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		sql_pat_id = 'SELECT id FROM patients WHERE uid = ' + str(session['id'])	
		cursor.execute(sql_pat_id)
		dict_pat_id = cursor.fetchone()
		vpat_id = str(dict_pat_id['id'])
		
		vA01 = str(request.form['Q01'])
		vA02 = str(request.form['Q02'])
		vA03 = str(request.form['Q03'])
		vA04 = str(request.form['Q04'])
		vA05 = str(request.form['Q05'])
		vA06 = str(request.form['Q06'])
		vA07 = str(request.form['Q07'])
	
		sql = 'INSERT INTO answers (A1,A2,A3,A4,A5,A6,A7,pat_id) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)'
		cursor.execute(sql,(vA01,vA02,vA03,vA04,vA05,vA06,vA07,vpat_id,))
		mysql.connection.commit()


	return render_template('insert_symptoms.html')

	
@app.route('/covidDB/doctors/search/', methods=['GET','POST']) 	
def doc_search():

	if request.method == "GET" and session["usertype"] == 1:
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		amka = 'SELECT amka FROM patients;'
		cursor.execute(amka)
		dict_amka = cursor.fetchall()
		# find the values of a key in a list of dictionaries
		vamka = [a_dict['amka'] for a_dict in dict_amka]


		return render_template('doc_search.html',vamka=vamka)	
	
	elif str(request.form['search_choice']) == "amka" :
		q = str(request.form['amka'])
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		pquery = 'SELECT * FROM patients WHERE amka = ' + q + ' ;'
		cursor.execute(pquery)
		patient = cursor.fetchall()
		
		vquery = 'SELECT * FROM vitals WHERE amka = ' + q + ' ;'
		cursor.execute(vquery)
		vitals = cursor.fetchall()		
			
		return render_template('results.html',presults=patient, vresults = vitals)
	   
	
	elif str(request.form['search_choice']) == "temperature":
		q = str(request.form['min_temp'])
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		vquery = 'SELECT amka FROM vitals WHERE temperature >= ' + q + ' ;'
		cursor.execute(vquery)
		vital_id_dict = cursor.fetchall()
		vital_id = (a_dict['amka'] for a_dict in vital_id_dict)	
		
		'''
		pquery = 'SELECT name,surname,amka,sex,bmi,smoker FROM patients WHERE amka IN (%s);'
		cursor.execute(pquery, [vital_id])
		patients = cursor.fetchall()	'''
		pquery = 'SELECT name,surname,amka,sex,bmi,smoker FROM patients WHERE amka IN {};'.format(tuple(vital_id))
		cursor.execute(pquery)
		patients = cursor.fetchall()

		#patients = vital_id_dict
		return render_template('results.html',presults=patients)
		

	elif str(request.form['search_choice']) == "respiration":
		q = str(request.form['min_rr'])
		z = str(request.form['max_spo2'])
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		vquery = 'SELECT amka FROM vitals WHERE respiration_rate >= ' + q + ' AND spo2 <= ' + z +';'
		cursor.execute(vquery)
		vital_id_dict = cursor.fetchall()
		vital_id = (a_dict['amka'] for a_dict in vital_id_dict)	

		pquery = 'SELECT name,surname,amka,sex,bmi,smoker FROM patients WHERE amka IN {};'.format(tuple(vital_id))
		cursor.execute(pquery)
		patients = cursor.fetchall()		
		
		#patients = vital_id_dict
		return render_template('results.html',presults=patients)


	elif str(request.form['search_choice']) == "sex":
		z = str(request.form['sex'])
		q = str(request.form['min_hr'])
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		vquery = 'SELECT amka FROM vitals WHERE heart_rate >= ' + q + ';'
		cursor.execute(vquery)
		vital_id_dict = cursor.fetchall()
		vital_id = (a_dict['amka'] for a_dict in vital_id_dict)	

		pquery = 'SELECT name,surname,amka,sex,bmi,smoker FROM patients WHERE amka IN {} AND sex = {} ;'.format(tuple(vital_id),z)
		cursor.execute(pquery)
		patients = cursor.fetchall()		
		
		#patients = vital_id_dict
		return render_template('results.html',presults=patients)


	elif str(request.form['search_choice']) == "age":
		z = str(request.form['age_telestis'])
		q = str(request.form['age_value'])
		g = str(request.form['min_sp'])
		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		
		if z == "0": 
			telestis = ">="
		else:
			telestis = "<="
			
		
		pquery = 'SELECT amka from patients WHERE 2022 - YEAR(date_of_birth) ' + telestis + q + ' ;'
		cursor.execute(pquery)
		patients_id_dict = cursor.fetchall()
		patients_id = (a_dict['amka'] for a_dict in patients_id_dict)	
						

		vquery = 'SELECT amka FROM vitals WHERE amka IN {}  AND systolic_pressure >= {} ;'.format(tuple(patients_id),g)
		cursor.execute(vquery)
		vital_id_dict = cursor.fetchall()
		vital_id = (a_dict['amka'] for a_dict in vital_id_dict)	

		pquery =  'SELECT name,surname,amka,sex,bmi,smoker FROM patients WHERE amka IN {} ;'.format(tuple(vital_id))
		cursor.execute(pquery)
		patients_id = cursor.fetchall()

		#patients = patients_id_dict
		return render_template('results.html',presults=patients_id)

	elif str(request.form['search_choice']) == "contact":
		q = str(request.form['spo2'])

		cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
		
	
		pquery = 'SELECT p.name, p.surname, p.contact, v.spo2 , v.examination_date FROM patients AS p INNER JOIN vitals AS v ON p.amka = v.amka WHERE v.spo2 <' + q + ';'
		cursor.execute(pquery)
		patients_id = cursor.fetchall()
						

		#patients = patients_id_dict
		return render_template('results.html',presults=patients_id)

@app.route('/covidDB/patients/search/', methods=['GET','POST']) 	
def pat_search():
	
	cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)		
	cursor.execute('SELECT amka FROM patients WHERE uid = %s',[session['id']])	
	pat_id = cursor.fetchone()['amka']

		
	vquery = 'SELECT * FROM vitals WHERE amka = ' + pat_id + ' ;'
	cursor.execute(vquery)
	vitals = cursor.fetchall()		
			
	return render_template('pat_search.html', vresults = vitals)

@app.route('/covidDB/',methods=['POST'])
def logout():
	session.clear()
	return redirect(url_for('index'))		
	

@app.route('/covidDB/page-not-found/',methods=['POST'])
def page_not_found():

	return render_template('404.html')


@app.route('/covidDB/administration/',methods=['POST'])
def admin_menu():
	return 
	
if __name__ == "__main__":
	app.run(debug=True)
	
'''
@app.route('/covidDB/menu', methods=['POST']) 	
def doc_menu():

    return render_template('doc_menu.html')    
'''    




	
