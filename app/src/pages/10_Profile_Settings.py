import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Profile Settings")

"""
Use this page to update your profile settings. Make your changes, then click the 'Save' button to update your profile.
"""

user_id = st.session_state['user_id']

data = {} 
try:
  data = requests.get(f'http://api:4000/c/user/{user_id}').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

current_username = [item.get("username", "") for item in data][0]
current_email = [item.get("email", "") for item in data][0]
current_activity_status = [item.get("activity_status", "") for item in data][0]
current_urgency_status = [item.get("urgency_status", "") for item in data][0]
current_search_status = [item.get("search_status", "") for item in data][0]

activity_status_options = ["offline", "online"]
urgency_status_options = ["not urgent", "semi-urgent", "urgent"]
search_status_options = ["applying", "job found", "future applicant", "next cycle applicant", "on-coop"]

# Add a text input field for the user to input their first name
username = st.text_input("Username:", value=current_username)
email = st.text_input("Email:", value=current_email)
activity_status = st.selectbox("Activity Status:", activity_status_options, activity_status_options.index(current_activity_status) if current_activity_status in activity_status_options else 0)
urgency_status = st.selectbox("Urgency Status:", urgency_status_options, urgency_status_options.index(current_urgency_status) if current_urgency_status in urgency_status_options else 0)
search_status = st.selectbox("Search Status:", search_status_options, search_status_options.index(current_search_status) if current_search_status in search_status_options else 0)

def update_profile(username, email, activity_status, urgency_status, search_status):
  try:
    response = requests.put(
      f'http://api:4000/c/user/{user_id}',
      json={"username": username, "email": email, "activity_status": activity_status, "urgency_status": urgency_status, "search_status": search_status}
    )
    if response.status_code == 200:
      st.success("Profile updated successfully!")
    else:
      st.error("Failed to update profile.")
  except Exception as e:
    st.error(f"An error occurred: {e}")

# Button to trigger the update function
if st.button("Save"):
  update_profile(username, email, activity_status, urgency_status, search_status)
