import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Hourly Activity")

"""
Monitor Incoming Acitivty from Users
"""
data = {} 
try:
  admin_id = 1
  data = requests.get(f'http://api:4000/4/hourlyactivity').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)