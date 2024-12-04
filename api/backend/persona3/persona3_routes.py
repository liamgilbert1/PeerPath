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

