from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
persona4 = Blueprint('persona4', __name__)


#------------------------------------------------------------
# Retrieves all hourly acitivty in the system
@persona4.route('/hourlyactivity', methods=['GET'])
def get_hourly_acitivty():
    cursor = db.get_db().cursor()
   
    
    query = '''
    SELECT activity_id, CONCAT(first_name, ' ', last_name) as name, user_id, date_time, min_per_hr_online, pages_visited 
    FROM hourly_activity NATURAL JOIN user 
    '''

    cursor.execute(query)

    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Retrieves all users and their permissions in the system
@persona4.route('/user/permissions', methods=['GET'])
def get_permissions():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT user_id, first_name, last_name, user_permissions FROM user')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response



#------------------------------------------------------------
# Update the permissions for user of <userID>
@persona4.route('/<int:userID>/permissions', methods=['PUT'])
def update_permissions(userID):
        permissions = request.json.get('user_permissions') 
        
        if not permissions:
            return {'error': 'Permissions not provided'}, 400

        cursor = db.get_db().cursor()
        cursor.execute('SELECT * FROM user WHERE user_id = %s', (userID,))
        data = cursor.fetchone()
    
        if not data:
            return 'User not found, try a different id!'
    
        
        query = 'UPDATE user SET user_permissions = %s WHERE user_id = %s'
        cursor.execute(query, (permissions, userID))
        db.get_db().commit()
        return 'permissions updated'



#------------------------------------------------------------
# Retrieves all help requests in the system
@persona4.route('/helprequest', methods=['GET'])
def get_help_requests():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM help_request')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Update the status for request of <requestID> in the system 
@persona4.route('/helprequest/<int:requestID>', methods=['PUT'])
def update_status(requestID):
    cursor = db.get_db().cursor()

    data = request.json
    status = request.json.get('status')

    if not data or not status:
        return make_response(jsonify({"error": "Could not update status"}), 400)
    
    sql_query = '''
        UPDATE help_request
        SET status = %s 
        WHERE request_id = %s;
    '''

    cursor.execute(sql_query, (status, requestID))
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Status updated successfully"}), 200)



#------------------------------------------------------------
# Delete the request of <requestID> in the system 
@persona4.route('/helprequest/<int:requestID>', methods=['DELETE'])
def delete_request(requestID):
    cursor = db.get_db().cursor()

    sql_query = '''
        DELETE FROM help_request
        WHERE request_id = %s;
    '''

    cursor.execute(sql_query, (requestID))
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Request deleted successfully"}), 200)



#------------------------------------------------------------
# Retrieve all system alerts that have been posted in the system
@persona4.route('/systemalert', methods=['GET'])
def get_alerts():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * from system_alert')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Post a new system alert to the system 
@persona4.route('/systemalert/<int:adminID>', methods=['POST'])
def add_alert(adminID):
    cursor = db.get_db().cursor()
    data = request.json
    
    title = data.get('title')
    description = data.get('description')
    receivers = data.get('receivers')

    if not data or not title:
        return make_response(jsonify({"error": "Title field required"}), 400)

    sql_query = '''
        INSERT INTO system_alert (user_id, title, description, receivers)
            VALUES (%s, %s, %s, %s);
        '''

    cursor.execute(sql_query, (adminID, title, description, receivers))

    db.get_db().commit()
    return make_response(jsonify({"message": "Alert posted successfully"}), 200)


#------------------------------------------------------------
# Retrieve all users in the system
@persona4.route('/users', methods=['GET'])
def get_user():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM user')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Delete user of <userID> from the system
@persona4.route('/users/<int:userID>', methods=['DELETE'])
def delete_user(userID):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM user WHERE user_id= %s', (userID))
    db.get_db().commit()
    return make_response(jsonify({"message": "User deleted successfully"}), 200)


#------------------------------------------------------------
# Retrieve all advice in the system
@persona4.route('/advice', methods=['GET'])
def get_advice():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT advice_id as Advice_ID, CONCAT(u.first_name, " ", u.last_name) AS Peer, u.username AS Username, role AS Position, advice_text AS Advice FROM advice a JOIN user u ON a.user = u.user_id')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Retrieve advice given for role of <roleID> from the system
@persona4.route('/advice/<int:roleID>', methods=['GET'])
def get_role_advice(roleID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT advice_id as Advice_ID, CONCAT(u.first_name, " ", u.last_name) AS Peer, u.username AS Username, role AS Position, advice_text AS Advice FROM advice a JOIN user u ON a.user = u.user_id WHERE role = %s', (roleID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve advice for the role"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response



#------------------------------------------------------------
# Delete advice of <adviceID> from the system
@persona4.route('/advice/<int:adviceID>', methods=['DELETE'])
def delete_advice(adviceID):
    cursor = db.get_db().cursor()

    sql_query = '''
        DELETE FROM advice
        WHERE advice_id = %s;
    '''

    cursor.execute(sql_query, (adviceID))

    db.get_db().commit()
    return make_response(jsonify({"message": "Advice deleted successfully"}), 200)