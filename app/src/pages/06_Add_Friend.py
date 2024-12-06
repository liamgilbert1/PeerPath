import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Add Friends")

"""
Use this page to add friends. Make type in the username of the friend you want to add, then click the 'Add' button to start following them.
"""

user_id = st.session_state['user_id']

friend_username = st.text_input("Friend's Username:")

def add_friend(user_id, friend_username):
    try:
        response = requests.post(
        f'http://api:4000/c/user/{user_id}/friends/{friend_username}',
        )
        if response.status_code == 200:
            st.success("Friend added successfully!")
        else:
            st.error(f"Failed to add friend: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the add friend function
if st.button("Add"):
    add_friend(user_id, friend_username)
