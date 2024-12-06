import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Add Rating")

'''
Use this page to add ratings on specific components of your co-op experience. Each rating is on a scale of 1-10.
'''

user_id = st.session_state['user_id']
role_id = st.text_input("Role ID:")
future_job_rating = st.text_input("Future Job Score:")
work_quality_rating = st.text_input("Work Quality Score:")
manager_rating = st.text_input("Manager Score:")
salary_rating = st.text_input("Salary Score:")
lifestyle_rating = st.text_input("Lifestyle Score:")

def add_rating(user_id, role_id):
    if not role_id or not role_id.isdigit():
        st.error("Invalid Employer ID. Please enter a numeric value.")
        return
    if not future_job_rating.isdigit() or int(future_job_rating) not in range(1, 11):
        st.error("Future Job Score must be a numeric value from 1-10.")
        return
    if not work_quality_rating.isdigit() or int(work_quality_rating) not in range(1, 11):
        st.error("Work Quality Score must be a numeric value from 1-10.")
        return
    if not manager_rating.isdigit() or int(manager_rating) not in range(1, 11):
        st.error("Manager Score must be a numeric value from 1-10.")
        return
    if not salary_rating.isdigit() or int(salary_rating) not in range(1, 11):
        st.error("Salary Score must be a numeric value from 1-10.")
        return
    if not lifestyle_rating.isdigit() or int(lifestyle_rating) not in range(1, 11):
        st.error("Lifestyle Score must be a numeric value from 1-10.")
        return

    try:
        response = requests.post(
            f'http://api:4000/p/users/{user_id}/ratings/{role_id}',
            json={"future_job_rating": future_job_rating, "work_quality_rating": work_quality_rating, "manager_rating": manager_rating, "salary_rating": salary_rating, "lifestyle_rating": lifestyle_rating},  # Send required data as JSON
        )
        if response.status_code == 200:
            st.success("Rating added successfully!")
        else:
            try:
                error_message = response.json().get("error", response.text)
            except ValueError:
                error_message = response.text or "Unknown error occurred"
            st.error(f"Failed to add rating: {error_message}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the add_rating function
if st.button("Add"):
    add_rating(user_id, role_id)