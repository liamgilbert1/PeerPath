import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout='wide')

SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### What would you like to do?')

# Activity and Alerts Section
st.subheader("Activity and Alerts")
col1, col2 = st.columns(2)
with col1:
    if st.button('View Hourly Activity', type='primary', use_container_width=True):
        st.switch_page('pages/View_Activity.py')
    if st.button('View All System Alerts', type='primary', use_container_width=True):
        st.switch_page('pages/View_Alerts.py')
with col2:
    if st.button('Create New Alert', type='primary', use_container_width=True):
        st.switch_page('pages/Add_Alert.py')

st.write('')

# User Management Section
st.subheader("User Management")
col3, col4 = st.columns(2)
with col3:
    if st.button('Manage User Permissions', type='primary', use_container_width=True):
        st.switch_page('pages/User_Permissions.py')
    if st.button('Manage Users', type='primary', use_container_width=True):
        st.switch_page('pages/Manage_Users.py')
with col4:
    if st.button('Manage Advice', type='primary', use_container_width=True):
        st.switch_page('pages/Manage_Advice.py')
    if st.button('Manage Requests', type='primary', use_container_width=True):
        st.switch_page('pages/Help_Requests.py')
