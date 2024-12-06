import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Add Review")

'''
Use this page to add a review about your co-op experience.
'''

user_id = st.session_state['user_id']
role_id = st.text_input("Role ID:")
review = st.text_area("Review:")

def add_review(user_id, role_id):
    if not role_id or not role_id.isdigit():
        st.error("Invalid Employer ID. Please enter a numeric value.")
        return

    try:
        response = requests.post(
            f'http://api:4000/p/reviews/{user_id}',
            json={"review": review, "role_id": role_id},  # Send required data as JSON
        )
        if response.status_code == 200:
            st.success("Review added successfully!")
        else:
            try:
                error_message = response.json().get("error", response.text)
            except ValueError:
                error_message = response.text or "Unknown error occurred"
            st.error(f"Failed to add review: {error_message}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the add_review function
if st.button("Add"):
    add_review(user_id, role_id)

