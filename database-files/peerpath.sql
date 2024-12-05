DROP DATABASE IF EXISTS peer_path;

CREATE DATABASE IF NOT EXISTS peer_path;

SHOW DATABASES;

USE peer_path;

CREATE TABLE IF NOT EXISTS system_admin (
    admin_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(75) not null,
    username varchar(30) UNIQUE not null,
    email varchar(75) not null,
    phone_number varchar(15)
);

CREATE TABLE IF NOT EXISTS system_alert (
    alert_id int primary key auto_increment,
    user_id int not null,
    title varchar(128) not null,
    description varchar(1000),
    receivers varchar(128),
    CONSTRAINT fk_admin_alert
        FOREIGN KEY (user_id) REFERENCES  system_admin (admin_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS resource (
    resource_id int primary key auto_increment,
    title varchar(128) not null,
    description varchar(1000),
    link varchar(256)
);

CREATE TABLE IF NOT EXISTS employer (
    employer_id int primary key auto_increment,
    name varchar(128) not null,
    location varchar(75) not null,
    industry varchar(75) not null
);

CREATE TABLE IF NOT EXISTS coordinator (
    coordinator_id int primary key auto_increment,
    admin_id int not null,
    first_name varchar(50) not null,
    last_name varchar(75) not null,
    email varchar(75) not null,
    content varchar(512),
    satisfaction_score int unsigned,
    activity_status varchar(50),
    CONSTRAINT fk_coordinator_admin
        FOREIGN KEY (admin_id) REFERENCES  system_admin (admin_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS user (
    user_id int primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(75) not null,
    username varchar(30) UNIQUE not null,
    email varchar(75) not null,
    student_type varchar(50) not null,
    coordinator int not null,
    admin int not null,
    activity_status varchar(50),
    urgency_status varchar(50),
    search_status varchar(128),
    user_permissions varchar(128) not null,
    CONSTRAINT fk_user_coordinator
        FOREIGN KEY (coordinator) REFERENCES  coordinator (coordinator_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_user_admin
        FOREIGN KEY (admin) REFERENCES system_admin (admin_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS question (
    question_id int primary key auto_increment,
    question_text varchar(500) UNIQUE not null
);

CREATE TABLE IF NOT EXISTS role (
    role_id int primary key auto_increment,
    title varchar(128) not null,
    employer int not null,
    description varchar(1000),
    CONSTRAINT fk_employer_role
        FOREIGN KEY (employer) REFERENCES employer (employer_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS advice (
    advice_id int primary key auto_increment,
    user int not null,
    role int not null,
    advice_text varchar(500) not null,
    CONSTRAINT fk_advice_user
        FOREIGN KEY (user) REFERENCES user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_advice_role
        FOREIGN KEY (role) REFERENCES role (role_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS answer (
    answer_id int primary key auto_increment,
    question int not null,
    user int not null,
    answer varchar(500) not null,
    CONSTRAINT fk_question_answer
        FOREIGN KEY (question) REFERENCES question (question_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_user_answer
        FOREIGN KEY (user) REFERENCES user (user_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS user_resource (
    user_id int,
    resource_id int,
    PRIMARY KEY (user_id, resource_id),
    CONSTRAINT fk_user_id_resource
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_resource_id_user
        FOREIGN KEY (resource_id) REFERENCES  resource (resource_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS hourly_activity (
    activity_id int primary key auto_increment,
    user_id int not null,
    date_time datetime not null default current_timestamp,
    min_per_hr_online int unsigned not null,
    pages_visited int unsigned not null,
    CONSTRAINT fk_activity_user
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS help_request (
    request_id int primary key auto_increment,
    user_id int not null,
    coordinator_requested int not null,
    date_submitted datetime not null default current_timestamp,
    description varchar(1000) not null,
    status varchar(50) not null,
    admin_id int not null,
    CONSTRAINT fk_help_user
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_help_admin
        FOREIGN KEY (admin_id) REFERENCES  system_admin (admin_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_help_coordinator
        FOREIGN KEY (coordinator_requested) REFERENCES  coordinator (coordinator_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS rating (
     rating_id int primary key auto_increment,
     user_id int not null,
     role_id int not null,
     future_job_score int unsigned not null,
     work_quality_score int unsigned not null,
     manager_score int unsigned not null,
     salary_score int unsigned not null,
     lifestyle_score int unsigned not null,
     CONSTRAINT fk_rating_user
         FOREIGN KEY (user_id) REFERENCES  user (user_id)
             ON UPDATE cascade ON DELETE cascade,
     CONSTRAINT fk_rating_role
         FOREIGN KEY (role_id) REFERENCES  role (role_id)
             ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS review (
    review_id int primary key auto_increment,
    user_id int not null,
    role_id int not null,
    num_up_votes int unsigned default 0,
    num_down_votes int unsigned default 0,
    comment varchar(1000),
    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_review_role
        FOREIGN KEY (role_id) REFERENCES role (role_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS peer_interaction (
    interaction_id int primary key auto_increment,
    user_id int not null,
    peer_user_id int not null,
    date_time datetime not null default current_timestamp,
    topic varchar(256),
    CONSTRAINT fk_interaction_user
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_interaction_peer
        FOREIGN KEY (peer_user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS friendship (
    user_id int not null,
    friend_id int not null,
    PRIMARY KEY (user_id, friend_id),
    CONSTRAINT fk_user_friendship
        FOREIGN KEY (user_id) REFERENCES user (user_id)
            ON UPDATE cascade ON DELETE cascade ,
    CONSTRAINT fk_friend_friendship
        FOREIGN KEY (friend_id) REFERENCES user (user_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS notes (
    note_id int primary key auto_increment,
    user_id int not null,
    employer_id int,
    coordinator_id int,
    note_text varchar(500) not null,
    CONSTRAINT fk_notes_user
        FOREIGN KEY (user_id) REFERENCES user (user_id)
            ON UPDATE cascade ON DELETE cascade ,
    CONSTRAINT fk_notes_employer
        FOREIGN KEY (employer_id) REFERENCES employer (employer_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_notes_coordinator
        FOREIGN KEY (coordinator_id) REFERENCES coordinator (coordinator_id)
            ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE IF NOT EXISTS user_role (
    user_id int not null,
    role_id int not null,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_role_user
        FOREIGN KEY (user_id) REFERENCES user (user_id)
        ON UPDATE cascade ON DELETE cascade ,
    CONSTRAINT fk_user_role
        FOREIGN KEY (role_id) REFERENCES role (role_id)
            ON UPDATE cascade ON DELETE cascade
);

SHOW TABLES;


insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (1, 'Phil', 'Stern', 'pstern', 'pstern@ted.com', '(450) 4210818');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (2, 'Stephannie', 'Glaserman', 'sglaserman1', 'sglaserman1@sourceforge.net', '(127) 1404608');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (3, 'Pip', 'Orae', 'porae2', 'porae2@wikia.com', '(291) 3065036');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (4, 'Weylin', 'Brearley', 'wbrearley3', 'wbrearley3@dailymail.co.uk', '(620) 8178327');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (5, 'Celie', 'Bester', 'cbester4', 'cbester4@histats.com', '(708) 1515095');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (6, 'Eryn', 'Noyes', 'enoyes5', 'enoyes5@theglobeandmail.com', '(139) 6215635');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (7, 'Laure', 'Whannel', 'lwhannel6', 'lwhannel6@loc.gov', '(495) 5698197');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (8, 'Bobette', 'Gronaver', 'bgronaver7', 'bgronaver7@sina.com.cn', '(987) 8072067');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (9, 'Fitzgerald', 'Adshead', 'fadshead8', 'fadshead8@dion.ne.jp', '(882) 9421022');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (10, 'Johannah', 'Danaher', 'jdanaher9', 'jdanaher9@gravatar.com', '(529) 2546952');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (11, 'Anabal', 'Copelli', 'acopellia', 'acopellia@tripod.com', '(243) 5519552');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (12, 'Barnie', 'Hoggan', 'bhogganb', 'bhogganb@java.com', '(187) 5713597');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (13, 'Padget', 'Hallwood', 'phallwoodc', 'phallwoodc@over-blog.com', '(792) 8436556');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (14, 'Delphinia', 'Heaford', 'dheafordd', 'dheafordd@opensource.org', '(838) 8892318');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (15, 'Milly', 'Spinello', 'mspinelloe', 'mspinelloe@ca.gov', '(528) 4884766');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (16, 'Alfredo', 'Piggot', 'apiggotf', 'apiggotf@usnews.com', '(611) 1571614');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (17, 'Tessy', 'Mourant', 'tmourantg', 'tmourantg@gizmodo.com', '(560) 9763728');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (18, 'Consuela', 'Sweetlove', 'csweetloveh', 'csweetloveh@oaic.gov.au', '(246) 9578849');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (19, 'Danila', 'Dupree', 'ddupreei', 'ddupreei@facebook.com', '(827) 6012820');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (20, 'Coop', 'Fuzzard', 'cfuzzardj', 'cfuzzardj@chicagotribune.com', '(622) 6516057');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (21, 'Davie', 'Cow', 'dcowk', 'dcowk@sfgate.com', '(991) 6241039');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (22, 'Glenn', 'Normant', 'gnormantl', 'gnormantl@psu.edu', '(351) 6256244');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (23, 'Elberta', 'Roma', 'eromam', 'eromam@census.gov', '(636) 4130428');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (24, 'Clement', 'Frend', 'cfrendn', 'cfrendn@squarespace.com', '(249) 9927174');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (25, 'Starr', 'Embra', 'sembrao', 'sembrao@nydailynews.com', '(272) 8281812');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (26, 'Jock', 'Chinery', 'jchineryp', 'jchineryp@nhs.uk', '(578) 1736983');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (27, 'Horacio', 'Perryn', 'hperrynq', 'hperrynq@dell.com', '(619) 2710950');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (28, 'Erena', 'Neubigin', 'eneubiginr', 'eneubiginr@ocn.ne.jp', '(375) 4859717');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (29, 'Eduardo', 'Beneix', 'ebeneixs', 'ebeneixs@meetup.com', '(866) 1793512');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (30, 'Vassili', 'Sighard', 'vsighardt', 'vsighardt@blogtalkradio.com', '(298) 6564172');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (31, 'Ferne', 'Biggar', 'fbiggaru', 'fbiggaru@salon.com', '(843) 1569117');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (32, 'Casi', 'Garlant', 'cgarlantv', 'cgarlantv@tinyurl.com', '(568) 5878692');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (33, 'Joseph', 'Slograve', 'jslogravew', 'jslogravew@spiegel.de', '(732) 8174440');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (34, 'Gerhard', 'Berks', 'gberksx', 'gberksx@google.cn', '(301) 2563490');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (35, 'Hall', 'Brizland', 'hbrizlandy', 'hbrizlandy@blog.com', '(733) 3105120');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (36, 'Colline', 'Happs', 'chappsz', 'chappsz@who.int', '(923) 8169650');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (37, 'Quinton', 'Ruffey', 'qruffey10', 'qruffey10@wikipedia.org', '(326) 3030478');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (38, 'Ingmar', 'Laybourn', 'ilaybourn11', 'ilaybourn11@tamu.edu', '(526) 4313654');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (39, 'Allister', 'Whittenbury', 'awhittenbury12', 'awhittenbury12@telegraph.co.uk', '(102) 6727918');
insert into system_admin (admin_id, first_name, last_name, username, email, phone_number) values (40, 'Giselle', 'Becarra', 'gbecarra13', 'gbecarra13@twitpic.com', '(913) 4625405');

insert into system_alert (alert_id, user_id, title, description, receivers) values (1, 8, 'performance issue', 'High error rate detected in API endpoint /auth/login', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (2, 32, 'system error', 'Unauthorized data export attempt detected on UserID 1043', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (3, 9, 'security breach', 'Memory usage on API-Gateway02 exceeded 90% threshold', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (4, 34, 'security breach', 'SSL certificate for www.example.com is set to expire in 7 days', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (5, 38, 'system error', 'Scheduled maintenance window on LoadBalancer01 begins in 30 minutes', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (6, 9, 'security breach', 'User account locked due to multiple failed password attempts', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (7, 22, 'performance issue', 'Disk space on Drive C: is below 10% on Server01', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (8, 32, 'performance issue', 'Database connection pool exhausted on DB-Cluster02', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (9, 6, 'security breach', 'Firewall rule conflict detected between Rule-101 and Rule-203', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (10, 7, 'system error', 'Application Error: Failed to load configuration file on Service-A', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (11, 12, 'system error', 'Application Error: Failed to load configuration file on Service-A', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (12, 32, 'system error', 'Network latency exceeded 200ms for outbound traffic to 192.168.1.1', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (13, 6, 'system error', 'Application Error: Failed to load configuration file on Service-A', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (14, 20, 'system error', 'Network latency exceeded 200ms for outbound traffic to 192.168.1.1', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (15, 6, 'system error', 'Firewall rule conflict detected between Rule-101 and Rule-203', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (16, 26, 'system error', 'DNS resolution failure for internal.example.local', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (17, 37, 'system error', 'DNS resolution failure for internal.example.local', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (18, 16, 'system error', 'User account locked due to multiple failed password attempts', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (19, 37, 'security breach', 'Scheduled maintenance window on LoadBalancer01 begins in 30 minutes', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (20, 33, 'performance issue', 'Data synchronization delay detected between Region1 and Region2', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (21, 3, 'security breach', 'High error rate detected in API endpoint /auth/login', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (22, 37, 'system error', 'Database connection pool exhausted on DB-Cluster02', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (23, 22, 'system error', 'Data synchronization delay detected between Region1 and Region2', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (24, 7, 'performance issue', 'Firewall rule conflict detected between Rule-101 and Rule-203', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (25, 37, 'performance issue', 'Network latency exceeded 200ms for outbound traffic to 192.168.1.1', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (26, 21, 'system error', 'Unauthorized login attempt from IP 203.45.67.89 at 14:23 UTC', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (27, 14, 'performance issue', 'User account locked due to multiple failed password attempts', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (28, 17, 'security breach', 'DNS resolution failure for internal.example.local', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (29, 7, 'system error', 'Scheduled maintenance window on LoadBalancer01 begins in 30 minutes', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (30, 15, 'security breach', 'Firewall rule conflict detected between Rule-101 and Rule-203', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (31, 28, 'security breach', 'Scheduled maintenance window on LoadBalancer01 begins in 30 minutes', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (32, 27, 'performance issue', 'Application Error: Failed to load configuration file on Service-A', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (33, 21, 'performance issue', 'Service restart required on QueueManager04 after unhandled exception', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (34, 7, 'system error', 'Disk space on Drive C: is below 10% on Server01', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (35, 30, 'security breach', 'Memory usage on API-Gateway02 exceeded 90% threshold', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (36, 2, 'performance issue', 'Backup job failed on StorageNode07 due to insufficient permissions', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (37, 40, 'system error', 'Firewall rule conflict detected between Rule-101 and Rule-203', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (38, 11, 'security breach', 'Memory usage on API-Gateway02 exceeded 90% threshold', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (39, 25, 'security breach', 'Service restart required on QueueManager04 after unhandled exception', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (40, 5, 'performance issue', 'Network latency exceeded 200ms for outbound traffic to 192.168.1.1', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (41, 31, 'security breach', 'Application Error: Failed to load configuration file on Service-A', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (42, 40, 'security breach', 'Memory usage on API-Gateway02 exceeded 90% threshold', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (43, 30, 'security breach', 'Service restart required on QueueManager04 after unhandled exception', 'admins');
insert into system_alert (alert_id, user_id, title, description, receivers) values (44, 30, 'performance issue', 'Memory usage on API-Gateway02 exceeded 90% threshold', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (45, 35, 'security breach', 'DNS resolution failure for internal.example.local', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (46, 1, 'performance issue', 'Data synchronization delay detected between Region1 and Region2', 'users');
insert into system_alert (alert_id, user_id, title, description, receivers) values (47, 22, 'performance issue', 'SSL certificate for www.example.com is set to expire in 7 days', 'everyone');
insert into system_alert (alert_id, user_id, title, description, receivers) values (48, 24, 'performance issue', 'SSL certificate for www.example.com is set to expire in 7 days', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (49, 35, 'performance issue', 'Firewall rule conflict detected between Rule-101 and Rule-203', 'coordinators');
insert into system_alert (alert_id, user_id, title, description, receivers) values (50, 33, 'performance issue', 'Unauthorized login attempt from IP 203.45.67.89 at 14:23 UTC', 'users');

insert into resource (resource_id, title, description, link) values (1, 'LinkedIn Learning', 'Offers a wide range of professional development courses including job application skills interview preparation and technical skill-building', 'https://www.linkedin.com/learning/');
insert into resource (resource_id, title, description, link) values (2, 'Glassdoor', 'Provides company reviews interview questions and salary information to help tailor job applications', 'https://www.glassdoor.com/');
insert into resource (resource_id, title, description, link) values (3, 'Resume Builders', 'Tools for creating professional resumes and cover letters optimized for specific industries and job roles', 'https://www.zety.com/resume-builder');
insert into resource (resource_id, title, description, link) values (4, 'Jobscan', 'Optimizes resumes by comparing them to job descriptions and suggesting keyword and skill improvements', 'https://www.jobscan.co/');
insert into resource (resource_id, title, description, link) values (5, 'Indeed Career Guide', 'Offers helpful job-searching tips resume-building advice and interview prep resources', 'https://www.indeed.com/career-advice');
insert into resource (resource_id, title, description, link) values (6, 'AngelList', 'A job board focused on startup positions allowing direct applications and profile building', 'https://angel.co/jobs');
insert into resource (resource_id, title, description, link) values (7, 'Leetcode', 'A platform for practicing coding challenges offering a wide array of problems for different skill levels', 'https://leetcode.com/');
insert into resource (resource_id, title, description, link) values (8, 'HackerRank', 'Provides coding challenges and competitions with solutions and discussions to improve programming skills', 'https://www.hackerrank.com/');
insert into resource (resource_id, title, description, link) values (9, 'The Muse', 'Offers career advice job-searching strategies and guides on preparing for interviews and career transitions', 'https://www.themuse.com/');
insert into resource (resource_id, title, description, link) values (10, 'GitHub', 'A platform for version control and collaboration useful for showcasing projects and contributing to open-source', 'https://github.com/');
insert into resource (resource_id, title, description, link) values (11, 'Codewars', 'A coding challenge site where users solve puzzles to improve their programming skills', 'https://www.codewars.com/');
insert into resource (resource_id, title, description, link) values (12, 'Udemy', 'An online platform offering various technical courses including coding web development and machine learning', 'https://www.udemy.com/');
insert into resource (resource_id, title, description, link) values (13, 'Coursera', 'A massive open online course provider offering a wide range of subjects including business and technical skills', 'https://www.coursera.org/');
insert into resource (resource_id, title, description, link) values (14, 'edX', 'An online learning platform offering free courses in various disciplines including programming data science and more', 'https://www.edx.org/');
insert into resource (resource_id, title, description, link) values (15, 'freeCodeCamp', 'A free coding bootcamp that teaches HTML CSS JavaScript and other web development skills', 'https://www.freecodecamp.org/');
insert into resource (resource_id, title, description, link) values (16, 'Codeacademy', 'An interactive platform offering beginner-friendly coding lessons in various languages like Python JavaScript and more', 'https://www.codecademy.com/');
insert into resource (resource_id, title, description, link) values (17, 'Project Euler', 'A platform offering mathematical and coding problems designed to improve problem-solving skills', 'https://projecteuler.net/');
insert into resource (resource_id, title, description, link) values (18, 'Stack Overflow', 'A popular Q&A website where developers can ask questions and share answers on coding and software development topics', 'https://stackoverflow.com/');
insert into resource (resource_id, title, description, link) values (19, 'W3Schools', 'An online resource with tutorials on web development programming languages and more', 'https://www.w3schools.com/');
insert into resource (resource_id, title, description, link) values (20, 'Khan Academy', 'An educational website offering free programming tutorials in various languages including JavaScript Python and SQL', 'https://www.khanacademy.org/');
insert into resource (resource_id, title, description, link) values (21, 'SoloLearn', 'An online learning platform offering courses in programming data science and machine learning', 'https://www.sololearn.com/');
insert into resource (resource_id, title, description, link) values (22, 'YouTube programming channels', 'A community-driven website offering coding challenges and tutorials for developers of all skill levels', 'https://www.youtube.com/');
insert into resource (resource_id, title, description, link) values (23, 'DataCamp', 'A coding platform that provides challenges and projects to learn data science machine learning and deep learning', 'https://www.datacamp.com/');
insert into resource (resource_id, title, description, link) values (24, 'Kaggle', 'A competitive programming platform where developers can solve problems participate in contests and learn new skills', 'https://www.kaggle.com/');
insert into resource (resource_id, title, description, link) values (25, 'TopCoder', 'A platform offering a variety of programming and software development courses including algorithms and system design', 'https://www.topcoder.com/');
insert into resource (resource_id, title, description, link) values (26, 'Exponent', 'A website offering a wide variety of programming resources coding challenges and tutorials', 'https://www.tryexponent.com/');
insert into resource (resource_id, title, description, link) values (27, 'Pramp', 'A website offering coding challenges to help improve your programming and problem-solving abilities', 'https://www.pramp.com/');
insert into resource (resource_id, title, description, link) values (28, 'Interviewing.io', 'An interactive platform for coding interviews and competitive programming challenges', 'https://www.interviewing.io/');
insert into resource (resource_id, title, description, link) values (29, 'Cracking the Coding Interview', 'An interactive learning platform that offers various technical challenges to improve coding and interview skills', 'https://www.crackingthecodinginterview.com/');
insert into resource (resource_id, title, description, link) values (30, 'GeeksforGeeks', 'A platform offering courses in web development algorithms and other programming-related skills', 'https://www.geeksforgeeks.org/');
insert into resource (resource_id, title, description, link) values (31, 'HackerRank Interview Prep', 'A platform offering personalized coaching for coding interviews and technical job preparation', 'https://www.hackerrank.com/domains/tutorials/10-days-of-javascript');
insert into resource (resource_id, title, description, link) values (32, 'AlgoExpert', 'A repository and social platform for hosting and sharing code with version control', 'https://www.algoexpert.io/');
insert into resource (resource_id, title, description, link) values (33, 'CodeSignal', 'A website offering a wide range of coding problems to practice and improve algorithmic skills', 'https://codesignal.com/');
insert into resource (resource_id, title, description, link) values (34, 'Coderbyte', 'A platform offering coding exercises and challenges for various technical interviews', 'https://coderbyte.com/');
insert into resource (resource_id, title, description, link) values (35, 'Interview Cake', 'A competitive programming website offering challenges and contests for developers', 'https://www.interviewcake.com/');
insert into resource (resource_id, title, description, link) values (36, 'C++ documentation', 'A website offering resources for learning various programming languages including C++ Java and Python', 'https://en.cppreference.com/w/');
insert into resource (resource_id, title, description, link) values (37, 'Python documentation', 'An online platform with challenges for mastering algorithms and preparing for coding interviews', 'https://docs.python.org/3/');
insert into resource (resource_id, title, description, link) values (38, 'JavaScript documentation', 'A job board and career advice site offering resources for navigating technical interviews and job applications', 'https://developer.mozilla.org/en-US/docs/Web/JavaScript');
insert into resource (resource_id, title, description, link) values (39, 'Java documentation', 'Offers a wide range of professional development courses including job application skills interview preparation and technical skill-building', 'https://docs.oracle.com/en/java/');
insert into resource (resource_id, title, description, link) values (40, 'SQLZoo', 'Provides company reviews interview questions and salary information to help tailor job applications', 'https://sqlzoo.net/');

insert into employer (employer_id, name, location, industry) values (1, 'Google', 'Salt Lake City', 'Streaming');
insert into employer (employer_id, name, location, industry) values (2, 'Apple', 'New York', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (3, 'Microsoft', 'Stockholm', 'Software');
insert into employer (employer_id, name, location, industry) values (4, 'Amazon', 'Zurich', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (5, 'Facebook', 'Zurich', 'Communications');
insert into employer (employer_id, name, location, industry) values (6, 'Tesla', 'Ottawa', 'E-commerce');
insert into employer (employer_id, name, location, industry) values (7, 'IBM', 'Hong Kong', 'E-commerce');
insert into employer (employer_id, name, location, industry) values (8, 'Intel', 'Menlo Park', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (9, 'Nvidia', 'Mountain View', 'Investment Management');
insert into employer (employer_id, name, location, industry) values (10, 'Salesforce', 'Redmond', 'Fintech');
insert into employer (employer_id, name, location, industry) values (11, 'Oracle', 'San Jose', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (12, 'Adobe', 'New York', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (13, 'Cisco', 'San Francisco', 'Fintech');
insert into employer (employer_id, name, location, industry) values (14, 'SAP', 'London', 'Fintech');
insert into employer (employer_id, name, location, industry) values (15, 'Zoom', 'Chicago', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (16, 'Twitter', 'Austin', 'Software');
insert into employer (employer_id, name, location, industry) values (17, 'LinkedIn', 'San Francisco', 'Social Media');
insert into employer (employer_id, name, location, industry) values (18, 'Spotify', 'San Francisco', 'Social Media');
insert into employer (employer_id, name, location, industry) values (19, 'Square', 'Chicago', 'Social Media');
insert into employer (employer_id, name, location, industry) values (20, 'Shopify', 'Salt Lake City', 'Automotive');
insert into employer (employer_id, name, location, industry) values (21, 'Pinterest', 'San Francisco', 'Social Media');
insert into employer (employer_id, name, location, industry) values (22, 'Snap', 'Hong Kong', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (23, 'Uber', 'New York', 'Technology');
insert into employer (employer_id, name, location, industry) values (24, 'Airbnb', 'Hong Kong', 'Software');
insert into employer (employer_id, name, location, industry) values (25, 'Lyft', 'Boston', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (26, 'Robinhood', 'Boston', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (27, 'PayPal', 'Zurich', 'Investment Management');
insert into employer (employer_id, name, location, industry) values (28, 'Stripe', 'New York', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (29, 'Credit Suisse', 'San Francisco', 'Technology');
insert into employer (employer_id, name, location, industry) values (30, 'Goldman Sachs', 'Austin', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (31, 'JPMorgan Chase', 'London', 'Technology');
insert into employer (employer_id, name, location, industry) values (32, 'Morgan Stanley', 'San Francisco', 'Technology');
insert into employer (employer_id, name, location, industry) values (33, 'Wells Fargo', 'San Francisco', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (34, 'BlackRock', 'San Francisco', 'Social Media');
insert into employer (employer_id, name, location, industry) values (35, 'Citibank', 'Salt Lake City', 'Social Media');
insert into employer (employer_id, name, location, industry) values (36, 'Bank of America', 'Walldorf', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (37, 'Charles Schwab', 'Ottawa', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (38, 'Fidelity Investments', 'San Francisco', 'Fintech');
insert into employer (employer_id, name, location, industry) values (39, 'Vanguard', 'San Mateo', 'Financial Services');
insert into employer (employer_id, name, location, industry) values (40, 'Deutsche Bank', 'Stockholm', 'Fintech');

insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (1, 21, 'Stacy', 'Northea', 'snorthea@pbs.org', 'Oversees internship placement and development programs for students ensuring alignment with academic goals and industry needs', 2, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (2, 6, 'Micaela', 'Antoniat', 'mantoniat1@fema.gov', 'Manages co-op program operations supporting students through internships and building partnerships with employers', 5, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (3, 39, 'Carmelia', 'Philipsen', 'cphilipsen2@forbes.com', 'Provides guidance to students on securing internships while fostering relationships with industry partners to expand opportunities', 8, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (4, 9, 'Lissy', 'Trew', 'ltrew3@microsoft.com', 'Coordinates internship logistics from application processes to placement ensuring smooth transitions for students', 10, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (5, 19, 'Fonz', 'Sawnwy', 'fsawnwy4@nhs.uk', 'Acts as a liaison between students faculty and employers to create valuable co-op experiences', 7, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (6, 26, 'Dal', 'Sustins', 'dsustins5@chicagotribune.com', 'Helps students explore career paths through hands-on internship experiences', 8, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (7, 22, 'Burnaby', 'Sutterby', 'bsutterby6@ucoz.ru', 'Organizes career fairs and networking events for students to connect with potential employers', 10, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (8, 7, 'Marlane', 'Goodwell', 'mgoodwell7@adobe.com', 'Advises students on resume building and interview preparation for co-op positions', 3, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (9, 31, 'Mella', 'McGhee', 'mmcghee8@opera.com', 'Facilitates student preparation for co-op placements including workshops and one-on-one consultations', 10, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (10, 20, 'Gannie', 'Kynson', 'gkynson9@vinaora.com', 'Builds and maintains relationships with companies to provide diverse co-op opportunities', 4, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (11, 10, 'Olly', 'Conaboy', 'oconaboya@unesco.org', 'Develops and implements policies related to internship programs to ensure student success', 6, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (12, 14, 'Aharon', 'Boeck', 'aboeckb@flickr.com', 'Coordinates with academic departments to integrate internship experiences into degree programs', 2, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (13, 14, 'Layney', 'Walbrun', 'lwalbrunc@usgs.gov', 'Supports employers by helping them find qualified interns and providing resources for successful co-op programs', 4, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (14, 8, 'Adara', 'Godbehere', 'agodbehered@dedecms.com', 'Evaluates internship program success through feedback from students and employers', 10, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (15, 23, 'Carmelia', 'Wornham', 'cwornhame@xrea.com', 'Assists in developing co-op curricula that align with industry trends and educational objectives', 1, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (16, 25, 'Dareen', 'Taveriner', 'dtaverinerf@livejournal.com', 'Provides ongoing support to students throughout their internship experiences', 3, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (17, 34, 'Reeta', 'Clemmensen', 'rclemmenseng@amazon.com', 'Helps students secure international internship opportunities', 9, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (18, 35, 'Brose', 'Frude', 'bfrudeh@odnoklassniki.ru', 'Tracks student progress and ensures they meet academic and professional requirements during internships', 8, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (19, 24, 'Hardy', 'Bowart', 'hbowarti@rambler.ru', 'Guides students through the process of obtaining co-op work permits and visa documentation', 9, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (20, 14, 'Barnabas', 'Gowan', 'bgowanj@loc.gov', 'Offers career counseling to students seeking full-time employment after internships', 8, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (21, 30, 'Heriberto', 'Speariett', 'hspeariettk@cnn.com', 'Organizes employer workshops to ensure they understand the co-op program and student expectations', 2, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (22, 39, 'Bendick', 'McConnal', 'bmcconnall@goodreads.com', 'Conducts research to stay up-to-date on emerging trends in internship and co-op program development', 9, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (23, 23, 'Jodie', 'Horstead', 'jhorsteadm@irs.gov', 'Advocates for co-op and internship opportunities at academic conferences and professional events', 10, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (24, 11, 'Ario', 'Dinneen', 'adinneenn@rakuten.co.jp', 'Creates marketing materials to promote internship and co-op programs', 9, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (25, 38, 'Rod', 'Biscomb', 'rbiscombo@newsvine.com', 'Assists in integrating co-op experiences into career development programs for students', 4, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (26, 36, 'Giovanna', 'Starie', 'gstariep@jiathis.com', 'Collaborates with faculty to ensure internship opportunities align with course objectives', 7, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (27, 36, 'Kareem', 'Durrance', 'kdurranceq@cafepress.com', 'Ensures compliance with university policies and labor laws for all co-op placements', 10, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (28, 25, 'Edwina', 'Ghirigori', 'eghirigorir@geocities.jp', 'Monitors student and employer feedback to improve co-op program offerings', 7, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (29, 1, 'Frederic', 'Lindenstrauss', 'flindenstrausss@sfgate.com', 'Promotes diversity and inclusion within co-op and internship programs', 2, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (30, 19, 'Codi', 'Cowling', 'ccowlingt@php.net', 'Coordinates virtual and remote internship opportunities for students across various industries', 8, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (31, 20, 'Viola', 'Thomesson', 'vthomessonu@ted.com', 'Provides mentorship to students during their internship journey', 9, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (32, 36, 'Will', 'Lulham', 'wlulhamv@webs.com', 'Works with alumni to expand internship and co-op networks', 2, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (33, 6, 'Lacey', 'Chave', 'lchavew@loc.gov', 'Manages budgets and resources for co-op program development', 5, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (34, 10, 'Gothart', 'Scarre', 'gscarrex@globo.com', 'Develops partnerships with community organizations to enhance co-op opportunities', 8, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (35, 7, 'Calv', 'Veasey', 'cveaseyy@liveinternet.ru', 'Supports employers in offering professional development for student interns', 9, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (36, 38, 'Paola', 'Arnli', 'parnliz@mac.com', 'Fosters a culture of continuous improvement within co-op and internship programs', 9, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (37, 23, 'Magdalene', 'Giacubbo', 'mgiacubbo10@umn.edu', 'Assists students with post-internship reflection and career transition strategies', 10, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (38, 40, 'Stanfield', 'Akeherst', 'sakeherst11@feedburner.com', 'Oversees internship placement and development programs for students ensuring alignment with academic goals and industry needs', 8, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (39, 12, 'Catrina', 'Harbor', 'charbor12@squidoo.com', 'Manages co-op program operations supporting students through internships and building partnerships with employers', 9, 'offline');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (40, 4, 'Essy', 'Antoni', 'eantoni13@nature.com', 'Provides guidance to students on securing internships while fostering relationships with industry partners to expand opportunities', 9, 'online');
insert into coordinator (coordinator_id, admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) values (41, 4, 'Jonis', 'Hains', 'jhains14@myspace.com', 'Coordinates internship logistics from application processes to placement ensuring smooth transitions for students', 10, 'offline');

insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (1, 'Jerry', 'Prais', 'jprais10', 'jprais0@yellowbook.com', 'Sophomore', 1, 8, 'offline', 'not urgent', 'applying', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (2, 'Jordan', 'Sman', 'jsman01', 'jsman01@wsj.com', 'Senior', 20, 14, 'online', 'not urgent', 'on co-op', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (3, 'Ira', 'Giacoppoli', 'igiacoppoli2', 'igiacoppoli2@toplist.cz', 'Freshman', 20, 15, 'offline', 'not urgent', 'job found', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (4, 'Paige', 'Yeliashev', 'pyeliashev3', 'pyeliashev3@gizmodo.com', 'Freshman', 30, 19, 'offline', 'semi-urgent', 'next cycle applicant', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (5, 'Friedrick', 'Faint', 'ffaint4', 'ffaint4@bluehost.com', 'Senior', 8, 18, 'offline', 'not urgent', 'next cycle applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (6, 'Elane', 'Curphey', 'ecurphey5', 'ecurphey5@bloglines.com', 'Sophomore', 22, 6, 'online', 'not urgent', 'job found', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (7, 'Oralle', 'Osmon', 'oosmon6', 'oosmon6@unesco.org', 'Graduate', 23, 26, 'offline', 'urgent', 'job found', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (8, 'Marchall', 'Culley', 'mculley7', 'mculley7@zimbio.com', 'Junior', 40, 11, 'offline', 'not urgent', 'future applicant', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (9, 'Barthel', 'Dikle', 'bdikle8', 'bdikle8@about.me', 'Sophomore', 20, 8, 'online', 'semi-urgent', 'future applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (10, 'Selie', 'Hadgraft', 'shadgraft9', 'shadgraft9@yellowbook.com', 'Freshman', 26, 6, 'online', 'urgent', 'on co-op', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (11, 'Sam', 'Boarleyson', 'sboarleysona', 'sboarleysona@ezinearticles.com', 'Junior', 10, 32, 'offline', 'not urgent', 'future applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (12, 'Barbey', 'Heffy', 'bheffyb', 'bheffyb@bizjournals.com', 'Junior', 24, 31, 'offline', 'semi-urgent', 'on co-op', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (13, 'Jozef', 'Heak', 'jheakc', 'jheakc@liveinternet.ru', 'Sophomore', 14, 25, 'online', 'semi-urgent', 'next cycle applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (14, 'Penelope', 'Cund', 'pcundd', 'pcundd@washington.edu', 'Freshman', 29, 28, 'online', 'semi-urgent', 'next cycle applicant', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (15, 'Ric', 'Gerrens', 'rgerrense', 'rgerrense@uol.com.br', 'Freshman', 26, 15, 'online', 'not urgent', 'applying', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (16, 'Cirillo', 'Beeden', 'cbeedenf', 'cbeedenf@forbes.com', 'Senior', 15, 40, 'online', 'urgent', 'job found', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (17, 'Hernando', 'Bridges', 'hbridgesg', 'hbridgesg@joomla.org', 'Graduate', 25, 23, 'online', 'not urgent', 'next cycle applicant', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (18, 'Kendre', 'Gwyther', 'kgwytherh', 'kgwytherh@google.es', 'Freshman', 26, 37, 'online', 'urgent', 'applying', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (19, 'Urson', 'Roach', 'uroachi', 'uroachi@blog.com', 'Senior', 12, 36, 'offline', 'not urgent', 'on co-op', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (20, 'Jefferson', 'Sweetnam', 'jsweetnamj', 'jsweetnamj@over-blog.com', 'Sophomore', 9, 10, 'online', 'semi-urgent', 'next cycle applicant', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (21, 'Nico', 'Swinerd', 'nswinerdk', 'nswinerdk@csmonitor.com', 'Sophomore', 29, 38, 'online', 'semi-urgent', 'future applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (22, 'Lissie', 'Desorts', 'ldesortsl', 'ldesortsl@youtube.com', 'Sophomore', 27, 29, 'online', 'not urgent', 'next cycle applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (23, 'Mable', 'Lavers', 'mlaversm', 'mlaversm@yolasite.com', 'Freshman', 21, 19, 'offline', 'semi-urgent', 'future applicant', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (24, 'Lucius', 'Harmstone', 'lharmstonen', 'lharmstonen@amazon.co.uk', 'Sophomore', 39, 6, 'offline', 'urgent', 'applying', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (25, 'Birk', 'Fawckner', 'bfawcknero', 'bfawcknero@microsoft.com', 'Senior', 15, 37, 'online', 'not urgent', 'future applicant', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (26, 'Adelind', 'Paulin', 'apaulinp', 'apaulinp@cafepress.com', 'Junior', 2, 15, 'offline', 'not urgent', 'on co-op', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (27, 'Shae', 'Cambridge', 'scambridgeq', 'scambridgeq@reuters.com', 'Sophomore', 1, 15, 'online', 'not urgent', 'next cycle applicant', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (28, 'Riccardo', 'Harford', 'rharfordr', 'rharfordr@auda.org.au', 'Sophomore', 9, 12, 'offline', 'urgent', 'future applicant', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (29, 'Nichole', 'Hayler', 'nhaylers', 'nhaylers@elegantthemes.com', 'Graduate', 30, 36, 'offline', 'semi-urgent', 'applying', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (30, 'Boniface', 'Alkin', 'balkint', 'balkint@simplemachines.org', 'Junior', 10, 7, 'offline', 'urgent', 'on co-op', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (31, 'Tildi', 'Guly', 'tgulyu', 'tgulyu@etsy.com', 'Sophomore', 22, 19, 'online', 'semi-urgent', 'applying', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (32, 'Julio', 'Tunno', 'jtunnov', 'jtunnov@linkedin.com', 'Sophomore', 17, 29, 'offline', 'semi-urgent', 'next cycle applicant', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (33, 'Gerladina', 'Savidge', 'gsavidgew', 'gsavidgew@independent.co.uk', 'Graduate', 12, 38, 'offline', 'semi-urgent', 'future applicant', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (34, 'Guntar', 'Uglow', 'guglowx', 'guglowx@meetup.com', 'Junior', 10, 1, 'offline', 'not urgent', 'on co-op', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (35, 'Pamella', 'Decayette', 'pdecayettey', 'pdecayettey@addtoany.com', 'Sophomore', 22, 12, 'online', 'not urgent', 'applying', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (36, 'Ulysses', 'Loynes', 'uloynesz', 'uloynesz@over-blog.com', 'Graduate', 15, 22, 'online', 'urgent', 'on co-op', 'classic');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (37, 'Danice', 'Crossan', 'dcrossan10', 'dcrossan10@buzzfeed.com', 'Freshman', 39, 27, 'online', 'not urgent', 'applying', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (38, 'Vanya', 'Tolworthie', 'vtolworthie11', 'vtolworthie11@cnn.com', 'Junior', 22, 2, 'offline', 'not urgent', 'future applicant', 'advanced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (39, 'Gibb', 'Yell', 'gyell12', 'gyell12@telegraph.co.uk', 'Senior', 20, 17, 'online', 'not urgent', 'applying', 'reduced');
insert into user (user_id, first_name, last_name, username, email, student_type, coordinator, admin, activity_status, urgency_status, search_status, user_permissions) values (40, 'Humberto', 'Mozzetti', 'hmozzetti13', 'hmozzetti13@hud.gov', 'Freshman', 1, 32, 'online', 'urgent', 'job found', 'classic');

insert into question (question_id, question_text) values (1, 'What specific programming languages are required or most commonly used in CS internships');
insert into question (question_id, question_text) values (2, 'How strict is the application deadline for a computer science internship');
insert into question (question_id, question_text) values (3, 'How can I demonstrate my knowledge of data structures and algorithms when applying for a CS internship');
insert into question (question_id, question_text) values (4, 'What specific skills are companies looking for in candidates for CS internships');
insert into question (question_id, question_text) values (5, 'How can I best prepare for technical interviews in competitive CS internship applications');
insert into question (question_id, question_text) values (6, 'What are the most common coding challenges asked in CS internship interviews');
insert into question (question_id, question_text) values (7, 'How important are personal projects or open-source contributions for securing a CS internship');
insert into question (question_id, question_text) values (8, 'Do I need to be familiar with system design concepts for a CS internship');
insert into question (question_id, question_text) values (9, 'How strict are companies about the coding standards and best practices during CS internships');
insert into question (question_id, question_text) values (10, 'Will I be required to work with specific frameworks or libraries during my CS internship');
insert into question (question_id, question_text) values (11, 'How competitive are CS internships at top tech companies');
insert into question (question_id, question_text) values (12, 'What are the key factors for standing out in a highly competitive CS internship application process');
insert into question (question_id, question_text) values (13, 'How much experience with cloud platforms or containerization technologies is necessary for CS internships');
insert into question (question_id, question_text) values (14, 'What kind of technical challenges can I expect to face in a machine learning or AI internship');
insert into question (question_id, question_text) values (15, 'How important is knowledge of version control systems like Git for a CS internship');
insert into question (question_id, question_text) values (16, 'What level of understanding of algorithms and complexity analysis is expected during a CS internship');
insert into question (question_id, question_text) values (17, 'Will I be expected to solve complex coding problems on the job as a CS intern');
insert into question (question_id, question_text) values (18, 'How strictly are deadlines enforced in CS internships');
insert into question (question_id, question_text) values (19, 'How can I demonstrate my ability to work under pressure in a CS internship');
insert into question (question_id, question_text) values (20, 'What kinds of coding practices or tools will I be expected to use in a software development internship');
insert into question (question_id, question_text) values (21, 'How much hands-on experience with databases is required for a CS internship');
insert into question (question_id, question_text) values (22, 'Will I need to know specific operating systems or environments Linux Windows etc for a CS internship');
insert into question (question_id, question_text) values (23, 'How strict are companies about the quality of documentation and testing in CS internships');
insert into question (question_id, question_text) values (24, 'Will I be expected to work in a team environment or independently on projects during a CS internship');
insert into question (question_id, question_text) values (25, 'How do I handle failures or bugs during my CS internship projects');
insert into question (question_id, question_text) values (26, 'What kind of feedback or performance reviews can I expect during a CS internship');
insert into question (question_id, question_text) values (27, 'How much autonomy will I have in a CS internship and when should I seek guidance');
insert into question (question_id, question_text) values (28, 'What are the expectations around learning new technologies on the job during a CS internship');
insert into question (question_id, question_text) values (29, 'What is the level of difficulty of the projects I can expect as a CS intern');
insert into question (question_id, question_text) values (30, 'How do I demonstrate initiative and contribute to a software team during a CS internship');
insert into question (question_id, question_text) values (31, 'How closely will I be monitored or mentored during my CS internship');
insert into question (question_id, question_text) values (32, 'How much networking should I expect to do with colleagues during a CS internship');
insert into question (question_id, question_text) values (33, 'How do I ensure I am meeting the high standards of performance in a CS internship');
insert into question (question_id, question_text) values (34, 'What can I do to ensure my internship experience leads to a full-time offer in a competitive CS role');
insert into question (question_id, question_text) values (35, 'How do I prioritize tasks and manage time effectively in a demanding CS internship environment');
insert into question (question_id, question_text) values (36, 'What resources should I use to stay updated with industry standards and trends during a CS internship');
insert into question (question_id, question_text) values (37, 'How do I demonstrate my leadership skills as a CS intern');
insert into question (question_id, question_text) values (38, 'How can I make the most of my internship to network with senior professionals in the industry');
insert into question (question_id, question_text) values (39, 'How can I show my impact and value to my team as a CS intern');
insert into question (question_id, question_text) values (40, 'What strategies can I use to handle difficult situations or conflicts during my CS internship');

insert into role (role_id, title, employer, description) values (1, 'Data Science Intern', 14, 'Assist in analyzing large datasets building predictive models and generating insights to help business decision-making');
insert into role (role_id, title, employer, description) values (2, 'Software Engineering Intern', 22, 'Contribute to the development and maintenance of software applications by writing testing and debugging code');
insert into role (role_id, title, employer, description) values (3, 'UX/UI Design Intern', 34, 'Collaborate with designers to create user-friendly interfaces and enhance the overall user experience of digital products');
insert into role (role_id, title, employer, description) values (4, 'Cybersecurity Intern', 30, 'Support the cybersecurity team in identifying vulnerabilities conducting risk assessments and improving the security of digital systems');
insert into role (role_id, title, employer, description) values (5, 'Business Analyst Intern', 17, 'Work with business stakeholders to gather requirements analyze processes and develop solutions to improve operations');
insert into role (role_id, title, employer, description) values (6, 'Cloud Computing Intern', 6, 'Assist in the deployment management and optimization of cloud-based infrastructure and services');
insert into role (role_id, title, employer, description) values (7, 'Marketing Intern', 6, 'Help create and execute marketing campaigns conduct market research and support content creation and social media strategies');
insert into role (role_id, title, employer, description) values (8, 'Machine Learning Intern', 12, 'Assist in developing machine learning models conducting experiments and analyzing large sets of data for pattern recognition');
insert into role (role_id, title, employer, description) values (9, 'Mobile App Development Intern', 10, 'Collaborate with the team to design develop and test mobile applications for various platforms like iOS and Android');
insert into role (role_id, title, employer, description) values (10, 'Operations Intern', 37, 'Support the operations team in streamlining processes managing logistics and optimizing overall business operations');
insert into role (role_id, title, employer, description) values (11, 'Business Development Intern', 34, 'Help identify new business opportunities conduct market research and assist in developing growth strategies');
insert into role (role_id, title, employer, description) values (12, 'Web Development Intern', 15, 'Contribute to the development of websites and web applications by writing front-end and back-end code');
insert into role (role_id, title, employer, description) values (13, 'Product Management Intern', 38, 'Assist in managing the product lifecycle collaborating with teams on new features and ensuring timely product releases');
insert into role (role_id, title, employer, description) values (14, 'Sales Intern', 22, 'Support the sales team by generating leads conducting market research and assisting in the sales process');
insert into role (role_id, title, employer, description) values (15, 'DevOps Intern', 15, 'Collaborate with development and IT teams to streamline deployment processes and improve system efficiency');
insert into role (role_id, title, employer, description) values (16, 'Finance Intern', 15, 'Analyze large-scale datasets and create visualizations to support business decision-making');
insert into role (role_id, title, employer, description) values (17, 'Consulting Intern', 5, 'Assist in software testing and quality assurance to ensure high performance and reliability');
insert into role (role_id, title, employer, description) values (18, 'Human Resources Intern', 38, 'Work alongside the engineering team to design and build scalable applications');
insert into role (role_id, title, employer, description) values (19, 'Database Administration Intern', 40, 'Collaborate on creating AI and automation solutions for business processes');
insert into role (role_id, title, employer, description) values (20, 'Project Management Intern', 34, 'Assist in optimizing business workflows and operations through process improvements');
insert into role (role_id, title, employer, description) values (21, 'Business Analyst Intern', 17, 'Create content for digital marketing campaigns and track their effectiveness');
insert into role (role_id, title, employer, description) values (22, 'Marketing Intern', 11, 'Work with product managers to create product roadmaps and ensure smooth project execution');
insert into role (role_id, title, employer, description) values (23, 'Data Science Intern', 11, 'Assist in customer relationship management and help improve the customer experience');
insert into role (role_id, title, employer, description) values (24, 'Software Engineering Intern', 37, 'Support the logistics team by tracking inventory and coordinating delivery schedules');
insert into role (role_id, title, employer, description) values (25, 'Mobile App Development Intern', 33, 'Develop and implement strategies to increase sales and market share');
insert into role (role_id, title, employer, description) values (26, 'Finance Intern', 29, 'Participate in meetings and brainstorming sessions to improve team collaboration and project outcomes');
insert into role (role_id, title, employer, description) values (27, 'Consulting Intern', 12, 'Help design and implement customer-facing features for mobile applications');
insert into role (role_id, title, employer, description) values (28, 'Operations Intern', 1, 'Manage databases to store and retrieve business data and assist in database optimization');
insert into role (role_id, title, employer, description) values (29, 'DevOps Intern', 24, 'Assist the IT team in troubleshooting issues and ensuring optimal system performance');
insert into role (role_id, title, employer, description) values (30, 'Business Development Intern', 10, 'Research market trends to help businesses stay ahead of competitors');
insert into role (role_id, title, employer, description) values (31, 'Cloud Computing Intern', 8, 'Work with data engineers to ensure clean and organized datasets for analysis');
insert into role (role_id, title, employer, description) values (32, 'Machine Learning Intern', 28, 'Help identify areas of improvement in current systems and recommend enhancements');
insert into role (role_id, title, employer, description) values (33, 'Sales Intern', 27, 'Assist in creating dashboards and reports to track business performance');
insert into role (role_id, title, employer, description) values (34, 'Database Administration Intern', 15, 'Analyze business needs and support the development of custom solutions for clients');
insert into role (role_id, title, employer, description) values (35, 'Cybersecurity Intern', 1, 'Assist in analyzing large datasets building predictive models and generating insights to help business decision-making');
insert into role (role_id, title, employer, description) values (36, 'Product Management Intern', 21, 'Contribute to the development and maintenance of software applications by writing testing and debugging code');
insert into role (role_id, title, employer, description) values (37, 'Web Development Intern', 24, 'Collaborate with designers to create user-friendly interfaces and enhance the overall user experience of digital products');
insert into role (role_id, title, employer, description) values (38, 'Human Resources Intern', 26, 'Support the cybersecurity team in identifying vulnerabilities conducting risk assessments and improving the security of digital systems');
insert into role (role_id, title, employer, description) values (39, 'Business Development Intern', 21, 'Work with business stakeholders to gather requirements analyze processes and develop solutions to improve operations');
insert into role (role_id, title, employer, description) values (40, 'Marketing Intern', 38, 'Assist in the deployment management and optimization of cloud-based infrastructure and services');
insert into role (role_id, title, employer, description) values (41, 'UX/UI Design Intern', 7, 'Help create and execute marketing campaigns conduct market research and support content creation and social media strategies');
insert into role (role_id, title, employer, description) values (42, 'Software Engineering Intern', 17, 'Assist in developing machine learning models conducting experiments and analyzing large sets of data for pattern recognition');
insert into role (role_id, title, employer, description) values (43, 'Sales Intern', 30, 'Collaborate with the team to design develop and test mobile applications for various platforms like iOS and Android');
insert into role (role_id, title, employer, description) values (44, 'DevOps Intern', 15, 'Support the operations team in streamlining processes managing logistics and optimizing overall business operations');
insert into role (role_id, title, employer, description) values (45, 'Data Science Intern', 10, 'Help identify new business opportunities conduct market research and assist in developing growth strategies');
insert into role (role_id, title, employer, description) values (46, 'Software Engineering Intern', 25, 'Contribute to the development of websites and web applications by writing front-end and back-end code');
insert into role (role_id, title, employer, description) values (47, 'UX/UI Design Intern', 7, 'Assist in managing the product lifecycle collaborating with teams on new features and ensuring timely product releases');
insert into role (role_id, title, employer, description) values (48, 'Cybersecurity Intern', 21, 'Support the sales team by generating leads conducting market research and assisting in the sales process');
insert into role (role_id, title, employer, description) values (49, 'Business Analyst Intern', 22, 'Collaborate with development and IT teams to streamline deployment processes and improve system efficiency');
insert into role (role_id, title, employer, description) values (50, 'Cloud Computing Intern', 16, 'Analyze large-scale datasets and create visualizations to support business decision-making');

insert into advice (advice_id, user, role, advice_text) values (1, 15, 11, 'Always ask questions and seek clarity when needed');
insert into advice (advice_id, user, role, advice_text) values (2, 24, 26, 'Build a strong network your connections can often be just as important as your skills');
insert into advice (advice_id, user, role, advice_text) values (3, 20, 29, 'Stay up to date with the latest technologies and trends in your field');
insert into advice (advice_id, user, role, advice_text) values (4, 32, 32, 'Don''t be afraid to fail learn from your mistakes and grow');
insert into advice (advice_id, user, role, advice_text) values (5, 24, 30, 'Prioritize communication it’s just as important as technical skills');
insert into advice (advice_id, user, role, advice_text) values (6, 5, 16, 'Never stop learning seek out opportunities to expand your knowledge');
insert into advice (advice_id, user, role, advice_text) values (7, 16, 18, 'Show initiative and always look for ways to add value');
insert into advice (advice_id, user, role, advice_text) values (8, 2, 7, 'Don’t wait for opportunities to come to you create them');
insert into advice (advice_id, user, role, advice_text) values (9, 31, 23, 'Embrace challenges as opportunities to learn and grow');
insert into advice (advice_id, user, role, advice_text) values (10, 33, 22, 'Be proactive not reactive in your work');
insert into advice (advice_id, user, role, advice_text) values (11, 23, 15, 'Stay organized and manage your time effectively');
insert into advice (advice_id, user, role, advice_text) values (12, 24, 45, 'Be open to feedback and use it to improve');
insert into advice (advice_id, user, role, advice_text) values (13, 3, 6, 'Take ownership of your projects and responsibilities');
insert into advice (advice_id, user, role, advice_text) values (14, 28, 42, 'Seek mentorship from experienced professionals');
insert into advice (advice_id, user, role, advice_text) values (15, 35, 28, 'Build a strong portfolio to showcase your skills');
insert into advice (advice_id, user, role, advice_text) values (16, 40, 30, 'Develop a growth mindset and be adaptable to change');
insert into advice (advice_id, user, role, advice_text) values (17, 21, 48, 'Stay humble and remember there’s always more to learn');
insert into advice (advice_id, user, role, advice_text) values (18, 21, 2, 'Practice resilience in the face of setbacks');
insert into advice (advice_id, user, role, advice_text) values (19, 11, 5, 'Build your personal brand and reputation early on');
insert into advice (advice_id, user, role, advice_text) values (20, 8, 49, 'Don’t be afraid to ask for help collaboration is key');
insert into advice (advice_id, user, role, advice_text) values (21, 20, 1, 'Be prepared to work hard and stay dedicated to your goals');
insert into advice (advice_id, user, role, advice_text) values (22, 7, 29, 'Take the time to understand the company culture and align with it');
insert into advice (advice_id, user, role, advice_text) values (23, 24, 39, 'Learn to balance work and life to avoid burnout');
insert into advice (advice_id, user, role, advice_text) values (24, 38, 21, 'Volunteer for projects outside of your regular duties to gain more experience');
insert into advice (advice_id, user, role, advice_text) values (25, 12, 4, 'Always strive for excellence but understand that perfection isn’t always achievable');
insert into advice (advice_id, user, role, advice_text) values (26, 5, 48, 'Don’t shy away from difficult tasks tackle them head-on');
insert into advice (advice_id, user, role, advice_text) values (27, 36, 26, 'Be patient success doesn’t happen overnight');
insert into advice (advice_id, user, role, advice_text) values (28, 6, 46, 'Focus on developing both technical and soft skills');
insert into advice (advice_id, user, role, advice_text) values (29, 17, 50, 'Don’t be afraid to take risks in your career');
insert into advice (advice_id, user, role, advice_text) values (30, 5, 46, 'Be mindful of your professional image both online and offline');
insert into advice (advice_id, user, role, advice_text) values (31, 18, 10, 'Understand that failure is part of the learning process');
insert into advice (advice_id, user, role, advice_text) values (32, 27, 34, 'Seek out diverse experiences to broaden your perspective');
insert into advice (advice_id, user, role, advice_text) values (33, 2, 49, 'Stay curious and never stop asking “why”');
insert into advice (advice_id, user, role, advice_text) values (34, 33, 48, 'Learn how to negotiate effectively for your salary and benefits');
insert into advice (advice_id, user, role, advice_text) values (35, 26, 28, 'Practice empathy and emotional intelligence in the workplace');
insert into advice (advice_id, user, role, advice_text) values (36, 20, 36, 'Find ways to stay motivated when things get tough');
insert into advice (advice_id, user, role, advice_text) values (37, 15, 10, 'Focus on long-term goals rather than short-term success');
insert into advice (advice_id, user, role, advice_text) values (38, 39, 26, 'Keep track of your accomplishments and don’t be afraid to share them');
insert into advice (advice_id, user, role, advice_text) values (39, 25, 38, 'Always be honest and transparent in your communication');
insert into advice (advice_id, user, role, advice_text) values (40, 25, 15, 'Cultivate a positive attitude and approach challenges with optimism');
insert into advice (advice_id, user, role, advice_text) values (41, 5, 10, 'Surround yourself with like-minded individuals who inspire you');
insert into advice (advice_id, user, role, advice_text) values (42, 35, 36, 'Be willing to step outside of your comfort zone and try new things');
insert into advice (advice_id, user, role, advice_text) values (43, 38, 33, 'Always be learning whether through formal education self-study or on-the-job experience');
insert into advice (advice_id, user, role, advice_text) values (44, 29, 35, 'Understand the importance of work-life balance and prioritize self-care');
insert into advice (advice_id, user, role, advice_text) values (45, 21, 30, 'Keep a journal of your professional development and progress');
insert into advice (advice_id, user, role, advice_text) values (46, 37, 25, 'Always ask questions and seek clarity when needed');
insert into advice (advice_id, user, role, advice_text) values (47, 2, 12, 'Build a strong network your connections can often be just as important as your skills');
insert into advice (advice_id, user, role, advice_text) values (48, 2, 30, 'Stay up to date with the latest technologies and trends in your field');
insert into advice (advice_id, user, role, advice_text) values (49, 32, 36, 'Don''t be afraid to fail learn from your mistakes and grow');
insert into advice (advice_id, user, role, advice_text) values (50, 10, 5, 'Prioritize communication it’s just as important as technical skills');



insert into user_resource (user_id, resource_id) values (8, 25);
insert into user_resource (user_id, resource_id) values (5, 25);
insert into user_resource (user_id, resource_id) values (6, 20);
insert into user_resource (user_id, resource_id) values (16, 12);
insert into user_resource (user_id, resource_id) values (1, 36);
insert into user_resource (user_id, resource_id) values (10, 1);
insert into user_resource (user_id, resource_id) values (10, 20);
insert into user_resource (user_id, resource_id) values (18, 8);
insert into user_resource (user_id, resource_id) values (1, 10);
insert into user_resource (user_id, resource_id) values (38, 3);
insert into user_resource (user_id, resource_id) values (9, 2);
insert into user_resource (user_id, resource_id) values (29, 16);
insert into user_resource (user_id, resource_id) values (8, 17);
insert into user_resource (user_id, resource_id) values (40, 28);
insert into user_resource (user_id, resource_id) values (13, 32);
insert into user_resource (user_id, resource_id) values (6, 10);
insert into user_resource (user_id, resource_id) values (2, 36);
insert into user_resource (user_id, resource_id) values (35, 30);
insert into user_resource (user_id, resource_id) values (16, 16);
insert into user_resource (user_id, resource_id) values (23, 11);
insert into user_resource (user_id, resource_id) values (14, 13);
insert into user_resource (user_id, resource_id) values (5, 29);
insert into user_resource (user_id, resource_id) values (7, 14);
insert into user_resource (user_id, resource_id) values (30, 29);
insert into user_resource (user_id, resource_id) values (28, 38);
insert into user_resource (user_id, resource_id) values (20, 21);
insert into user_resource (user_id, resource_id) values (31, 24);
insert into user_resource (user_id, resource_id) values (22, 36);
insert into user_resource (user_id, resource_id) values (10, 33);
insert into user_resource (user_id, resource_id) values (33, 25);
insert into user_resource (user_id, resource_id) values (38, 26);
insert into user_resource (user_id, resource_id) values (17, 30);
insert into user_resource (user_id, resource_id) values (23, 7);
insert into user_resource (user_id, resource_id) values (1, 1);
insert into user_resource (user_id, resource_id) values (31, 20);
insert into user_resource (user_id, resource_id) values (9, 8);
insert into user_resource (user_id, resource_id) values (14, 18);
insert into user_resource (user_id, resource_id) values (28, 20);
insert into user_resource (user_id, resource_id) values (16, 34);
insert into user_resource (user_id, resource_id) values (32, 22);
insert into user_resource (user_id, resource_id) values (32, 28);
insert into user_resource (user_id, resource_id) values (30, 25);
insert into user_resource (user_id, resource_id) values (6, 5);
insert into user_resource (user_id, resource_id) values (7, 12);
insert into user_resource (user_id, resource_id) values (12, 24);
insert into user_resource (user_id, resource_id) values (12, 2);
insert into user_resource (user_id, resource_id) values (16, 38);
insert into user_resource (user_id, resource_id) values (16, 21);
insert into user_resource (user_id, resource_id) values (32, 18);
insert into user_resource (user_id, resource_id) values (4, 26);
insert into user_resource (user_id, resource_id) values (15, 17);
insert into user_resource (user_id, resource_id) values (22, 40);
insert into user_resource (user_id, resource_id) values (5, 16);
insert into user_resource (user_id, resource_id) values (2, 30);
insert into user_resource (user_id, resource_id) values (40, 13);
insert into user_resource (user_id, resource_id) values (2, 28);
insert into user_resource (user_id, resource_id) values (27, 17);
insert into user_resource (user_id, resource_id) values (36, 22);
insert into user_resource (user_id, resource_id) values (31, 16);
insert into user_resource (user_id, resource_id) values (26, 30);
insert into user_resource (user_id, resource_id) values (14, 7);
insert into user_resource (user_id, resource_id) values (27, 24);
insert into user_resource (user_id, resource_id) values (7, 7);
insert into user_resource (user_id, resource_id) values (18, 20);
insert into user_resource (user_id, resource_id) values (23, 22);
insert into user_resource (user_id, resource_id) values (2, 19);
insert into user_resource (user_id, resource_id) values (30, 23);
insert into user_resource (user_id, resource_id) values (37, 2);
insert into user_resource (user_id, resource_id) values (28, 40);
insert into user_resource (user_id, resource_id) values (5, 37);
insert into user_resource (user_id, resource_id) values (4, 18);
insert into user_resource (user_id, resource_id) values (32, 24);
insert into user_resource (user_id, resource_id) values (36, 11);
insert into user_resource (user_id, resource_id) values (25, 22);
insert into user_resource (user_id, resource_id) values (18, 13);
insert into user_resource (user_id, resource_id) values (13, 6);
insert into user_resource (user_id, resource_id) values (1, 30);
insert into user_resource (user_id, resource_id) values (36, 28);
insert into user_resource (user_id, resource_id) values (31, 37);
insert into user_resource (user_id, resource_id) values (23, 35);
insert into user_resource (user_id, resource_id) values (15, 36);
insert into user_resource (user_id, resource_id) values (36, 27);
insert into user_resource (user_id, resource_id) values (36, 25);
insert into user_resource (user_id, resource_id) values (35, 35);
insert into user_resource (user_id, resource_id) values (25, 2);
insert into user_resource (user_id, resource_id) values (5, 7);
insert into user_resource (user_id, resource_id) values (16, 10);
insert into user_resource (user_id, resource_id) values (9, 32);
insert into user_resource (user_id, resource_id) values (7, 4);
insert into user_resource (user_id, resource_id) values (35, 36);
insert into user_resource (user_id, resource_id) values (7, 9);
insert into user_resource (user_id, resource_id) values (27, 27);
insert into user_resource (user_id, resource_id) values (1, 29);
insert into user_resource (user_id, resource_id) values (4, 29);
insert into user_resource (user_id, resource_id) values (16, 20);
insert into user_resource (user_id, resource_id) values (39, 30);
insert into user_resource (user_id, resource_id) values (14, 10);
insert into user_resource (user_id, resource_id) values (31, 31);
insert into user_resource (user_id, resource_id) values (10, 16);

insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (1, 35, '2024-07-26 15:27:20', 42, 67);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (2, 20, '2024-11-10 07:53:04', 32, 87);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (3, 40, '2024-02-04 07:37:30', 31, 31);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (4, 4, '2024-06-20 04:53:20', 15, 32);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (5, 23, '2024-07-25 11:17:31', 13, 73);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (6, 14, '2024-10-10 08:36:09', 11, 92);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (7, 24, '2024-10-17 03:05:32', 30, 84);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (8, 17, '2024-10-01 20:39:23', 27, 24);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (9, 5, '2024-07-23 14:19:29', 9, 30);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (10, 23, '2024-04-15 07:34:04', 28, 98);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (11, 36, '2024-03-02 23:43:20', 32, 55);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (12, 4, '2024-06-12 20:29:18', 39, 21);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (13, 33, '2024-10-28 19:15:17', 10, 50);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (14, 9, '2024-05-11 00:48:39', 55, 3);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (15, 30, '2024-02-25 02:44:43', 11, 85);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (16, 24, '2024-01-02 04:14:53', 29, 50);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (17, 1, '2024-04-12 00:46:55', 13, 84);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (18, 16, '2024-06-25 10:20:10', 56, 57);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (19, 27, '2024-04-04 03:50:10', 2, 62);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (20, 15, '2024-09-20 11:19:06', 20, 41);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (21, 24, '2024-11-08 21:41:40', 56, 98);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (22, 28, '2024-07-11 10:04:17', 49, 4);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (23, 6, '2024-07-03 19:49:34', 6, 100);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (24, 25, '2024-08-14 16:07:53', 46, 1);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (25, 38, '2024-05-17 03:46:36', 56, 17);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (26, 30, '2024-09-01 23:01:57', 49, 71);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (27, 21, '2024-02-13 05:39:26', 15, 79);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (28, 27, '2024-04-22 03:53:51', 56, 95);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (29, 8, '2024-06-07 21:26:03', 35, 87);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (30, 3, '2024-02-19 11:15:05', 36, 31);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (31, 11, '2024-06-30 15:29:29', 25, 57);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (32, 9, '2024-07-03 02:23:14', 37, 95);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (33, 11, '2024-10-20 20:34:38', 28, 35);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (34, 30, '2024-01-21 09:45:44', 26, 22);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (35, 16, '2024-02-07 13:36:09', 60, 57);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (36, 38, '2024-07-17 19:35:15', 55, 82);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (37, 14, '2024-03-25 09:26:48', 26, 19);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (38, 30, '2024-04-23 08:32:53', 2, 78);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (39, 27, '2024-06-19 10:48:25', 60, 50);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (40, 16, '2024-02-25 00:54:53', 20, 85);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (41, 16, '2024-11-26 19:03:33', 50, 85);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (42, 40, '2024-09-11 08:31:29', 9, 94);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (43, 4, '2024-04-17 23:13:13', 23, 87);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (44, 12, '2024-12-01 03:38:52', 3, 42);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (45, 13, '2024-01-26 17:43:51', 34, 29);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (46, 1, '2024-08-23 11:32:17', 56, 2);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (47, 17, '2024-03-20 00:24:21', 56, 87);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (48, 33, '2024-04-16 05:15:03', 19, 18);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (49, 21, '2024-10-22 16:42:49', 40, 36);
insert into hourly_activity (activity_id, user_id, date_time, min_per_hr_online, pages_visited) values (50, 28, '2024-04-29 09:59:36', 49, 35);

insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (1, 11, 7, '2023-12-06 16:22:53', 'Strategies for handling multiple internship offers and making informed decisions', 'incomplete', 25);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (2, 17, 31, '2024-06-06 08:02:13', 'The importance of mentorship during internships and how to seek guidance', 'in progress', 14);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (3, 12, 15, '2024-04-17 22:23:59', 'The value of academic credit in relation to real-world internship experience', 'incomplete', 27);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (4, 7, 25, '2024-10-29 10:12:08', 'The importance of mentorship during internships and how to seek guidance', 'in progress', 3);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (5, 6, 27, '2024-10-06 23:07:02', 'The industries and companies most likely to hire interns from our university', 'completed', 36);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (6, 6, 5, '2024-03-16 16:27:17', 'How to follow up professionally after submitting an internship application', 'in progress', 24);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (7, 39, 29, '2024-08-21 17:10:29', 'Preparing for interviews at competitive tech companies and what employers look for', 'incomplete', 12);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (8, 40, 32, '2023-12-22 14:53:52', 'The value of academic credit in relation to real-world internship experience', 'incomplete', 38);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (9, 4, 25, '2024-01-15 04:41:33', 'How to manage stress and maintain productivity during an internship', 'in progress', 15);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (10, 27, 17, '2024-04-24 13:28:56', 'How to secure academic credit for internships outside your major', 'in progress', 34);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (11, 28, 8, '2024-02-26 17:12:12', 'Strategies for handling multiple internship offers and making informed decisions', 'completed', 29);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (12, 6, 6, '2024-02-08 16:04:24', 'Key factors to consider when evaluating internship offers for career development', 'in progress', 20);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (13, 14, 13, '2024-01-14 00:47:30', 'The importance of mentorship during internships and how to seek guidance', 'completed', 14);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (14, 33, 10, '2024-11-18 09:27:04', 'Tips for applying to multiple internships while keeping track of deadlines and requirements', 'incomplete', 38);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (15, 22, 30, '2024-02-05 06:36:13', 'How to network effectively with potential employers during internship fairs', 'in progress', 32);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (16, 9, 23, '2024-01-20 01:06:42', 'How to network effectively with potential employers during internship fairs', 'incomplete', 40);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (17, 5, 12, '2024-09-22 15:25:45', 'How to craft a compelling cover letter for internship applications', 'completed', 28);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (18, 11, 3, '2024-10-26 05:25:02', 'Transitioning an internship into a full-time position after graduation', 'in progress', 33);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (19, 39, 18, '2024-07-14 01:35:23', 'Professional ways to follow up after an internship interview if you haven''t heard back', 'incomplete', 22);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (20, 22, 21, '2024-02-06 13:06:35', 'Addressing gaps or lack of experience in an internship application', 'incomplete', 12);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (21, 32, 1, '2024-12-01 11:23:48', 'Key factors to consider when evaluating internship offers for career development', 'in progress', 40);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (22, 33, 32, '2024-10-02 12:11:19', 'Best practices for tailoring a resume to appeal to internship coordinators', 'incomplete', 27);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (23, 38, 13, '2024-11-21 05:30:36', 'Remote internship opportunities and managing work-from-home setups', 'in progress', 38);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (24, 20, 14, '2024-06-21 05:26:40', 'Preparing for interviews at competitive tech companies and what employers look for', 'completed', 26);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (25, 32, 3, '2024-06-26 21:18:48', 'Aligning internship opportunities with long-term career goals and personal values', 'completed', 2);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (26, 37, 2, '2024-06-15 10:08:44', 'Professional ways to follow up after an internship interview if you haven''t heard back', 'completed', 10);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (27, 29, 33, '2024-04-19 21:16:31', 'Preparing for interviews at competitive tech companies and what employers look for', 'incomplete', 36);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (28, 21, 3, '2024-03-26 00:50:45', 'Benefits of attending university-sponsored internship workshops and events', 'in progress', 4);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (29, 26, 29, '2024-05-13 00:23:06', 'Exploring internship opportunities that offer flexible work hours or remote options', 'completed', 36);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (30, 7, 21, '2024-07-10 18:31:27', 'Discussing the process of securing internships abroad or with international companies', 'completed', 39);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (31, 6, 7, '2024-06-23 15:37:40', 'Strategies for handling multiple internship offers and making informed decisions', 'in progress', 32);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (32, 38, 17, '2024-09-05 18:13:12', 'How to network effectively with potential employers during internship fairs', 'in progress', 38);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (33, 11, 40, '2024-11-17 17:13:34', 'How to craft a compelling cover letter for internship applications', 'completed', 27);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (34, 31, 5, '2024-10-27 05:20:51', 'Benefits of attending university-sponsored internship workshops and events', 'incomplete', 25);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (35, 1, 37, '2024-07-17 03:39:52', 'The value of academic credit in relation to real-world internship experience', 'in progress', 39);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (36, 31, 27, '2023-12-11 04:32:20', 'Tips for applying to multiple internships while keeping track of deadlines and requirements', 'completed', 20);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (37, 40, 2, '2024-05-11 12:35:59', 'Discussing the process of securing internships abroad or with international companies', 'incomplete', 31);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (38, 13, 11, '2024-10-29 04:30:36', 'How to follow up professionally after submitting an internship application', 'completed', 20);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (39, 30, 11, '2024-04-21 02:06:41', 'Aligning internship opportunities with long-term career goals and personal values', 'completed', 1);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (40, 40, 34, '2024-04-06 11:06:41', 'The industries and companies most likely to hire interns from our university', 'incomplete', 29);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (41, 36, 16, '2024-02-23 05:49:49', 'How to craft a compelling cover letter for internship applications', 'in progress', 4);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (42, 12, 4, '2024-04-22 18:48:21', 'Discussing the process of securing internships abroad or with international companies', 'incomplete', 8);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (43, 26, 24, '2024-01-25 07:10:56', 'How to network effectively with potential employers during internship fairs', 'completed', 4);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (44, 18, 16, '2024-09-12 15:33:10', 'Understanding the negotiation process for internship pay and work hours', 'in progress', 39);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (45, 33, 19, '2024-08-07 06:44:12', 'The value of academic credit in relation to real-world internship experience', 'incomplete', 32);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (46, 17, 36, '2023-12-25 13:03:04', 'Professional ways to follow up after an internship interview if you haven''t heard back', 'in progress', 6);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (47, 34, 30, '2024-03-29 07:24:46', 'How to secure academic credit for internships outside your major', 'in progress', 24);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (48, 37, 15, '2023-12-04 04:28:57', 'Professional ways to follow up after an internship interview if you haven''t heard back', 'in progress', 23);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (49, 30, 13, '2024-05-26 18:43:20', 'How to follow up professionally after submitting an internship application', 'completed', 20);
insert into help_request (request_id, user_id, coordinator_requested, date_submitted, description, status, admin_id) values (50, 15, 18, '2024-11-05 22:59:45', 'Benefits of attending university-sponsored internship workshops and events', 'in progress', 16);

insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (1, 26, 2, 10, 2, 7, 1, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (2, 13, 5, 1, 3, 9, 7, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (3, 29, 25, 1, 1, 5, 5, 3);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (4, 9, 18, 9, 1, 9, 6, 3);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (5, 38, 33, 8, 5, 4, 3, 7);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (6, 20, 20, 4, 4, 7, 1, 1);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (7, 4, 14, 4, 2, 7, 3, 5);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (8, 40, 1, 3, 7, 6, 10, 7);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (9, 27, 33, 7, 8, 6, 8, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (10, 32, 19, 7, 4, 8, 4, 8);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (11, 23, 5, 1, 9, 5, 6, 5);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (12, 21, 31, 2, 10, 5, 8, 9);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (13, 30, 25, 2, 4, 3, 7, 7);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (14, 35, 47, 10, 1, 3, 3, 9);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (15, 11, 36, 3, 6, 8, 2, 5);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (16, 33, 31, 1, 10, 2, 7, 8);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (17, 22, 26, 6, 3, 6, 9, 8);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (18, 19, 18, 3, 7, 4, 10, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (19, 17, 40, 9, 9, 1, 10, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (20, 38, 46, 9, 4, 5, 5, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (21, 33, 43, 5, 4, 7, 7, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (22, 25, 19, 4, 9, 4, 6, 4);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (23, 20, 2, 7, 10, 8, 7, 1);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (24, 34, 40, 3, 6, 3, 8, 8);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (25, 28, 1, 2, 9, 9, 4, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (26, 8, 49, 7, 7, 2, 9, 10);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (27, 5, 2, 10, 10, 3, 10, 10);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (28, 11, 35, 9, 10, 10, 6, 2);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (29, 16, 16, 9, 1, 7, 2, 6);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (30, 24, 13, 9, 1, 5, 3, 4);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (31, 23, 24, 3, 3, 1, 3, 10);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (32, 33, 21, 9, 8, 7, 8, 4);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (33, 14, 32, 3, 4, 4, 4, 3);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (34, 2, 5, 7, 4, 10, 6, 1);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (35, 31, 39, 10, 10, 5, 10, 1);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (36, 40, 15, 3, 7, 3, 2, 4);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (37, 6, 45, 3, 5, 10, 7, 7);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (38, 39, 9, 3, 1, 6, 8, 8);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (39, 24, 2, 8, 7, 6, 7, 8);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (40, 22, 14, 1, 5, 5, 7, 5);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (41, 7, 23, 9, 7, 4, 5, 3);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (42, 9, 31, 9, 8, 7, 4, 1);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (43, 2, 35, 8, 8, 7, 3, 6);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (44, 7, 46, 7, 7, 3, 3, 1);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (45, 23, 40, 3, 10, 10, 9, 3);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (46, 5, 11, 9, 8, 10, 4, 3);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (47, 13, 28, 4, 10, 2, 3, 10);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (48, 18, 39, 1, 6, 1, 10, 9);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (49, 2, 9, 9, 4, 4, 7, 7);
insert into rating (rating_id, user_id, role_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) values (50, 20, 10, 9, 9, 9, 10, 6);

insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (1, 37, 29, 88, 40, 'I gained valuable insights into data analysis but some of the tasks felt like busywork');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (2, 37, 36, 100, 23, 'The mentorship I received was top-notch and helped me build a solid foundation for my career');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (3, 5, 26, 13, 11, 'I would recommend this internship to others especially those interested in tech as it provided lots of learning opportunities');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (4, 5, 2, 56, 55, 'The internship offered a deep dive into industry practices but I would have appreciated more opportunities for innovation');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (5, 39, 25, 58, 30, 'My supervisor was supportive offering constructive criticism that helped me improve my work');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (6, 37, 9, 64, 23, 'The company offered an excellent learning environment but the work was mostly administrative and less technical');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (7, 40, 16, 4, 37, 'The co-op program offered a balanced combination of experience in technical skills and business knowledge');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (8, 1, 24, 72, 61, 'My internship gave me a sense of the work culture at the company and it was a very positive environment');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (9, 27, 8, 38, 79, 'The mentorship I received was top-notch and helped me build a solid foundation for my career');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (10, 12, 22, 96, 74, 'I had the chance to work with a diverse team which expanded my understanding of different work styles');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (11, 28, 31, 89, 59, 'The internship was well-organized and I received continuous feedback to improve my skills');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (12, 3, 17, 92, 99, 'The company offered an excellent learning environment but the work was mostly administrative and less technical');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (13, 4, 20, 50, 38, 'My supervisor was supportive offering constructive criticism that helped me improve my work');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (14, 19, 31, 2, 45, 'The internship was well-organized and I received continuous feedback to improve my skills');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (15, 37, 7, 97, 68, 'The internship program had a great mentorship structure which helped me grow professionally');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (16, 3, 23, 38, 50, 'The internship offered a deep dive into industry practices but I would have appreciated more opportunities for innovation');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (17, 26, 30, 45, 1, 'The internship gave me exposure to both technical and business aspects of the field which was very valuable');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (18, 10, 40, 79, 1, 'My supervisor was supportive offering constructive criticism that helped me improve my work');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (19, 32, 16, 70, 39, 'The internship provided valuable exposure to industry tools and technologies that I had not used before');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (20, 17, 20, 4, 64, 'I had the opportunity to work on high-impact projects and contribute directly to the company’s success');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (21, 34, 34, 95, 27, 'I had the opportunity to work on high-impact projects and contribute directly to the company’s success');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (22, 12, 32, 14, 71, 'I learned a lot from the variety of tasks but some assignments felt disconnected from my career goals');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (23, 35, 6, 46, 62, 'The internship allowed me to network with professionals which has been invaluable for my career');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (24, 20, 31, 41, 68, 'The internship was a great way to build my resume but I was hoping for more real-world problem-solving tasks');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (25, 10, 30, 33, 49, 'My internship gave me a sense of the work culture at the company and it was a very positive environment');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (26, 15, 39, 13, 48, 'My supervisor was supportive offering constructive criticism that helped me improve my work');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (27, 28, 9, 3, 62, 'The co-op program offered a balanced combination of experience in technical skills and business knowledge');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (28, 19, 33, 53, 86, 'The internship allowed me to gain a hands-on understanding of project management which was incredibly useful');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (29, 1, 19, 71, 48, 'I gained valuable insights into data analysis but some of the tasks felt like busywork');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (30, 34, 34, 76, 18, 'My internship gave me a sense of the work culture at the company and it was a very positive environment');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (31, 3, 33, 6, 59, 'I appreciated the work-life balance and flexibility offered during the internship');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (32, 24, 29, 83, 86, 'I was able to apply my coding skills in real-world projects but the pace was a bit overwhelming at times');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (33, 1, 22, 89, 100, 'The co-op program provided real-world business experience that was instrumental in shaping my career');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (34, 40, 23, 76, 86, 'The internship was well-organized and I received continuous feedback to improve my skills');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (35, 15, 25, 44, 48, 'The projects I worked on had a significant impact making the experience very rewarding');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (36, 28, 37, 37, 62, 'I had a fantastic experience and would love to return to the company in the future');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (37, 35, 37, 34, 90, 'The internship allowed me to gain a hands-on understanding of project management which was incredibly useful');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (38, 4, 6, 87, 62, 'I learned more about networking and communication skills during my time at the internship');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (39, 18, 22, 86, 10, 'The internship provided hands-on experience that allowed me to apply classroom knowledge in real-world scenarios');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (40, 21, 30, 18, 21, 'I had the chance to work with a diverse team which expanded my understanding of different work styles');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (41, 15, 3, 84, 81, 'The internship was a great introduction to the corporate world but I wish I had more complex assignments');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (42, 22, 29, 22, 34, 'The internship was well-organized and I received continuous feedback to improve my skills');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (43, 34, 22, 90, 38, 'The team was welcoming and I gained valuable insights into the tech industry through challenging tasks');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (44, 6, 40, 41, 88, 'I gained valuable insights into data analysis but some of the tasks felt like busywork');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (45, 2, 19, 49, 2, 'The internship provided hands-on experience that allowed me to apply classroom knowledge in real-world scenarios');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (46, 10, 26, 60, 25, 'The projects I worked on had a significant impact making the experience very rewarding');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (47, 16, 10, 94, 71, 'The internship was a great introduction to the corporate world but I wish I had more complex assignments');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (48, 34, 1, 81, 34, 'The internship allowed me to gain a hands-on understanding of project management which was incredibly useful');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (49, 15, 8, 85, 67, 'The management team was always available for guidance which made a huge difference in my development');
insert into review (review_id, user_id, role_id, num_up_votes, num_down_votes, comment) values (50, 4, 26, 76, 14, 'The internship was well-organized and I received continuous feedback to improve my skills');

insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (1, 31, 10, '2024-02-08 19:37:52', 'Behavioral interview preparation');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (2, 34, 36, '2024-07-31 02:33:33', 'Learning version control with Git');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (3, 1, 6, '2024-06-12 03:24:57', 'Time management for internships');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (4, 35, 24, '2024-09-23 18:23:06', 'Understanding data structures');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (5, 40, 18, '2024-11-15 16:28:57', 'Mobile app development');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (6, 11, 40, '2024-11-22 18:45:33', 'Building a GitHub portfolio');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (7, 21, 12, '2023-12-17 05:18:16', 'Problem-solving in coding');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (8, 34, 28, '2024-01-31 14:02:16', 'Creating a standout LinkedIn profile');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (9, 19, 38, '2024-01-05 18:24:22', 'Algorithm optimization');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (10, 12, 18, '2024-10-09 11:00:53', 'UI/UX design principles');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (11, 26, 27, '2024-09-17 23:01:31', 'Pair programming');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (12, 35, 28, '2024-11-11 17:59:30', 'Debugging techniques');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (13, 28, 33, '2024-09-22 19:13:20', 'Creating a standout LinkedIn profile');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (14, 40, 14, '2024-09-02 21:31:57', 'Understanding system design');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (15, 16, 2, '2024-01-16 12:20:49', 'UI/UX design principles');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (16, 20, 39, '2024-07-03 20:14:57', 'UI/UX design principles');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (17, 26, 20, '2023-12-15 09:02:30', 'Networking strategies');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (18, 33, 37, '2024-10-29 10:04:15', 'Test-driven development');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (19, 5, 4, '2024-10-16 10:40:26', 'Debugging techniques');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (20, 25, 27, '2024-01-19 21:43:57', 'Concurrency in programming');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (21, 27, 28, '2024-01-02 14:05:05', 'Understanding data structures');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (22, 12, 13, '2024-11-04 10:38:52', 'Conquering imposter syndrome');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (23, 12, 14, '2024-07-03 11:07:34', 'Creating a standout LinkedIn profile');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (24, 24, 28, '2024-01-31 04:25:52', 'Algorithm optimization');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (25, 34, 37, '2024-10-10 13:57:34', 'Java practice');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (26, 8, 12, '2024-02-15 08:27:55', 'Mobile app development');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (27, 12, 17, '2023-12-25 12:21:29', 'Mock interview');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (28, 37, 40, '2024-06-03 07:43:16', 'Preparing for tech company assessments');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (29, 11, 5, '2024-06-16 23:31:25', 'UI/UX design principles');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (30, 17, 6, '2024-01-13 09:41:04', 'Resume review');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (31, 38, 31, '2024-10-31 16:25:44', 'Learning version control with Git');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (32, 27, 15, '2023-12-20 02:40:38', 'Pair programming');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (33, 14, 9, '2024-02-27 16:53:13', 'Understanding data structures');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (34, 13, 37, '2024-07-30 20:47:07', 'Mock interview');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (35, 39, 36, '2024-11-13 06:12:33', 'Creating a standout LinkedIn profile');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (36, 30, 21, '2024-09-05 08:15:18', 'Conquering imposter syndrome');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (37, 9, 17, '2024-08-03 02:32:31', 'Algorithm optimization');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (38, 4, 16, '2024-06-07 05:57:14', 'Ethical hacking practices');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (39, 20, 31, '2023-12-21 09:19:55', 'Cloud computing basics');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (40, 19, 36, '2024-09-22 08:10:51', 'Preparing for tech company assessments');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (41, 21, 20, '2024-05-24 06:37:02', 'Mock interview');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (42, 29, 33, '2024-07-30 22:12:18', 'Working with APIs');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (43, 36, 30, '2024-01-14 12:35:38', 'Understanding data structures');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (44, 9, 24, '2024-11-21 16:43:39', 'Pair programming');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (45, 11, 12, '2024-05-01 20:14:11', 'Continuous learning in tech');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (46, 3, 18, '2024-09-30 02:16:04', 'Mobile app development');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (47, 7, 12, '2024-01-14 20:56:47', 'Code review best practices');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (48, 35, 20, '2024-10-26 18:56:56', 'Test-driven development');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (49, 7, 15, '2024-03-24 09:32:30', 'Preparing for tech company assessments');
insert into peer_interaction (interaction_id, user_id, peer_user_id, date_time, topic) values (50, 8, 12, '2024-04-12 23:55:30', 'Agile methodology');

insert into friendship (user_id, friend_id) values (12, 7);
insert into friendship (user_id, friend_id) values (32, 39);
insert into friendship (user_id, friend_id) values (40, 30);
insert into friendship (user_id, friend_id) values (36, 13);
insert into friendship (user_id, friend_id) values (19, 5);
insert into friendship (user_id, friend_id) values (3, 6);
insert into friendship (user_id, friend_id) values (26, 31);
insert into friendship (user_id, friend_id) values (14, 34);
insert into friendship (user_id, friend_id) values (20, 40);
insert into friendship (user_id, friend_id) values (27, 10);
insert into friendship (user_id, friend_id) values (30, 3);
insert into friendship (user_id, friend_id) values (23, 26);
insert into friendship (user_id, friend_id) values (10, 23);
insert into friendship (user_id, friend_id) values (4, 33);
insert into friendship (user_id, friend_id) values (14, 15);
insert into friendship (user_id, friend_id) values (16, 6);
insert into friendship (user_id, friend_id) values (20, 16);
insert into friendship (user_id, friend_id) values (13, 9);
insert into friendship (user_id, friend_id) values (10, 39);
insert into friendship (user_id, friend_id) values (27, 19);
insert into friendship (user_id, friend_id) values (2, 21);
insert into friendship (user_id, friend_id) values (1, 24);
insert into friendship (user_id, friend_id) values (3, 35);
insert into friendship (user_id, friend_id) values (23, 15);
insert into friendship (user_id, friend_id) values (5, 4);
insert into friendship (user_id, friend_id) values (36, 1);
insert into friendship (user_id, friend_id) values (20, 27);
insert into friendship (user_id, friend_id) values (28, 33);
insert into friendship (user_id, friend_id) values (1, 3);
insert into friendship (user_id, friend_id) values (7, 18);
insert into friendship (user_id, friend_id) values (32, 30);
insert into friendship (user_id, friend_id) values (39, 28);
insert into friendship (user_id, friend_id) values (19, 28);
insert into friendship (user_id, friend_id) values (32, 2);
insert into friendship (user_id, friend_id) values (20, 20);
insert into friendship (user_id, friend_id) values (36, 15);
insert into friendship (user_id, friend_id) values (11, 17);
insert into friendship (user_id, friend_id) values (10, 29);
insert into friendship (user_id, friend_id) values (37, 20);
insert into friendship (user_id, friend_id) values (29, 10);
insert into friendship (user_id, friend_id) values (35, 20);
insert into friendship (user_id, friend_id) values (22, 5);
insert into friendship (user_id, friend_id) values (8, 15);
insert into friendship (user_id, friend_id) values (37, 31);
insert into friendship (user_id, friend_id) values (12, 23);
insert into friendship (user_id, friend_id) values (25, 10);
insert into friendship (user_id, friend_id) values (31, 19);
insert into friendship (user_id, friend_id) values (12, 36);
insert into friendship (user_id, friend_id) values (29, 20);
insert into friendship (user_id, friend_id) values (28, 12);
insert into friendship (user_id, friend_id) values (36, 22);
insert into friendship (user_id, friend_id) values (31, 25);
insert into friendship (user_id, friend_id) values (38, 39);
insert into friendship (user_id, friend_id) values (4, 17);
insert into friendship (user_id, friend_id) values (3, 37);
insert into friendship (user_id, friend_id) values (35, 6);
insert into friendship (user_id, friend_id) values (2, 14);
insert into friendship (user_id, friend_id) values (9, 14);
insert into friendship (user_id, friend_id) values (3, 40);
insert into friendship (user_id, friend_id) values (20, 29);
insert into friendship (user_id, friend_id) values (9, 30);
insert into friendship (user_id, friend_id) values (2, 37);
insert into friendship (user_id, friend_id) values (25, 29);
insert into friendship (user_id, friend_id) values (30, 28);
insert into friendship (user_id, friend_id) values (30, 12);
insert into friendship (user_id, friend_id) values (33, 30);
insert into friendship (user_id, friend_id) values (32, 12);
insert into friendship (user_id, friend_id) values (21, 28);
insert into friendship (user_id, friend_id) values (18, 40);
insert into friendship (user_id, friend_id) values (1, 32);
insert into friendship (user_id, friend_id) values (32, 31);
insert into friendship (user_id, friend_id) values (4, 40);
insert into friendship (user_id, friend_id) values (30, 21);
insert into friendship (user_id, friend_id) values (31, 16);
insert into friendship (user_id, friend_id) values (17, 15);
insert into friendship (user_id, friend_id) values (10, 20);
insert into friendship (user_id, friend_id) values (28, 38);
insert into friendship (user_id, friend_id) values (23, 6);
insert into friendship (user_id, friend_id) values (38, 30);
insert into friendship (user_id, friend_id) values (10, 1);
insert into friendship (user_id, friend_id) values (24, 4);
insert into friendship (user_id, friend_id) values (13, 38);
insert into friendship (user_id, friend_id) values (27, 12);
insert into friendship (user_id, friend_id) values (7, 29);
insert into friendship (user_id, friend_id) values (23, 9);
insert into friendship (user_id, friend_id) values (27, 29);
insert into friendship (user_id, friend_id) values (37, 38);
insert into friendship (user_id, friend_id) values (17, 1);
insert into friendship (user_id, friend_id) values (33, 22);
insert into friendship (user_id, friend_id) values (34, 40);
insert into friendship (user_id, friend_id) values (29, 40);
insert into friendship (user_id, friend_id) values (14, 17);
insert into friendship (user_id, friend_id) values (17, 40);
insert into friendship (user_id, friend_id) values (2, 25);
insert into friendship (user_id, friend_id) values (22, 4);
insert into friendship (user_id, friend_id) values (23, 28);
insert into friendship (user_id, friend_id) values (11, 19);
insert into friendship (user_id, friend_id) values (18, 26);
insert into friendship (user_id, friend_id) values (24, 31);
insert into friendship (user_id, friend_id) values (8, 12);

insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (1, 22, 40, 27, 'I was able to apply theoretical knowledge to practical situations which enhanced my learning');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (2, 12, 24, null, 'My advisor provided excellent mentorship and helped me set achievable career goals');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (3, 27, 6, 2, 'My advisor encouraged me to take ownership of my projects and responsibilities');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (4, 24, null, 14, 'My advisor provided excellent mentorship and helped me set achievable career goals');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (5, 6, 13, 31, 'I learned how to use version control tools like Git in a real-world project');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (6, 23, null, 11, 'I was able to work on projects that aligned with my long-term career goals');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (7, 33, 9, null, 'I was able to improve my time management skills by handling multiple tasks');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (8, 17, 13, 25, 'I was able to imThe internship provided valuable hands-on experience in a real-world setting');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (9, 28, 6, null, 'The advisor’s guidance helped me improve my communication skills in a professional setting');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (10, 22, 20, 9, 'The internship helped me refine my problem-solving and critical thinking skills');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (11, 27, 8, null, 'The internship taught me how to navigate challenges in a professional environment');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (12, 38, 40, null, 'I had the chance to participate in team meetings and contribute ideas');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (13, 18, 12, null, 'The advisor’s guidance helped me improve my communication skills in a professional setting');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (14, 30, 34, null, 'The internship helped me build a strong professional network within the industry');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (15, 12, 31, null, 'The advisor provided constructive feedback that helped me improve my performance');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (16, 8, 7, null, 'I learned how to use version control tools like Git in a real-world project');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (17, 29, 31, 29, 'My advisor encouraged me to take ownership of my projects and responsibilities');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (18, 28, 38, null, 'The advisor helped me navigate office politics and professional relationships');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (19, 31, 14, 19, 'I learned how to use version control tools like Git in a real-world project');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (20, 27, 15, null, 'The advisor was very supportive and provided useful feedback on my progress');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (21, 20, 26, 29, 'The advisor provided constructive feedback that helped me improve my performance');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (22, 26, 7, null, 'The advisor was very supportive and provided useful feedback on my progress');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (23, 3, null, 7, 'I learned the importance of documentation in software development');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (24, 23, 9, null, 'The advisor was very supportive and provided useful feedback on my progress');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (25, 11, 8, null, 'The advisor helped me stay focused and motivated through challenging tasks');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (26, 19, 18, null, 'My advisor encouraged me to take ownership of my projects and responsibilities');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (27, 26, 26, null, 'My advisor encouraged me to take ownership of my projects and responsibilities');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (28, 34, 33, null, 'I was able to apply theoretical knowledge to practical situations which enhanced my learning');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (29, 20, 7, null, 'The advisor helped me stay focused and motivated through challenging tasks');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (30, 24, 34, 27, 'I gained exposure to new technologies that I hadn''t worked with before');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (31, 21, 24, 22, 'I gained exposure to new technologies that I hadn''t worked with before');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (32, 11, 14, 39, 'The internship provided me with a clearer understanding of my career direction');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (33, 38, 2, null, 'The advisor was very supportive and provided useful feedback on my progress');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (34, 20, null, 2, 'The internship helped me refine my problem-solving and critical thinking skills');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (35, 22, 21, 39, 'I was able to improve my time management skills by handling multiple tasks');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (36, 32, null, null, 'My advisor encouraged me to take ownership of my projects and responsibilities');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (37, 30, 11, 24, 'The internship provided valuable hands-on experience in a real-world setting');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (38, 22, 11, 10, 'I learned the importance of documentation in software development');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (39, 31, null, 29, 'I learned how to use version control tools like Git in a real-world project');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (40, 7, 7, null, 'I received helpful advice on how to tailor my resume and LinkedIn profile for the industry');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (41, 17, 34, 4, 'The advisor helped me navigate office politics and professional relationships');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (42, 31, 23, 21, 'I gained exposure to new technologies that I hadn''t worked with before');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (43, 29, 27, null, 'My advisor provided excellent mentorship and helped me set achievable career goals');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (44, 21, 6, 21, 'I learned the significance of collaboration and knowledge-sharing within teams');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (45, 8, 18, null, 'I gained exposure to new technologies that I hadn''t worked with before');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (46, 27, 30, 37, 'I learned how to handle constructive criticism in a positive and professional manner');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (47, 33, 28, null, 'I gained exposure to new technologies that I hadn''t worked with before');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (48, 1, 21, 30, 'I was able to apply theoretical knowledge to practical situations which enhanced my learning');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (49, 17, 29, null, 'I had the opportunity to present my work to senior leaders and gain valuable feedback');
insert into notes (note_id, user_id, employer_id, coordinator_id, note_text) values (50, 18, 9, null, 'The internship provided valuable hands-on experience in a real-world setting');

insert into user_role (user_id, role_id) values (37, 36);
insert into user_role (user_id, role_id) values (5, 24);
insert into user_role (user_id, role_id) values (30, 9);
insert into user_role (user_id, role_id) values (5, 4);
insert into user_role (user_id, role_id) values (17, 21);
insert into user_role (user_id, role_id) values (26, 29);
insert into user_role (user_id, role_id) values (31, 32);
insert into user_role (user_id, role_id) values (37, 16);
insert into user_role (user_id, role_id) values (37, 3);
insert into user_role (user_id, role_id) values (6, 32);
insert into user_role (user_id, role_id) values (31, 26);
insert into user_role (user_id, role_id) values (12, 26);
insert into user_role (user_id, role_id) values (34, 47);
insert into user_role (user_id, role_id) values (28, 30);
insert into user_role (user_id, role_id) values (20, 42);
insert into user_role (user_id, role_id) values (36, 48);
insert into user_role (user_id, role_id) values (25, 15);
insert into user_role (user_id, role_id) values (7, 25);
insert into user_role (user_id, role_id) values (31, 35);
insert into user_role (user_id, role_id) values (8, 38);
insert into user_role (user_id, role_id) values (7, 35);
insert into user_role (user_id, role_id) values (14, 28);
insert into user_role (user_id, role_id) values (19, 21);
insert into user_role (user_id, role_id) values (9, 33);
insert into user_role (user_id, role_id) values (9, 8);
insert into user_role (user_id, role_id) values (16, 45);
insert into user_role (user_id, role_id) values (6, 11);
insert into user_role (user_id, role_id) values (28, 4);
insert into user_role (user_id, role_id) values (31, 38);
insert into user_role (user_id, role_id) values (34, 46);
insert into user_role (user_id, role_id) values (27, 43);
insert into user_role (user_id, role_id) values (13, 47);
insert into user_role (user_id, role_id) values (30, 36);
insert into user_role (user_id, role_id) values (38, 45);
insert into user_role (user_id, role_id) values (40, 50);
insert into user_role (user_id, role_id) values (40, 8);
insert into user_role (user_id, role_id) values (16, 27);
insert into user_role (user_id, role_id) values (25, 4);
insert into user_role (user_id, role_id) values (35, 11);
insert into user_role (user_id, role_id) values (34, 39);
insert into user_role (user_id, role_id) values (20, 13);
insert into user_role (user_id, role_id) values (14, 3);
insert into user_role (user_id, role_id) values (39, 37);
insert into user_role (user_id, role_id) values (4, 2);
insert into user_role (user_id, role_id) values (39, 2);
insert into user_role (user_id, role_id) values (21, 4);
insert into user_role (user_id, role_id) values (12, 8);
insert into user_role (user_id, role_id) values (22, 6);
insert into user_role (user_id, role_id) values (19, 30);
insert into user_role (user_id, role_id) values (15, 15);
insert into user_role (user_id, role_id) values (28, 10);
insert into user_role (user_id, role_id) values (10, 16);
insert into user_role (user_id, role_id) values (24, 37);
insert into user_role (user_id, role_id) values (8, 48);
insert into user_role (user_id, role_id) values (2, 37);
insert into user_role (user_id, role_id) values (29, 20);
insert into user_role (user_id, role_id) values (21, 49);
insert into user_role (user_id, role_id) values (23, 9);
insert into user_role (user_id, role_id) values (15, 8);
insert into user_role (user_id, role_id) values (15, 10);
insert into user_role (user_id, role_id) values (16, 50);
insert into user_role (user_id, role_id) values (25, 19);
insert into user_role (user_id, role_id) values (33, 26);
insert into user_role (user_id, role_id) values (24, 41);
insert into user_role (user_id, role_id) values (11, 6);
insert into user_role (user_id, role_id) values (15, 3);
insert into user_role (user_id, role_id) values (22, 35);
insert into user_role (user_id, role_id) values (23, 42);
insert into user_role (user_id, role_id) values (40, 27);
insert into user_role (user_id, role_id) values (17, 41);
insert into user_role (user_id, role_id) values (6, 49);
insert into user_role (user_id, role_id) values (3, 24);
insert into user_role (user_id, role_id) values (24, 12);
insert into user_role (user_id, role_id) values (32, 20);
insert into user_role (user_id, role_id) values (22, 36);
insert into user_role (user_id, role_id) values (13, 14);
insert into user_role (user_id, role_id) values (2, 12);
insert into user_role (user_id, role_id) values (4, 3);
insert into user_role (user_id, role_id) values (31, 30);
insert into user_role (user_id, role_id) values (39, 11);
insert into user_role (user_id, role_id) values (22, 18);
insert into user_role (user_id, role_id) values (32, 18);
insert into user_role (user_id, role_id) values (36, 1);
insert into user_role (user_id, role_id) values (25, 18);
insert into user_role (user_id, role_id) values (18, 16);
insert into user_role (user_id, role_id) values (10, 7);
insert into user_role (user_id, role_id) values (16, 23);
insert into user_role (user_id, role_id) values (5, 31);
insert into user_role (user_id, role_id) values (10, 29);
insert into user_role (user_id, role_id) values (16, 7);
insert into user_role (user_id, role_id) values (17, 1);
insert into user_role (user_id, role_id) values (27, 14);
insert into user_role (user_id, role_id) values (20, 19);
insert into user_role (user_id, role_id) values (9, 34);
insert into user_role (user_id, role_id) values (16, 20);
insert into user_role (user_id, role_id) values (24, 2);
insert into user_role (user_id, role_id) values (29, 47);
insert into user_role (user_id, role_id) values (4, 50);
insert into user_role (user_id, role_id) values (28, 18);
insert into user_role (user_id, role_id) values (11, 1);
