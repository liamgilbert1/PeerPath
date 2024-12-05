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

if st.button("Find and View Users",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Users.py')

if st.button("Retrieve Ratings",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Ratings.py')

if st.button("Manage Notes",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Notes.py')