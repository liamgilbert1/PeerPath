import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}.")
st.write('')
st.write('')
st.write('### How can we help you on your co-op search?')

# Job Opportunities Section
st.subheader("Job Opportunities")
col1, col2 = st.columns(2)
with col1:
    if st.button('View Roles', type='primary', use_container_width=True):
        st.switch_page('pages/01_Job_List.py')
    if st.button('See Advice', type='primary', use_container_width=True):
        st.switch_page('pages/03_Get_Advice.py')
with col2:
    if st.button('Find Resources', type='primary', use_container_width=True):
        st.switch_page('pages/02_Find_Resources.py')

st.write('')

# Employer Information Section
st.subheader("Employer Information")
col5, col6 = st.columns(2)
with col5:
    if st.button('Employer Ratings', type='primary', use_container_width=True):
        st.switch_page('pages/07_See_Ratings.py')
with col6:
    if st.button('Employer Reviews', type='primary', use_container_width=True):
        st.switch_page('pages/08_See_Reviews.py')

st.write('')

# Questions and Answers Section
st.subheader("Questions and Answers")
if st.button('Questions and Answers', type='primary', use_container_width=True):
    st.switch_page('pages/09_Questions_And_Answers.py')

# Advice and Resources Section
st.subheader("Advice and Resources")
col1, col2 = st.columns(2)
with col1:
    if st.button('Give Advice for Role', type='primary', use_container_width=True):
        st.switch_page('pages/Give_Advice.py')
    if st.button('Add a Resource', type='primary', use_container_width=True):
        st.switch_page('pages/Add_Resource.py')
with col2:
    if st.button('Answer an Underclassman\'s Question', type='primary', use_container_width=True):
        st.switch_page('pages/Answer_Question.py')

st.write('')

# Ratings Section
st.subheader("Ratings")
if st.button('Add a Rating', type='primary', use_container_width=True):
    st.switch_page('pages/Add_Rating.py')

st.write('')

# Reviews Section
st.subheader("Manage Reviews")
if st.button('Add a Review', type='primary', use_container_width=True):
    st.switch_page('pages/Add_Review.py')
if st.button('Manage Reviews', type='primary', use_container_width=True):
    st.switch_page('pages/Manage_Reviews.py')

st.write('')

# Social Connections Section
st.subheader("Social Connections")
col5, col6 = st.columns(2)
with col5:
    if st.button('View Friends', type='primary', use_container_width=True):
        st.switch_page('pages/04_View_Friends.py')
    if st.button('Add Friends', type='primary', use_container_width=True):
        st.switch_page('pages/06_Add_Friend.py')
with col6:
    if st.button('Remove Friends', type='primary', use_container_width=True):
        st.switch_page('pages/05_Remove_Friend.py')

st.write('')

# Profile Section
st.subheader("Profile Settings")
if st.button('Profile Settings', type='primary', use_container_width=True):
    st.switch_page('pages/10_Profile_Settings.py')
