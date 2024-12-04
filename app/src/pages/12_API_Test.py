import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Accessing a REST API from Within Streamlit")

"""
Simply retrieving data from a REST api running in a separate Docker Container.

If the container isn't running, this will be very unhappy.  But the Streamlit app 
should not totally die. 
"""
data = {} 
try:
  user_id = 3
  data = requests.get(f'http://api:4000/c/user/{user_id}').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

data3 = {}
try:
  data3 = requests.get('http://api:4000/3/ratings').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data3 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data3)

data33 = {}
try:
  data33 = requests.get('http://api:4000/3/notes/2').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data33 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data33)

data35 = {}
try:
  data35 = requests.get('http://api:4000/3/ratings/1').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data35 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data35)





