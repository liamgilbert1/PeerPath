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
st.write('### How can we help you on your co-op search?')

if st.button('View Roles', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Job_list.py')

if st.button('See Advice', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Get_Advice.py')