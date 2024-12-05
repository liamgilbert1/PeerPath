import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout = 'wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### How can we help you on your co-op search?')

if st.button('Give Advice for Role', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Give_Advice.py')

if st.button('Add a Resource', 
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Add_Resource.py')

if st.button("Add a Rating",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Add_Rating.py')

if st.button("Edit a Rating",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Edit_Rating.py')

if st.button("Delete a Rating",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Delete_Rating.py')

if st.button("Answer an Underclassman's Question",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Answer_Question.py')

if st.button("Add a Review",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Add_Review.py')

if st.button('View Friends', 
            type='primary',
            use_container_width=True):
  st.switch_page('pages/View_Friends.py')

if st.button("Profile Settings",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Profile_Settings.py')

if st.button("Add Friends",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Add_Friend.py')

if st.button("Remove Friends",
             type='primary',
             use_container_width=True):
  st.switch_page('pages/Remove_Friend.py')