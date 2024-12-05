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
persona2 = Blueprint('persona2', __name__)


# #------------------------------------------------------------
# # Get specific user from the system
# @persona2.route('/user/<int:userID>', methods=['GET'])
# def get_user(userID):
#     cursor = db.get_db().cursor()
#     cursor.execute('SELECT * FROM user WHERE user_id = %s', (userID,))
    
#     theData = cursor.fetchall()
    
#     if not theData:
#         return make_response(jsonify({"error": "RIP"}), 404)
    
#     the_response = make_response(jsonify(theData))
#     the_response.status_code = 200
#     return the_response

@persona2.route('user/<int:userID>', methods=['GET'])
def get_following(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT first_name AS "First Name", last_name AS "Last Name", username AS "Username", student_type AS "Year", activity_status AS "Activity Status", search_status AS "Search Status" FROM user u JOIN friendship f ON u.user_id = f.friend_id WHERE f.user_id = %s', (userID,))
    
    theData = cursor.fetchall()

    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

