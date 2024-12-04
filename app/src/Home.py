# Establish basic logging infrastructure
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Imports
import streamlit as st
from modules.nav import SideBarLinks

# Set default session state values
st.session_state['authenticated'] = False
st.session_state['user_id'] = None
st.session_state['first_name'] = None
st.session_state['coordinator_id'] = None
st.session_state['admin_id'] = None

# Make wide layout
st.set_page_config(layout = 'wide')

# Links on side bar
SideBarLinks(show_home=True)

# Create title and insert slogan and prompt
logger.info("Loading the Home page of the app")
st.title('PeerPath')
st.write('An unfiltered network for professional growth.')
st.write('### Select a user to log in as:')

# Create buttons for each persona that mimic logging in
if st.button("Act as Jerry, a 2nd year student searching for his 1st co-op", 
            type = 'primary', 
            use_container_width=True):
    # Change authentication to True (user is now "logged in")
    st.session_state['authenticated'] = True
    # Set id of current user (Jerry)
    st.session_state['user_id'] = 1
    # Add first name of user
    st.session_state['first_name'] = 'Jerry'
    # Switch to Jerry's home page
    logger.info("Logging in as Jerry (First Time Co-op Persona)")
    st.switch_page('pages/Jerry_Home.py')

if st.button('Act as Jordan, a 4th year finishing his second co-op', 
            type = 'primary', 
            use_container_width=True):
    # Change authentication to True (user is now "logged in")
    st.session_state['authenticated'] = True
    # Set id of current user (Jordan)
    st.session_state['user_id'] = 2
    # Add first name of user
    st.session_state['first_name'] = 'Jordan'
    # Switch to Jordan's home page
    st.switch_page('pages/Jordan_Home.py')

if st.button('Act as Stacy, a co-op coordinator', 
            type = 'primary', 
            use_container_width=True):
    # Change authentication to True (user is now "logged in")
    st.session_state['authenticated'] = True
    # Set id of current coordinator (Stacy)
    st.session_state['coordinator_id'] = 1
    # Add first name of user
    st.session_state['first_name'] = 'Stacy'
    # Switch to Stacy's home page
    st.switch_page('pages/Stacy_Home.py')

if st.button('Act as Phil, a system administrator', 
            type = 'primary', 
            use_container_width=True):
    # Change authentication to True (user is now "logged in")
    st.session_state['authenticated'] = True
    # Set id of current system admin (Phil)
    st.session_state['admin_id'] = 1
    # Add first name of user
    st.session_state['first_name'] = 'Phil'
    # Switch to Phil's home page
    st.switch_page('pages/Phil_Home.py')