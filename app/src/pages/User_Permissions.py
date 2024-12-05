import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Manage Permissions")

"""
Use this manage the permissions of users.
"""

st.write('')
st.write('')
st.write('### All User Permissions')
data = {} 
try:
  admin_id = 1
  data = requests.get(f'http://api:4000/4/user/permissions').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

st.write('')
st.write('')
st.write('### Update Permissions')


update_user_id = st.text_input("User ID you want to update permissions for:")
update_choice = st.selectbox("Set status to:", ["Classic", "Reduced", "Advanced"])


def update_permissions(user_id, choice):
    try:
        response = requests.put(
            f'http://api:4000/4/{user_id}/permissions',
            json={"user_permissions": choice.lower()}
        )
        if response.status_code == 200:
            st.success("Permissions updated successfully!")
        else:
            st.error(f"Failed to update permissions: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Update Permissions"):
    update_permissions(update_user_id, update_choice)
  
