from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
persona3 = Blueprint('persona3', __name__)


#------------------------------------------------------------
# Retrieves all of the users in the system
@persona3.route('/users', methods=['GET'])
def get_users():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM user')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Retrieves a specific user from the system by username
@persona3.route('/users/<string:username>', methods=['GET'])
def get_user(username):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM user WHERE username = %s', (username,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response


#------------------------------------------------------------
# Retrieves all of the ratings in the system
@persona3.route('/ratings', methods=['GET'])
def get_ratings():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM rating')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Retrieves all of the advice given based on the role
@persona3.route('/notes/<int:decisionmakerID>', methods=['GET'])
def get_notes(decisionmakerID):
    cursor = db.get_db().cursor()
    data = request.json

    filter_type = data.get('filter_type')

    if not data or not filter_type:
        return make_response(jsonify({"error": "Filter type is required"}), 400)

    if filter_type == "coordinator":
        sql_query = '''
            SELECT *
            FROM notes
            WHERE coordinator_id = %s;
        '''
        cursor.execute(sql_query, (decisionmakerID,))
    elif filter_type == "employer":
        sql_query = '''
            SELECT *
            FROM notes
            WHERE employer_id = %s;
        '''
        cursor.execute(sql_query, (decisionmakerID,))
    else:
        return make_response(jsonify({"error": "Invalid filter type"}), 400)
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "No notes found"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

#------------------------------------------------------------
# Add a new note for a coordinator or employer
@persona3.route('/notes/<int:decisionmakerID>', methods=['POST'])
def add_notes(decisionmakerID):
    cursor = db.get_db().cursor()
    data = request.json
    
    filter_type = data.get('filter_type')
    note_text = data.get('note_text')
    user_id = data.get('user_id')

    if not data or not filter_type or not note_text or not user_id:
        return make_response(jsonify({"error": "All fields are required"}), 400)

    if filter_type == "coordinator":
        sql_query = '''
            INSERT INTO notes (coordinator_id, note_text, user_id)
            VALUES (%s, %s, %s);
        '''
        cursor.execute(sql_query, (decisionmakerID, note_text, user_id))
    elif filter_type == "employer":
        sql_query = '''
            INSERT INTO notes (employer_id, note_text, user_id)
            VALUES (%s, %s, %s);
        '''
        cursor.execute(sql_query, (decisionmakerID, note_text, user_id))
    else:
        return make_response(jsonify({"error": "Invalid filter type"}), 400)
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Note added successfully"}), 200)

#------------------------------------------------------------
# Update a note for a coordinator or employer
@persona3.route('/notes/<int:decisionmakerID>/<int:noteID>', methods=['PUT'])
def update_notes(decisionmakerID, noteID):
    cursor = db.get_db().cursor()

    data = request.json
    filter_type = request.json.get('filter_type')
    note_text = request.json.get('note_text')
    user_id = request.json.get('user_id')

    if not data or not filter_type or not note_text or not user_id:
        return make_response(jsonify({"error": "All fields are required"}), 400)
    
    if filter_type == "coordinator":
        sql_query = '''
            UPDATE notes
            SET note_text = %s, user_id = %s
            WHERE coordinator_id = %s AND note_id = %s;
        '''
    elif filter_type == "employer":
        sql_query = '''
            UPDATE notes
            SET note_text = %s, user_id = %s
            WHERE employer_id = %s AND note_id = %s;
        '''
    else:
        return make_response(jsonify({"error": "Invalid filter type"}), 400)

    cursor.execute(sql_query, (note_text, user_id, decisionmakerID, noteID))
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Note updated successfully"}), 200)

#------------------------------------------------------------
# Delete a note for a coordinator or employer
@persona3.route('/notes/<int:decisionmakerID>/<int:noteID>', methods=['DELETE'])
def delete_notes(decisionmakerID, noteID):
    cursor = db.get_db().cursor()

    data = request.json
    filter_type = request.json.get('filter_type')

    if not data or not filter_type:
        return make_response(jsonify({"error": "Filter type is required"}), 400)
    
    if filter_type == "coordinator":
        sql_query = '''
            DELETE FROM notes
            WHERE coordinator_id = %s AND note_id = %s;
        '''
    elif filter_type == "employer":
        sql_query = '''
            DELETE FROM notes
            WHERE employer_id = %s AND note_id = %s;
        '''
    else:
        return make_response(jsonify({"error": "Invalid filter type"}), 400)
    
    cursor.execute(sql_query, (decisionmakerID, noteID))

    db.get_db().commit()
    return make_response(jsonify({"message": "Note deleted successfully"}), 200)

#------------------------------------------------------------
# Retrieves all of the ratings in the system by coordinator
@persona3.route('/ratings/<int:coordinatorID>', methods=['GET'])
def get_ratings_by_coordinator(coordinatorID):
    cursor = db.get_db().cursor()
    sql_query = '''
        SELECT future_job_score, lifestyle_score, manager_score, rating_id, role_id, salary_score, user.user_id, work_quality_score
        FROM rating 
        JOIN user ON rating.user_id = user.user_id 
        WHERE user.coordinator = %s;'''
    
    cursor.execute(sql_query, (coordinatorID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

