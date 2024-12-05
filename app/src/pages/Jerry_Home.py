import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}!")
st.write('')
st.write('')
st.write('### How can we help you on your co-op search?')

if st.button('View Roles', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Job_list.py')

if st.button('See Advice', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Get_Advice.py')

if st.button('Find Resources', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/Find_Resources.py')

if st.button('View Friends', 
          type='primary',
          use_container_width=True):
  st.switch_page('pages/View_Friends.py')

if st.button('Add Friends', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/Add_Friend.py')

if st.button('Remove Friends', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/Remove_Friend.py')

if st.button('Employer Ratings', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/See_Ratings.py')

if st.button('Employer Reviews', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/See_Reviews.py')

if st.button('Profile Settings', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/Profile_Settings.py')