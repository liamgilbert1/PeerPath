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

'''
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
'''

'''
Routes to make:
- Add advice for roleID
- Add resource for userID
- Add rating for userID on employerID
- Edit rating
- Delete rating on employerID
- Joe did: add friend
- Joe did: delete friend
- Add answer to question
- Add new review
'''

# Add advice for roleID (post)
# /advice/{roleID}
@persona2.route('/advice/<int:roleID>', methods=['POST'])
def add_advice(roleID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'advice' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    

    # Check if the user has the specified role
    cursor.execute(
        'SELECT COUNT(*) FROM user_role WHERE user_id = %s AND role_id = %s',
        (data['user_id'], roleID)
    )
    role_check = cursor.fetchall()

    # If no role exists for the user, reject the request
    if role_check[0] == 0:
        return make_response(jsonify({"error": "User does not have the specified role"}), 403)
    
    cursor.execute('INSERT INTO advice (role, advice_text, user) VALUES (%s, %s, %s)', (roleID, data['advice'], data['user_id']))

    db.get_db().commit()
    return make_response(jsonify({"message": "Advice added successfully"}), 200)

# Add resource for userID (post)
# /resources/{userID}
@persona2.route('/resources/<int:userID>', methods=['POST'])
def add_resource(userID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'resource_name' not in data or 'resource_details' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('INSERT INTO user_resource (user_id, title, description) VALUES (%s, %s, %s)', (userID, data['resource_name'], data['resource_details']))

    db.get_db().commit()
    return make_response(jsonify({"message": "Resource added successfully"}), 200)


# Add rating for userID on employerID (post)
# /users/{userID}/ratings/{employerID}
@persona2.route('/users/<int:userID>/ratings/<int:employerID>', methods=['POST'])
def add_rating(userID, employerID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'rating' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('INSERT INTO rating (user_id, employer_id, rating) VALUES (%s, %s, %s)', (userID, employerID, data['rating']))

    db.get_db().commit()
    return make_response(jsonify({"message": "Rating added successfully"}), 200)

# Edit existing rating (put)
# /users/{userID}/ratings/{employerID}
@persona2.route('/users/<int:userID>/ratings/<int:employerID>', methods=['PUT'])
def edit_rating(userID, employerID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'rating' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('UPDATE rating SET rating = %s WHERE user_id = %s AND employer_id = %s', (data['rating'], userID, employerID))
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Rating updated successfully"}), 200)


# Delete rating on employerID (delete)
# /users/{userID}/ratings/{employerID}
@persona2.route('/users/<int:userID>/ratings/<int:employerID>', methods=['DELETE'])
def delete_rating(userID, employerID):
    cursor = db.get_db().cursor()
    
    cursor.execute('DELETE FROM rating WHERE user_id = %s AND employer_id = %s', (userID, employerID))
    
    if cursor.rowcount == 0:
        return make_response(jsonify({"error": "No matching rating found to delete"}), 404)
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Rating deleted successfully"}), 200)

# Add answer to question (post)
# /questions/{questionID}/answers
@persona2.route('/questions/<int:questionID>/answers', methods=['POST'])
def add_answer(questionID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'answer' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('INSERT INTO answer (question_id, answer) VALUES (%s, %s)', (questionID, data['answer']))

    db.get_db().commit()
    return make_response(jsonify({"message": "Answer added successfully"}), 200)

# Add new review for userID (post)
# /reviews/{userID}
@persona2.route('/reviews/<int:userID>', methods=['POST'])
def add_review(userID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'review' not in data:

        return make_response(jsonify({"error": "Invalid input data"}), 400)
    cursor.execute('INSERT INTO review (user_id, review) VALUES (%s, %s)', (userID, data['review']))

    db.get_db().commit()
    return make_response(jsonify({"message": "Review added successfully"}), 200)