import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Manage Reviews")

"""
Use this to view and manage reviews you have made.
"""

user_id = st.session_state["user_id"]

st.write('')
st.write('')
st.write('### All Your Reviews')
data = {} 
try:
  admin_id = 1
  data = requests.get(f'http://api:4000/p/reviews/{user_id}').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

review_id = st.text_input("Review ID of the review you wish to edit or delete:")

st.write('')
st.write('')
st.write("### Edit Review")

review = st.text_area("New Review:")

def edit_review(review_id):
    try:
        response = requests.put(
        f'http://api:4000/p/review/{review_id}',
        json={"review": review},  # Send required data as JSON
        )
        if response.status_code == 200:
            st.success("Review Updated Successfully!")
            return response.json()
        else:
            st.error("No advice found.")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Save Edit"):
    edit_review(review_id)


st.write('')
st.write('')
st.write("### Delete Review")

def delete_review(review_id):
    try:
        response = requests.delete(
            f'http://api:4000/p/review/{review_id}',
        )
        if response.status_code == 200:
            st.success("Review deleted successfully!")
        else:
            st.error(f"Failed to delete review: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Delete Review"):
    delete_review(review_id)
 
 

