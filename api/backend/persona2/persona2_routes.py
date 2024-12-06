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

# Get users that user is following
# user/{userID}
@persona2.route('user/<int:userID>', methods=['GET'])
def get_following(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT first_name AS "First Name", last_name AS "Last Name", username AS "Username", student_type AS "Year", activity_status AS "Activity Status", search_status AS "Search Status", urgency_status AS "Urgency Status" FROM user u JOIN friendship f ON u.user_id = f.friend_id WHERE f.user_id = %s', (userID,))
    
    theData = cursor.fetchall()

    if not theData:
        return make_response(jsonify({"error": "Unsuccessful"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

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

    # check if resource already exists. If it doesnt, create a new resource
    cursor.execute('SELECT * FROM resource WHERE title = %s AND description = %s', (data['title'], data['description']))
    resource_check = cursor.fetchall()

    if not resource_check:
        cursor.execute('INSERT INTO resource (title, description, link) VALUES (%s, %s, %s)', (data['title'], data['description'], data['link']))
        db.get_db().commit()

    # get resource_id
    cursor.execute('SELECT resource_id FROM resource WHERE title = %s AND description = %s', (data['title'], data['description']))
    resource_id = cursor.fetchall()[0]['resource_id']

    # add resource to user_resource bridge table
    cursor.execute('INSERT INTO user_resource (user_id, resource_id) VALUES (%s, %s)', (userID, resource_id))

    db.get_db().commit()
    return make_response(jsonify({"message": "Resource added successfully"}), 200)


# Add rating for userID on employerID (post)
# /users/{userID}/ratings/{employerID}
@persona2.route('/users/<int:userID>/ratings/<int:roleID>', methods=['POST'])
def add_rating(userID, roleID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    future_job_rating = data['future_job_rating']
    work_quality_rating = data['work_quality_rating']
    manager_rating = data['manager_rating']
    salary_rating = data['salary_rating']
    lifestyle_rating = data['lifestyle_rating']


    if not data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('INSERT INTO rating (user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) VALUES (%s, %s, %s, %s, %s, %s, %s)', (userID, roleID, future_job_rating, work_quality_rating, manager_rating, salary_rating, lifestyle_rating))

    db.get_db().commit()
    return make_response(jsonify({"message": "Rating added successfully"}), 200)

# Add answer to question (post)
# /questions/{questionID}/answers
@persona2.route('/answer/question/<int:questionID>', methods=['POST'])
def add_answer(questionID):
    cursor = db.get_db().cursor()
    data = request.get_json()

    user_id = data['user_id']
    answer = data['answer']

    if not data or 'answer' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('INSERT INTO answer (answer, user, question) VALUES (%s, %s, %s)', (answer, user_id, questionID))

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
    cursor.execute('INSERT INTO review (user_id, comment, role_id) VALUES (%s, %s, %s)', (userID, data['review'], data['role_id']))

    db.get_db().commit()
    return make_response(jsonify({"message": "Review added successfully"}), 200)

# Show all questions and questionID
# /questions
@persona2.route('/questions', methods=['GET'])
def get_questions():
    cursor = db.get_db().cursor()
    cursor.execute('SELECT question_id AS "Question ID", question_text AS "Question" FROM question')
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "No questions found"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

# #------------------------------------------------------------
# Get reviews by {userID}
@persona2.route('/reviews/<int:userID>', methods=['GET'])
def get_user_reviews(userID):
    cursor = db.get_db().cursor()
    cursor.execute('SELECT title AS Role, comment AS Review, review_id AS "Review ID" FROM review re JOIN role ro ON re.role_id = ro.role_id WHERE re.user_id = %s', (userID,))
    
    theData = cursor.fetchall()
    
    if not theData:
        return make_response(jsonify({"error": "Failed to retrieve reviews for the user"}), 404)
    
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    return the_response

# #------------------------------------------------------------
# Update review of review_id
@persona2.route('/review/<int:review_id>', methods=['PUT'])
def edit_user_review(review_id):
    cursor = db.get_db().cursor()
    data = request.get_json()

    if not data or 'review' not in data:
        return make_response(jsonify({"error": "Invalid input data"}), 400)
    
    cursor.execute('UPDATE review SET comment = %s WHERE review_id = %s', (data['review'], review_id))
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Review updated successfully"}), 200)

# #------------------------------------------------------------
# Delete review of review_id
@persona2.route('/review/<int:review_id>', methods=['DELETE'])
def delete_user_review(review_id):
    cursor = db.get_db().cursor()
    
    cursor.execute('DELETE FROM review WHERE review_id = %s', (review_id,))
    
    if cursor.rowcount == 0:
        return make_response(jsonify({"error": "No matching review found to delete"}), 404)
    
    db.get_db().commit()
    return make_response(jsonify({"message": "Review deleted successfully"}), 200)