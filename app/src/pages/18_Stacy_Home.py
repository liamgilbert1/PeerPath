import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### What would you like to do?')

st.write('')
st.write('')

st.write('##### Click here to view all users and find a user based on their username.')
if st.button("Find and View Users",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/19_Users.py')

st.write('')
st.write('')

st.write('##### Click here to view all ratings and find ratings for specific coordinators.')
if st.button("Retrieve Ratings",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/20_Ratings.py')

st.write('')
st.write('')

st.write('##### Click here to view, create, update, and delete notes.')
if st.button("Manage Notes",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/21_Notes.py')