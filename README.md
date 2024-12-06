# Fall 2024 CS 3200 Project: PeerPath

PeerPath is designed to make the process of co-op easier. Whether it's asking any questions you may have, finding unbiased opinions on co-op roles, or making reviews yourself, PeerPath has you covered! 

PeerPath: an unfiltered network for professional development.

## Team Members

Liam Gilbert
Joseph Carlucci
Caroline Monaco
Jake Bernhard

## Functionality

PeerPath is able to carry out a variety of functions for multiple user types. Some of our abilities include...

Students:
- View Co-op Roles
- See & Give Advice
- Find & Add Resources
- View, Add, & Remove Friends
- Employer Ratings & Reviews
- Profile Settings
- Add Ratings
- Answer Common Questions
- Add, Edit, & Delete Reviews

Co-op Coordinators & Other Decision Makers:
- Find & View Users
- Retrieve Ratings
- Manage Notes

System Administrators:
- View Hourly Activity
- Manage User Permissions
- Manage Requests
- View & Create System Alerts
- Manage Users
- Manage Advice

## Current Project Components

Currently, there are three major components which will each run in their own Docker Containers:

- Streamlit App in the `./app` directory
- Flask REST api in the `./api` directory
- SQL files for your data model and data base in the `./database-files` directory

## Controlling the Containers

- `docker compose up -d` to start all the containers in the background
- `docker compose down` to shutdown and delete the containers
- `docker compose up db -d` only start the database container (replace db with the other services as needed)
- `docker compose stop` to "turn off" the containers but not delete them. 