import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

user_id = st.session_state['admin_id']

st.write("# Add New System Alert")

create_alert_title = st.text_input("Title of new alert:")
create_alert_description = st.text_area("Alert Description:")
create_receivers_choice = st.selectbox("Choose who receives this alert", ["Users","Coordinators", "Admins", "Everyone"])


def add_alert(title, description, receivers, admin_id):
    try:
        response = requests.post(
            f'http://api:4000/4/systemalert/{admin_id}',
            json={"title": title, "description": description, "receivers": receivers}
        )
        if response.status_code == 200:
            st.success("Alert posted successfully!")
        else:
            st.error(f"Failed to post alert: {response.text}")
    except Exception as e:
        st.error(f"An error occurred: {e}")

if st.button("Post Alert"):
    add_alert(create_alert_title, create_alert_description, create_receivers_choice, user_id)

