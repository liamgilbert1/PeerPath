import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### What would you like to do?')

if st.button('View Hourly Activity', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/View_Activity.py')

if st.button('Manage User Permissions', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/User_Permissions.py')

if st.button("Manage Requests",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Help_Requests.py')

if st.button("View All System Alerts",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/System_alerts.py')

if st.button("Create New Alert",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Add_Alert.py')

if st.button("Manage User",
            type='primary',
            use_container_width=True):
  st.switch_page('Delete User.py')

if st.button("Manage Advice",
            type='primary',
            use_container_width=True):
  st.switch_page('Delete_Advice.py')

