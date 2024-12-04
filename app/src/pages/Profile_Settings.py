import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Profile Settings")

"""
Use this page to update your profile settings. Make your changes, then click the 'Save' button to update your profile.
"""