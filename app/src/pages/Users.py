import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Find Users")

"""
Use this page to find and view all users on PeerPath.
"""

st.write('')
st.write('')

st.write("### Find User by Username")

username = st.text_input("Username:")

def find_user(username):
    try:
        response = requests.get(
        f'http://api:4000/3/users/{username}',
        )
        if response.status_code == 200:
            st.success("User found successfully!")
            return response.json()
        else:
            st.error(f"Failed to find user: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Find"):
    data = find_user(username)
    st.dataframe(data)

st.write('')
st.write('')

st.write("### All Users")

data = {}
try:
  data = requests.get('http://api:4000/3/users').json()
except:
    st.write("**Important**: Could not connect to sample api, so using dummy data.")
    data30 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data)

