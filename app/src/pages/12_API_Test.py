import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Accessing a REST API from Within Streamlit")

"""
Simply retrieving data from a REST api running in a separate Docker Container.

If the container isn't running, this will be very unhappy.  But the Streamlit app 
should not totally die. 
"""
data = {} 
try:
  user_id = 2
  data = requests.get(f'http://api:4000/p/user/{user_id}').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data = {"a":{"b": "123", "c": "hello"}, "z": {"b": "456", "c": "goodbye"}}

st.dataframe(data)

data30 = {}
try:
  data30 = requests.get('http://api:4000/3/users').json()
except:
    st.write("**Important**: Could not connect to sample api, so using dummy data.")
    data30 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data30)

data31 = {}
try:
  data31 = requests.get('http://api:4000/3/users/1').json()
except:
    st.write("**Important**: Could not connect to sample api, so using dummy data.")
    data31 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data31)

data3 = {}
try:
  data3 = requests.get('http://api:4000/3/ratings').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data3 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data3)

data33 = {}
try:
  data33 = requests.get('http://api:4000/3/notes/2').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data33 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data33)

note_text = st.text_area("Note Text:")
employer_id = st.text_input("Employer ID (optional):")

def add_note(decisionmakerID, note_text, employer_id):
  try:

    payload = {
      "note": note_text,
      "employer_id": employer_id if employer_id else None
    }
    response = requests.post(
      f'http://api:4000/3/notes/{decisionmakerID}',
      json = payload
    )
    if response.status_code == 200:
      st.success("Note added successfully!")
    else:
      st.error(f"Failed to add note: {response.text}")
  except Exception as e:
    st.error(f"An error occurred: {e}")

if st.button("Add"):
  add_note(1, note_text, employer_id)


data34 = {}
try:
  data34 = requests.get('http://api:4000/3/notes/2').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data34 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]

current_note = [item.get("note", "") for item in data34][0]
current_employer_id = [item.get("employer_id", "") for item in data34][0]

note = st.text_area("Note:", value=current_note)
employer_id = st.text_input("Employer ID:", value=current_employer_id)

def update_note(decisionmakerID, noteID, note_text, employer_id):
  try:
    payload = {
      "note": note_text,
      "employer_id": employer_id if employer_id else None
    }
    response = requests.put(
      f'http://api:4000/3/notes/{decisionmakerID}/{noteID}',
      json = payload
    )
    if response.status_code == 200:
      st.success("Note updated successfully!")
    else:
      st.error(f"Failed to update note: {response.text}")
  except Exception as e:
    st.error(f"An error occurred: {e}")

if st.button("Update"):
  update_note(1, 1, note, employer_id)


note_id = st.text_input("Note ID:")

def delete_note(decisionmakerID, noteID):
  try:
    response = requests.delete(
      f'http://api:4000/3/notes/{decisionmakerID}/{noteID}'
    )
    if response.status_code == 200:
      st.success("Note deleted successfully!")
    else:
      st.error(f"Failed to delete note: {response.text}")
  except Exception as e:
    st.error(f"An error occurred: {e}")
  
if st.button("Delete"):
  delete_note(1, note_id)

data35 = {}
try:
  data35 = requests.get('http://api:4000/3/ratings/1').json()
except:
  st.write("**Important**: Could not connect to sample api, so using dummy data.")
  data35 = [{"a": "123", "b": "hello"}, {"a": "456", "b": "goodbye"}]
st.dataframe(data35)





