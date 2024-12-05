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

role_id = st.session_state['role_id']

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