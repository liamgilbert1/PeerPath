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


#------------------------------------------------------------
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
def todo():
    return

#------------------------------------------------------------
# Retrieves list of resources recommended by {userID}
@persona1.route('/resources/<int:userID>', methods=['GET'])
def todo():
    return

#------------------------------------------------------------
# Retrieves list of ratings made for {employerID}
@persona1.route('/ratings/<int:employerID>', methods=['GET'])
def todo():
    return

#------------------------------------------------------------
#Retrieves list of reviews made for {employerID}
@persona1.route('/reviews/<int:employerID>', methods=['GET'])
def todo():
    return

#------------------------------------------------------------
# Update mutable attributes of user with {userID}
@persona1.route('/user/<int:userID>', methods=['PUT'])
def todo():
    return

#------------------------------------------------------------
# Retrieve all friends of {userID}
@persona1.route('/friends/<int:userID>', methods=['GET'])
def todo():
    return

#------------------------------------------------------------
# Add a new friend of {friendID} for {userID}
@persona1.route('/user/<int:userID>/friends/<int:friendID>', methods=['POST'])
def todo():
    return

#------------------------------------------------------------
# Remove friend of {friendID} for {userID}
@persona1.route('/user/<int:userID>/friends/<int:friendID>', methods=['DELETE'])
def todo():
    return

