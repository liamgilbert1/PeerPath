# `database-files` Folder

# Fall 2024 CS 3200 Project Database

This database stores all the data integral to the operators of this application, including...

## Strong Entities

1. system_admin - adminstrators of the site
2. resource - resources that users can recommend or access
3. employer - companies that are offering or have offered co-ops/internships
4. coordinator - co-op coordinators
5. user - students or graduates
6. question - commonly asked questions regarding the job application and internship process

## Weak Entities

1. system_alert - alerts from a system admin that can be sent to different types of users
2. role - co-op or internship positions at a specific employer
3. advice - pieces of advice shared about a role by a student who formally held the positiom
4. answer - student answers to the commonly asked questions
5. hourly_activity - summaries of the activity of a specific user during a session per hour
6. help_request - requests sent by users to coordinators or admin regarding questions or issues
7. rating - quantitative reviews of a role written by users
8. review - qualitative reviews of a role written by users
9. peer_interaction - interactions between users
10. notes - notes taken by coordinators on employers other coordinators

## Bridge Tables

1. user_resource - recommended resources by a given user
2. friendship - list of all friendships between users
3. user_role - roles of which a specific user has undertaken during their co-op expieriences.

## To Re-Bootstrap the DB

- 1. `docker compose down` shutdowns and deletes the containers
- 2. `docker compose up ` starts all the containers in the background

This will restart the database and revert it to the original data.
