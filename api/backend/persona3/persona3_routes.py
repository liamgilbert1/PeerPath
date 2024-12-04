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

@persona3.route('/notes/<int:decisionmakerID>', methods=['GET'])
def get_notes(decisionmakerID):
    cursor = db.get_db().cursor()
    sql_query = '''
        SELECT *
        FROM notes
        WHERE (coordinator_id = %s OR %s IS NULL)
        AND (employer_id = %s OR %s IS NULL);
    '''
    cursor.execute(sql_query, (decisionmakerID, decisionmakerID, None, None))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response



@persona3.route('/notes/<int:decisionmakerID>', methods=['POST'])
def add_notes(decisionmakerID):
    cursor = db.get_db().cursor()

    # Extract the note details from the request body
    note_text = request.json.get('note')
    employer_id = request.json.get('employer_id', None)

    # Check if the coordinator_id (decisionmakerID) exists in the coordinator table
    cursor.execute('SELECT coordinator_id FROM coordinator WHERE coordinator_id = %s', (decisionmakerID,))
    coordinator_data = cursor.fetchall()

    if not coordinator_data:
        return make_response(jsonify({"error": "Coordinator does not exist"}), 404)

    # If employer_id is provided, check if it exists in the employer table
    if employer_id:
        cursor.execute('SELECT employer_id FROM employer WHERE employer_id = %s', (employer_id,))
        employer_data = cursor.fetchall()

        if not employer_data:
            return make_response(jsonify({"error": "Employer does not exist"}), 404)

    # Insert the note into the notes table
    query = '''
        INSERT INTO notes (user_id, employer_id, coordinator_id, text)
        VALUES (%s, %s, %s, %s)
    '''
    data = (decisionmakerID, employer_id, decisionmakerID, note_text)
    cursor.execute(query, data)

    # Commit the transaction
    db.get_db().commit()

    return make_response(jsonify({"message": "Note added"}), 200)


@persona3.route('/ratings/<int:coordinatorID>', methods=['GET'])
def get_ratings_by_coordinator(coordinatorID):
    cursor = db.get_db().cursor()
    sql_query = '''
        SELECT * 
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

