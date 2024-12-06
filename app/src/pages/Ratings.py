import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Retrieve Ratings")

"""
Use this page to find all ratings by users on PeerPath.
"""

st.write('')
st.write('')

st.write("### Find Ratings by Coordinator ID")

coordinator_id = st.text_input("Coordinator ID:")

def find_ratings(coordinator_id):
    try:
        response = requests.get(
        f'http://api:4000/3/ratings/{coordinator_id}',
        )
        if response.status_code == 200:
            st.success("Ratings found successfully!")
            return response.json()
        else:
            st.error("No ratings found.")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Find"):
    data = find_ratings(coordinator_id)
    st.dataframe(data)

st.write('')
st.write('')

st.write("### All Ratings")

data = {}
try:
  data = requests.get('http://api:4000/3/ratings').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data)

st.write('')
st.write('')

st.write("### All Coordinators")
"""
Use to find coordinator IDs.
"""

coordinator_data = {}
try:
  coordinator_data = requests.get('http://api:4000/3/coordinators').json()
except:
    st.write("**Important**: Could not connect to sample api, so using dummy data.")
    coordinator_data = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(coordinator_data)

