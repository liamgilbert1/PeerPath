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
    industry varchar(75) not null,
    coop_title varchar(128)
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

CREATE TABLE IF NOT EXISTS user_resource (
    user_id int,
    resource_id int,
    PRIMARY KEY (user_id, resource_id),
    CONSTRAINT fk_user_id_resource
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_resource_id_user
        FOREIGN KEY (resource_id) REFERENCES  resource (resource_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS hourly_activity (
    activity_id int primary key auto_increment,
    user_id int not null,
    admin_id int not null,
    date_time datetime not null default current_timestamp,
    min_per_hr_online int unsigned not null,
    pages_visited int unsigned not null,
    CONSTRAINT fk_activity_user
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_activity_admin
        FOREIGN KEY (admin_id) REFERENCES  system_admin (admin_id)
            ON UPDATE cascade ON DELETE restrict
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

CREATE TABLE IF NOT EXISTS review (
    review_id int primary key auto_increment,
    user_id int not null,
    employer_id int not null,
    coordinator_access int not null,
    admin int not null,
    num_up_votes int unsigned default 0,
    num_down_votes int unsigned default 0,
    rating int,
    comment varchar(1000),
    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id) REFERENCES  user (user_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_review_employer
        FOREIGN KEY (employer_id) REFERENCES  employer (employer_id)
            ON UPDATE cascade ON DELETE cascade,
    CONSTRAINT fk_review_admin
        FOREIGN KEY (admin) REFERENCES  system_admin (admin_id)
            ON UPDATE cascade ON DELETE restrict,
    CONSTRAINT fk_review_coordinator
        FOREIGN KEY (coordinator_access) REFERENCES  coordinator (coordinator_id)
            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE IF NOT EXISTS rating (
    rating_id int primary key auto_increment,
    review_id int not null,
    future_job_score int unsigned not null,
    work_quality_score int unsigned not null,
    manager_score int unsigned not null,
    salary_score int unsigned not null,
    lifestyle_score int unsigned not null,
    CONSTRAINT fk_review_rating
        FOREIGN KEY (rating_id) REFERENCES  review (review_id)
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

ALTER TABLE review
ADD CONSTRAINT fk_rating_review
         FOREIGN KEY (rating) REFERENCES rating (rating_id)
             ON UPDATE cascade ON DELETE restrict;

SHOW TABLES;


INSERT INTO system_admin (first_name, last_name, username, email, phone_number) VALUES
     ('Jake', 'Bernhard','jakebern', 'jake@gmail.com', '123-456-7890'),
     ('Liam', 'Gilbert','liam360', 'liam@aol.com', '234-678-1234'),
     ('Caroline', 'Monaco','cmonaco', 'caro@northeastern.edu', '111-555-7890');

INSERT INTO system_alert (user_id, title, description, receivers) VALUES
    (1, 'ALERT ALERT', 'first alert', 'students'),
    (3, 'test all coordinators', 'second alert', 'coordinators'),
    (2, 'ALERT FINAL', 'last alert', 'all');


INSERT INTO resource (title, description, link) VALUES
    ('Fundies text book', 'first resource', 'link.com'),
    ('java docs', 'second resource', 'java.com'),
    ('python docs', 'third resource', 'python.org');

INSERT INTO employer (name, location, industry, coop_title) VALUES
    ('State Street', 'Boston', 'Finance', 'Business'),
    ('Apple', 'Remote', 'Technology', 'Computer Science'),
    ('Mass General', 'Boston', 'Medical', 'Health Sciences');


INSERT INTO coordinator (admin_id, first_name, last_name, email, content, satisfaction_score, activity_status) VALUES
    (2, 'Joseph', 'Calrucci', 'Jcal3@aol.com', 'Current coordinator',
     10, 'online'),
    (1, 'Grayson', 'Bunting', 'gbunting@gmail.com', 'Current coordinator',
     9, 'offline');

INSERT INTO user (first_name, last_name, username, email, student_type, coordinator, admin,
                  activity_status, urgency_status, search_status, user_permissions) VALUES
    ('Owen', 'Curtis', 'OCurtis5', 'OCurtis5@yahoo.com', '4th year',
     2, 1, 'online', 'needs help', 'looking for co-op',
     'classic' ),
    ('Ethan', 'Walker', 'Ebot', 'ebot3@gmail.com', '3rd year',
     2, 3, 'offline', 'none', 'found co-op',
     'advanced' ),
    ('Frank', 'Issacson', 'frank04', 'franky@yahoo.com', '1st year',
     1, 2, 'online', 'needs help', 'not looking for co-op',
     'classic' );

INSERT INTO user_resource (user_id, resource_id) VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (3,1),
    (3,2);


INSERT INTO hourly_activity (user_id, admin_id, min_per_hr_online, pages_visited) VALUES
    (2, 1, 45, 3),
    (1, 3, 20, 1),
    (2,2, 60, 32);

INSERT INTO help_request (user_id, coordinator_requested, description, status, admin_id) VALUES
    (3, 2, 'help with resume', 'unresolved', 1),
    (2, 1, 'help with job search', 'unresolved', 3),
    (1, 2, 'help with resume', 'resolved', 3);

INSERT INTO review (user_id, employer_id, coordinator_access, admin, comment) VALUES
            (1, 2, 2, 1, 'good time'),
            (2, 1, 1, 3, 'really hard'),
            (3, 3, 1, 2, 'fun co-op');

INSERT INTO rating (review_id, future_job_score, work_quality_score, manager_score, salary_score, lifestyle_score) VALUES
        (1, 5,5,5,5,5),
        (2, 3,2,4,5,2),
        (3, 5, 4,5,4,5);

UPDATE review SET rating = 1 WHERE rating is NULL;

INSERT INTO peer_interaction (user_id, peer_user_id, topic) VALUES
        (1, 2, 'resumes'),
        (2, 3, 'technical interview prep'),
        (3, 1, 'mock interview');



