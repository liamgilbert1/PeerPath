import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Role Advice")

"""
Use this page to get job advice given for specific roles you are interested in! Type the id of the role you are interested in, then click the 'Get Advice' button to get advice.
"""

role_id = st.text_input("Role Id:")

def get_advice(role_id):
    data = {}
    try:
        data = requests.get(
        f'http://api:4000/c/advice/{role_id}',
        ).json()
        st.dataframe(data)
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the get advice function
if st.button("Get Advice"):
    get_advice(role_id)