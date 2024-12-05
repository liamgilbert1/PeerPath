import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# View Friends")

"""
Use this page to see your friends and what they are up to!
"""

user_id = st.session_state["user_id"]


data = {}
try:
    data = requests.get(
    f'http://api:4000/p/user/{user_id}',
    ).json()
    st.dataframe(data)
except Exception as e:
    st.error(f"An error occurred: {e}")