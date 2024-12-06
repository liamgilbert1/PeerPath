import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Find Resources")

"""
See any peers who have had the same role as you? Use this page to find resources that they have found useful. Type the username of the peer you are interested in, then click the 'See Resources' button.
"""

username = st.text_input("Peer Username:")

def get_resources(username):
    data = {}
    try:
        data = requests.get(
        f'http://api:4000/c/resources/{username}',
        ).json()
        st.dataframe(data)
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the get advice function
if st.button("See Resources"):
    get_resources(username)