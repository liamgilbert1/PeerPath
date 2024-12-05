import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Job Ids")

"""
Use this page to view job ids which you can then use to query advice from your peers!
"""
data = {} 
try:
  user_id = 2
  data = requests.get(f'http://api:4000/c/roles').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)