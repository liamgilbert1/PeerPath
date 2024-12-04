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

current_username = [item.get("username", "") for item in data][0]
current_email = [item.get("email", "") for item in data][0]
current_activity_status = [item.get("activity_status", "") for item in data][0]
current_urgency_status = [item.get("urgency_status", "") for item in data][0]
current_search_status = [item.get("search_status", "") for item in data][0]
