########################################################
# Sample customers blueprint of endpoints
# Remove this file if you are not using it in your project
########################################################
from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
persona1 = Blueprint('persona1', __name__)

# Get specific user from the system
@persona1.route('/user/<int:userID>', methods=['GET'])
def get_user(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM user WHERE user_id = %s', (userID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Retrieves all of the advice given for {roleID}
@persona1.route('/advice/<int:roleID>', methods=['GET'])
def get_role_advice(roleID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT u.username AS Username, role AS Position, advice_text AS Advice FROM advice a JOIN user u ON a.user = u.user_id WHERE role = %s', (roleID,))
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve advice for the role"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Retrieves all of the roles and their id's
@persona1.route('/roles', methods=['GET'])
def get_roles():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT title AS Position, e.name AS Employer, role_id AS "Role ID", e.employer_id AS "Employer ID" FROM role r JOIN employer e ON r.employer = e.employer_id ORDER BY role_id')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve roles"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

# #------------------------------------------------------------
# # Retrieves list of resources recommended by {userID}
@persona1.route('/resources/<string:username>', methods=['GET'])
def get_user_resources(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT r.title AS Resource, r.link AS Link, r.description AS Description FROM user_resource ur JOIN resource r ON ur.resource_id = r.resource_id JOIN user u ON u.user_id = ur.user_id WHERE u.username = %s', (username,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve resources for the user"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

# #------------------------------------------------------------
# # Retrieves list of ratings made for {employerID}
@persona1.route('/ratings/<int:employerID>', methods=['GET'])
def get_employer_ratings(employerID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT ro.title AS Position, future_job_score AS "Future Job Score", lifestyle_score AS "Lifestyle Score", manager_score AS "Manager Score", salary_score AS "Salary Score", work_quality_score AS "Work Quality Score" FROM rating ra JOIN role ro ON ra.role_id = ro.role_id WHERE ro.employer = %s', (employerID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve ratings for the employer"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

# #------------------------------------------------------------
# Retrieves list of reviews made for {employerID}
@persona1.route('/reviews/<int:employerID>', methods=['GET'])
def get_employer_reviews(employerID):
    cursor = db.get_db().cursor()
    cursor.execute(
        'SELECT title AS Role, comment AS Review FROM review re JOIN role ro ON re.role_id = ro.role_id WHERE ro.employer = %s', 
        (employerID,)
    )
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve reviews for the employer"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

# #------------------------------------------------------------
# Update mutable attributes of user with {userID}
@persona1.route('/user/<int:userID>', methods=['PUT'])
def update_user(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM user WHERE user_id = %s', (userID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "User not found"}), 404)
    
    user_info = request.json
    username = user_info['username']
    email = user_info['email']
    activity_status = user_info['activity_status']
    urgency_status = user_info['urgency_status']
    search_status = user_info['search_status']
    
    query = 'UPDATE user SET username = %s, email = %s, activity_status = %s, urgency_status = %s, search_status = %s WHERE user_id = %s'
    data = (username, email, activity_status, urgency_status, search_status, userID)
    cursor.execute(query, data)
    db.get_db().commit()
    return 'user updated!'

# #------------------------------------------------------------
# Add a new friend of {friend_username} for {userID}
@persona1.route('/user/<int:userID>/friends/<string:friend_username>', methods=['POST'])
def add_friend(userID, friend_username):

    cursor = db.get_db().cursor()
    cursor.execute('SELECT user_id FROM user WHERE username = %s', (friend_username,))
    friend_data = cursor.fetchall()

    if not friend_data:
        return make_response(jsonify({"error": "Friend username does not exist"}), 404)

    friendID = friend_data[0]['user_id'] if friend_data else None

    if friendID is None:
        return 'User not found, try a different username!'

    cursor.execute('SELECT * FROM friendship WHERE user_id = %s AND friend_id = %s', (userID, friendID))
    
    theData = cursor.fetchall()
    
    if theData:
        return make_response(jsonify({"error": "Friend already exists"}), 404)
    
    query = 'INSERT INTO friendship (user_id, friend_id) VALUES (%s, %s)'
    data = (userID, friendID)
    cursor.execute(query, data)
    db.get_db().commit()
    return 'friend added!'

# #------------------------------------------------------------
# Remove friend of {friendID} for {userID}
@persona1.route('/user/<int:userID>/friends/<string:friend_username>', methods=['DELETE'])
def remove_friend(userID, friend_username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT user_id FROM user WHERE username = %s', (friend_username,))
    friend_data = cursor.fetchall()

    if not friend_data:
        return 'User not found, try a different username!'
    
    friendID = friend_data[0]['user_id']

    cursor.execute('SELECT * FROM friendship WHERE user_id = %s AND friend_id = %s', (userID, friendID))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Friend does not exist"}), 404)
    
    query = 'DELETE FROM friendship WHERE user_id = %s AND friend_id = %s'
    data = (userID, friendID)
    cursor.execute(query, data)
    db.get_db().commit()
    return 'friend removed!'

# #------------------------------------------------------------
# Retrieves all questions and shows the question and answer
@persona1.route('/questions', methods=['GET'])
def get_questions():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT question_text AS Question, answer AS Answer FROM answer a JOIN question q ON a.question = q.question_id')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve questions"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

