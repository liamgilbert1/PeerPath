import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Add Resource")

'''
Use this page to add a resource to the system.
'''

user_id = st.session_state['user_id']

def add_resource(user_id):
    try:
        response = requests.post(
        f'http://api:4000/c/user/{user_id}/resources',
        )
        if response.status_code == 200:
            st.success("Resource added successfully!")
        else:
            st.error(f"Failed to add resource: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Add"):
    add_resource(user_id)