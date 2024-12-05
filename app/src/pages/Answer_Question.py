import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Answer Question")

'''
Use this page to answer a question that another student has asked.
'''

question_id = st.text_input("Question ID:")
answer = st.text_area("Answer:")

def add_answer(question_id):
    try:
        response = requests.post(
            f'http://api:4000/p/question/{question_id}/answer',
            json={"answer": answer},  # Send required data as JSON
        )
        if response.status_code == 200:
            st.success("Answer added successfully!")
        else:
            try:
                error_message = response.json().get("error", response.text)
            except ValueError:
                error_message = response.text or "Unknown error occurred"
            st.error(f"Failed to add answer: {error_message}")
    except Exception as e:
        st.error(f"An error occurred: {e}")