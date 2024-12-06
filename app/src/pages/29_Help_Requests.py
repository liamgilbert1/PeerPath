import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Manage Help Requests")

"""
Use this to view and manage all help requests made by users.
"""

st.write('')
st.write('')
st.write('### All Help Requests')
data = {} 
try:
  admin_id = 1
  data = requests.get(f'http://api:4000/4/helprequest').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

st.write('')
st.write('')
st.write('### Update Request')


update_request_id = st.text_input("Request ID of the request you wish to update status of:")
update_choice = st.selectbox("Set status to:", ["Completed", "In Progress", "Incomplete"])


def update_request(request_id, choice):
    try:
        response = requests.put(
            f'http://api:4000/4/helprequest/{request_id}',
            json={"status": choice.lower()}
        )
        if response.status_code == 200:
            st.success("Request status updated successfully!")
        else:
            st.error(f"Failed to update request status: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Update Request Status"):
    update_request(update_request_id, update_choice)
  
st.write('')
st.write('')
st.write("### Delete Request")

delete_request_id = st.text_input("Request ID of the request you wish to delete:")


def delete_request(request_id):
    try:
        response = requests.delete(
            f'http://api:4000/4/helprequest/{request_id}',
        )
        if response.status_code == 200:
            st.success("Request deleted successfully!")
        else:
            st.error(f"Failed to delete request: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Delete Request"):
    delete_request(delete_request_id)
 

