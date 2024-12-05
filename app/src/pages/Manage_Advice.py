import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Manage Advice")

"""
Use this to view and manage advice made my users.
"""

st.write('')
st.write('')
st.write('### All Advice')
data = {} 
try:
  admin_id = 1
  data = requests.get(f'http://api:4000/4/advice').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

st.write('')
st.write('')
st.write("### Find Advice by Role ID")

position_id = st.text_input("Role ID:")


def find_advice(role_id):
    try:
        response = requests.get(
        f'http://api:4000/4/advice/{role_id}',
        )
        if response.status_code == 200:
            st.success("Advice found successfully!")
            return response.json()
        else:
            st.error("No advice found.")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Find Advice"):
    role_data = find_advice(position_id)
    st.dataframe(role_data)


st.write('')
st.write('')
st.write("### Delete Advice")

delete_advice_id = st.text_input("Advice ID of the advice you wish to delete:")

def delete_advice(advice_id):
    try:
        response = requests.delete(
            f'http://api:4000/4/advice/{advice_id}',
        )
        if response.status_code == 200:
            st.success("Advice deleted successfully!")
        else:
            st.error(f"Failed to delete advice: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Delete Advice"):
    delete_advice(delete_advice_id)
 
 

