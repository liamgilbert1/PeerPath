# `database-files` Folder

# Fall 2024 CS 3200 Project Database

This database stores all the data integral to the operators of this application, including...

## Strong Entities

system_admin - adminstrators of the site
resource - resources that users can recommend or access
employer - companies that are offering or have offered co-ops/internships
coordinator - co-op coordinators
user - students or graduates
question - commonly asked questions regarding the job application and internship process

## Weak Entities

system_alert - alerts from a system admin that can be sent to different types of users
role - co-op or internship positions at a specific employer
advice - pieces of advice shared about a role by a student who formally held the positiom
answer - student answers to the commonly asked questions
hourly_activity - summaries of the activity of a specific user during a session per hour
help_request - requests sent by users to coordinators or admin regarding questions or issues
rating - quantitative reviews of a role written by users
review - qualitative reviews of a role written by users
peer_interaction - interactions between users
notes - notes taken by coordinators on employers other coordinators

## Bridge Tables

user_resource - recommended resources by a given user
friendship - list of all friendships between users
user_role - roles of which a specific user has undertaken during their co-op expieriences.

## To Re-Bootstrap the DB

- 1. `docker compose down` shutdowns and deletes the containers
- 2. `docker compose up ` starts all the containers in the background

This will restart the database and revert it to the original data.
