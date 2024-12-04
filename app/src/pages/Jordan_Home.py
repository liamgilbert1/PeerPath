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

if st.button('Predict Value Based on Regression Model', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/11_Prediction.py')

if st.button('View the Simple API Demo', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/12_API_Test.py')

if st.button("View Classification Demo",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/13_Classification.py')

if st.button("Profile Settings",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Profile_Settings.py')

if st.button("Add Friends",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Add_Friend.py')

if st.button("Remove Friends",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Remove_Friend.py')