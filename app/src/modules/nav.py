# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st

def ProfileSettings():
    st.sidebar.page_link("Profile_Settings.py", label="Profile Settings", icon="👤")


#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Home.py", label="Home", icon="🏠")


def AboutPageNav():
    st.sidebar.page_link("pages/About.py", label="About", icon="🧠")


#### ------------------------ Persona 1 ------------------------
def Persona1HomeNav():
    st.sidebar.page_link(
        "pages/00_Jerry_Home.py", label="Jerry's Home Page", icon="👤"
    )

## -------------------------- Persona 2 ------------------------
def Persona2HomeNav():
    st.sidebar.page_link(
        "pages/11_Jordan_Home.py", label="Jordan's Home Page", icon="👤")

## -------------------------- Persona 3 ------------------------
def Persona3HomeNav():
    st.sidebar.page_link(
        "pages/Stacy_Home.py", label="Stacy's Home Page", icon="👤"
    )

#### ------------------------ Persona 4 ------------------------
def Persona4HomeNav():
    st.sidebar.page_link("pages/Phil_Home.py", label="Phil's Home Page", icon="🖥️")


# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """
    # add a logo to the sidebar always
    st.sidebar.image("assets/logo.png", width=275)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        # Show the Home page link (the landing page)
        HomeNav()
        # Show the About page at the bottom of the list of links
        AboutPageNav()

    # Show the other page navigators depending on the id of the user/coordinator/system admin
    if st.session_state["authenticated"]:
        # Show ___ and ___ if the user_id = 1.
        if st.session_state["user_id"] == 1:
            Persona1HomeNav()

        # If the user id = 2, show ____.
        if st.session_state["user_id"] == 2:
            Persona2HomeNav()

        # If the coordinator id is 1, show ___.
        if st.session_state["coordinator_id"] == 1:
            Persona3HomeNav()
        
        # If the admin id is 1, show ___.
        if st.session_state["admin_id"] == 1:
            Persona4HomeNav()


    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            st.session_state['authenticated'] = False
            st.session_state['user_id'] = None
            st.session_state['first_name'] = None
            st.session_state['coordinator_id'] = None
            st.session_state['admin_id'] = None
            st.session_state['role'] = None
            st.switch_page("Home.py")
