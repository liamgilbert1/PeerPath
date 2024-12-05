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

resource_name = st.text_input("Resource Name:")
resource_details = st.text_area("Resource Details:")
user_id = st.session_state['user_id']
link = st.text_input("Link (Optional):", "")

def add_resource(user_id):
    try:
        response = requests.post(
            f'http://api:4000/p/resources/{user_id}',
            json={"title": resource_name, "description": resource_details, "link": link},  # Send required data as JSON
        )
        if response.status_code == 200:
            st.success("Resource added successfully!")
        else:
            try:
                error_message = response.json().get("error", response.text)
            except ValueError:
                error_message = response.text or "Unknown error occurred"
            st.error(f"Failed to add resource: {error_message}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the add_resource function
if st.button("Add"):
    add_resource(user_id)