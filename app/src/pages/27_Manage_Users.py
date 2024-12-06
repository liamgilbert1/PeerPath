import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Manage Users")

"""
Use this to view and manage all users.
"""

st.write('')
st.write('')
st.write('### All Users')
data = {} 
try:
  admin_id = 1
  data = requests.get(f'http://api:4000/4/users').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

st.write('')
st.write('')
st.write("### Delete User")

delete_user_id = st.text_input("User ID of the user you wish to delete:")


def delete_user(user_id):
    try:
        response = requests.delete(
            f'http://api:4000/4/users/{user_id}',
        )
        if response.status_code == 200:
            st.success("User deleted successfully!")
        else:
            st.error(f"Failed to delete user: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Delete User"):
    delete_user(delete_user_id)
 

