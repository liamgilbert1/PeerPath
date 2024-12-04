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

data = {} 
try:
  data = requests.get(f'http://api:4000/c/user/{user_id}').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}