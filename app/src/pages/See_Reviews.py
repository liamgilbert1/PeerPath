import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Employer Reviews")

"""
Use this page to view reviews for a specific employer! Enter the employer id, then click the 'Get Reviews' button to see the reviews.
"""

employer_id = st.text_input("Employer Id:")

def get_ratings(employer_id):
    data = {}
    try:
        data = requests.get(
        f'http://api:4000/c/reviews/{employer_id}',
        ).json()
        st.dataframe(data)
    except Exception as e:
        st.error(f"An error occurred: {e}")

# Button to trigger the get ratings function
if st.button("Get Reviews"):
    get_ratings(employer_id)