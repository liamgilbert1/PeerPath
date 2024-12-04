import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Remove Friends")

"""
Use this page to remove friends. Make type in the username of the friend you want to remove, then click the 'Remove' button to unfollow them.
"""

user_id = st.session_state['user_id']

friend_username = st.text_input("Friend's Username:")

def remove_friend(user_id, friend_username):
    try:
        response = requests.delete(
        f'http://api:4000/c/user/{user_id}/friends/{friend_username}',
        )
        if response.status_code == 200:
            st.success("Friend removed successfully!")
        else:
            st.error(f"Failed to remove friend: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the add friend function
if st.button("Remove"):
    remove_friend(user_id, friend_username)
