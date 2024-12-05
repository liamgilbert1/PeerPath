# Fall 2024 CS 3200 Project: PeerPath

PeerPath is designed to make the process of co-op easier. Whether it's asking any questions you may have, finding unbiased opinions on co-op roles, or making reviews yourself, PeerPath has you covered! 

PeerPath: an unfiltered network for professional development.

## Functionality

If you are not familiar with web app development, this code base might be confusing. You will probably want two versions though:
1. One version for you to explore, try things, break things, etc. We'll call this your **Personal Repo** 
1. One version of the repo that your team will share.  We'll call this the **Team Repo**. 

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