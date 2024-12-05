import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Manage Notes")

"""
Use this page to manage your notes.
"""

user_id = st.session_state['coordinator_id']

st.write('')
st.write('')
st.write("### Find Notes by Coordinator ID or Employer ID")

filter_choice = st.selectbox("Choose what to filter by:", ["Coordinator ID", "Employer ID"])

if filter_choice == "Coordinator ID":
    coordinator_id = st.text_input("Coordinator ID:")
elif filter_choice == "Employer ID":
    employer_id = st.text_input("Employer ID:")

def find_notes(filter_type, decisionmaker_id):
    try:
        response = requests.get(
        f'http://api:4000/3/notes/{decisionmaker_id}',
        json={"filter_type": filter_type}
        )
        if response.status_code == 200:
            st.success("Notes found successfully!")
            return response.json()
        else:
            st.error("No notes found.")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Find"):
    if filter_choice == "Coordinator ID" and coordinator_id:
        data = find_notes("coordinator", coordinator_id)
    elif filter_choice == "Employer ID":
        data = find_notes("employer", employer_id)
    else:
        st.error("Please enter a valid ID.")
    
    if data:
        st.dataframe(data)

st.write('')
st.write('')
st.write("### Create a Note")

create_choice = st.selectbox("Choose who to create a note for:", ["Coordinator", "Employer"])

if create_choice == "Coordinator":
    create_coordinator_id = st.text_input("Coordinator ID you want note for:")
elif create_choice == "Employer":
    create_employer_id = st.text_input("Employer ID you want note for:")

note_text = st.text_area("Note Text:")

def add_note(filter_type, decisionmakerID, note_text, user_id):
    try:
        response = requests.post(
            f'http://api:4000/3/notes/{decisionmakerID}',
            json={"filter_type": filter_type, "note_text": note_text, "user_id": user_id}
        )
        if response.status_code == 200:
            st.success("Note added successfully!")
        else:
            st.error(f"Failed to add note: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Add Note"):
    if create_choice == "Coordinator" and create_coordinator_id:
        add_note("coordinator", create_coordinator_id, note_text, user_id)
    elif create_choice == "Employer" and create_employer_id:
        add_note("employer", create_employer_id, note_text, user_id)
    else:
        st.error("Please enter a valid ID.")

st.write('')
st.write('')
st.write('### Update a Note')

update_choice = st.selectbox("Choose who to update a note for:", ["Coordinator", "Employer"])

if update_choice == "Coordinator":
    update_coordinator_id = st.text_input("Coordinator ID you want to update note for:")
    update_note_id = st.text_input("Note ID you want to update:")
elif update_choice == "Employer":
    update_employer_id = st.text_input("Employer ID you want to update note for:")
    update_note_id = st.text_input("Note ID you want to update:")

note_text = st.text_area("Update Note Text:")

def update_note(filter_type, decisionmakerID, noteID, note_text, user_id):
    try:
        response = requests.put(
            f'http://api:4000/3/notes/{decisionmakerID}/{noteID}',
            json={"filter_type": filter_type, "note_text": note_text, "user_id": user_id}
        )
        if response.status_code == 200:
            st.success("Note updated successfully!")
        else:
            st.error(f"Failed to update note: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Update Note"):
    if update_choice == "Coordinator" and update_coordinator_id:
        update_note("coordinator", update_coordinator_id, update_note_id, note_text, user_id)
    elif update_choice == "Employer" and update_employer_id:
        update_note("employer", update_employer_id, update_note_id, note_text, user_id)
    else:
        st.error("Please enter a valid ID.")

st.write('')
st.write('')
st.write("### Delete a Note")

delete_choice = st.selectbox("Choose who to delete a note for:", ["Coordinator", "Employer"])

if delete_choice == "Coordinator":
    delete_coordinator_id = st.text_input("Coordinator ID you want to delete note for:")
    delete_note_id = st.text_input("Note ID you want to delete:")
elif delete_choice == "Employer":
    delete_employer_id = st.text_input("Employer ID you want to delete note for:")
    delete_note_id = st.text_input("Note ID you want to delete:")

def delete_note(filter_type, decisionmakerID, noteID):
    try:
        response = requests.delete(
            f'http://api:4000/3/notes/{decisionmakerID}/{noteID}',
            json={"filter_type": filter_type}
        )
        if response.status_code == 200:
            st.success("Note deleted successfully!")
        else:
            st.error(f"Failed to delete note: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Delete Note"):
    if delete_choice == "Coordinator" and delete_coordinator_id:
        delete_note("coordinator", delete_coordinator_id, delete_note_id)
    elif delete_choice == "Employer" and delete_employer_id:
        delete_note("employer", delete_employer_id, delete_note_id)
    else:
        st.error("Please enter a valid ID.")

