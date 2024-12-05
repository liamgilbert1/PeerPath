import streamlit as st
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks(True)

st.write("# About this App")

st.markdown (
    """
    PeerPath is your one-stop shop for all things co-op and career related.

    Here, you can find resources, ask questions, and get advice from your peers.

    We want to make the stressful process of co-op easier and less intimidating.

    We hope you enjoy PeerPath!
    """
        )
