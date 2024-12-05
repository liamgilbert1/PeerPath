import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Questions and Answers")

"""
Use this page to find all questions and answers on PeerPath.
"""

data = {}
try:
  data = requests.get(f'http://api:4000/c/questions').json()
except:
    st.write("**Important**: Could not connect to sample api, so using dummy data.")
    data = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data)

