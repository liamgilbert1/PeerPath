import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Give Advice")

'''
Use this page to write advice for underclassmen.
'''

role_id = st.text_input("Role Id:")
advice = st.text_input("Advice:")
user_id = st.session_state['user_id']

def add_advice(role_id, advice, user_id):
    if not role_id or not role_id.isdigit():
        st.error("Invalid Role ID. Please enter a numeric value.")
        return
    if not advice:
        st.error("Advice cannot be empty.")
        return

    try:
        response = requests.post(
            f'http://api:4000/c/advice/{role_id}',
            json={"advice": advice, "user_id": user_id},  # Send required data as JSON
        )
        if response.status_code == 200:
            st.success("Advice added successfully!")
        else:
            try:
                error_message = response.json().get("error", response.text)
            except ValueError:
                error_message = response.text or "Unknown error occurred"
            st.error(f"Failed to add advice: {error_message}")
            # st.error(f"Failed to add advice: {response.json().get('error', response.text)}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the add_advice function
if st.button("Add"):
    add_advice(role_id, advice, user_id)

'''
def add_advice(role_id):
    try:
        response = requests.post(
        f'http://api:4000/c/role/{role_id}/advice',
        )
        if response.status_code == 200:
            st.success("Advice added successfully!")
        else:
            st.error(f"Failed to add advice: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# button to trigger the add advice function
if st.button("Add"):
    add_advice(role_id)
'''