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
    cursor.execute('SELECT * FROM notes WHERE decisionmaker_id = %s', (decisionmakerID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

@persona3.route('/ratings/<int:coordinatorID>', methods=['GET'])
def get_ratings_by_coordinator(coordinatorID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT * FROM rating JOIN user ON rating.user_id = user.user_id WHERE user.coordinator = %s', (coordinatorID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "RIP"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

