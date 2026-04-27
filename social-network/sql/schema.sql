-- =============================================================================
-- Схема БД «Социальная сеть» (PostgreSQL)
-- =============================================================================
DROP TABLE IF EXISTS MessageReadStatus CASCADE;
DROP TABLE IF EXISTS Messages CASCADE;
DROP TABLE IF EXISTS MediaFiles CASCADE;
DROP TABLE IF EXISTS Likes CASCADE;
DROP TABLE IF EXISTS Comments CASCADE;
DROP TABLE IF EXISTS Posts CASCADE;
DROP TABLE IF EXISTS CommunityMembers CASCADE;
DROP TABLE IF EXISTS Communities CASCADE;
DROP TABLE IF EXISTS Friends CASCADE;
DROP TABLE IF EXISTS FriendshipStatus CASCADE;
DROP TABLE IF EXISTS UserStatus CASCADE;
DROP TABLE IF EXISTS UserInterests CASCADE;
DROP TABLE IF EXISTS Interests CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Settlements CASCADE;
DROP TABLE IF EXISTS SettlementTypes CASCADE;
DROP TABLE IF EXISTS Countries CASCADE;


CREATE TABLE Countries (
    country_id SERIAL,
    country_name TEXT NOT NULL
);

ALTER TABLE Countries 
ADD CONSTRAINT PK_Countries PRIMARY KEY (country_id);

ALTER TABLE Countries 
ADD CONSTRAINT U_Countries_country_name UNIQUE (country_name);

CREATE TABLE SettlementTypes (
    settlement_type_id SERIAL,
    settlement_type_name TEXT NOT NULL
);

ALTER TABLE SettlementTypes 
ADD CONSTRAINT PK_SettlementTypes PRIMARY KEY (settlement_type_id);

ALTER TABLE SettlementTypes 
ADD CONSTRAINT U_SettlementTypes_settlement_type_name UNIQUE (settlement_type_name);

CREATE TABLE Settlements (
    settlement_id SERIAL,
    settlement_name TEXT NOT NULL,
    country_id INT NOT NULL,
    settlement_type_id INT NOT NULL
);

ALTER TABLE Settlements 
ADD CONSTRAINT PK_Settlements PRIMARY KEY (settlement_id);

CREATE TABLE Users (
    user_id SERIAL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    middle_name TEXT,
    date_of_birth DATE NOT NULL,
    place_of_residence TEXT,
    place_of_work TEXT,
    phone TEXT,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    settlement_id INT NOT NULL
);

ALTER TABLE Users 
ADD CONSTRAINT PK_Users PRIMARY KEY (user_id);

ALTER TABLE Users 
ADD CONSTRAINT U_Users_email UNIQUE (email);

ALTER TABLE Users 
ADD CONSTRAINT U_Users_phone UNIQUE (phone);

ALTER TABLE Users 
ADD CONSTRAINT U_Users_password UNIQUE (password);

CREATE TABLE Interests (
    interest_id SERIAL,
    interest_name TEXT NOT NULL,
    interest_description TEXT
);

ALTER TABLE Interests 
ADD CONSTRAINT PK_Interests PRIMARY KEY (interest_id);

ALTER TABLE Interests 
ADD CONSTRAINT U_Interests_interest_name UNIQUE (interest_name);

CREATE TABLE UserInterests (
    user_id INT NOT NULL,
    interest_id INT NOT NULL,
    additional_info TEXT
);

ALTER TABLE UserInterests 
ADD CONSTRAINT PK_UserInterests PRIMARY KEY (user_id, interest_id);

CREATE TABLE UserStatus (
    status_id SERIAL,
    status_name TEXT NOT NULL
);

ALTER TABLE UserStatus 
ADD CONSTRAINT PK_UserStatus PRIMARY KEY (status_id);

ALTER TABLE UserStatus 
ADD CONSTRAINT U_UserStatus_status_name UNIQUE (status_name);

CREATE TABLE FriendshipStatus (
    friendship_status_id SERIAL,
    friendship_status_name TEXT NOT NULL
);

ALTER TABLE FriendshipStatus 
ADD CONSTRAINT PK_FriendshipStatus PRIMARY KEY (friendship_status_id);

ALTER TABLE FriendshipStatus 
ADD CONSTRAINT U_FriendshipStatus_friendship_status_name UNIQUE (friendship_status_name);

CREATE TABLE Friends (
    user_id1 INT NOT NULL,
    user_id2 INT NOT NULL,
    friendship_date DATE NOT NULL
);

ALTER TABLE Friends 
ADD CONSTRAINT PK_Friends PRIMARY KEY (user_id1, user_id2);

ALTER TABLE Friends 
ADD CONSTRAINT CH_Friends_different_users CHECK (user_id1 <> user_id2);

CREATE TABLE Communities (
    community_id SERIAL,
    community_name TEXT NOT NULL,
    creator_user_id INT NOT NULL,
    description TEXT,
    organizers_info TEXT,
    posts_info TEXT
);

ALTER TABLE Communities 
ADD CONSTRAINT PK_Communities PRIMARY KEY (community_id);

ALTER TABLE Communities 
ADD CONSTRAINT U_Communities_community_name UNIQUE (community_name);

CREATE TABLE CommunityMembers (
    user_id INT NOT NULL,
    community_id INT NOT NULL,
    join_date DATE NOT NULL
);

ALTER TABLE CommunityMembers 
ADD CONSTRAINT PK_CommunityMembers PRIMARY KEY (user_id, community_id);

CREATE TABLE Posts (
    post_id SERIAL,
    user_id INT NOT NULL,
    community_id INT NOT NULL,
    post_text TEXT NOT NULL,
    post_date DATE NOT NULL
);

ALTER TABLE Posts 
ADD CONSTRAINT PK_Posts PRIMARY KEY (post_id);

CREATE TABLE MediaFiles (
    media_file_id SERIAL,
    media_file_url TEXT NOT NULL
);

ALTER TABLE MediaFiles 
ADD CONSTRAINT PK_MediaFiles PRIMARY KEY (media_file_id);

ALTER TABLE MediaFiles 
ADD CONSTRAINT U_MediaFiles_media_file_url UNIQUE (media_file_url);

CREATE TABLE Comments (
    comment_id SERIAL,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    media_file_id INT,
    comment_text TEXT NOT NULL,
    comment_date DATE NOT NULL,
    parent_comment_id INT
);

ALTER TABLE Comments 
ADD CONSTRAINT PK_Comments PRIMARY KEY (comment_id);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    like_date DATE NOT NULL
);

ALTER TABLE Likes 
ADD CONSTRAINT PK_Likes PRIMARY KEY (user_id, post_id);

CREATE TABLE MessageReadStatus (
    read_status_id SERIAL,
    read_status_description TEXT NOT NULL
);

ALTER TABLE MessageReadStatus 
ADD CONSTRAINT PK_MessageReadStatus PRIMARY KEY (read_status_id);

ALTER TABLE MessageReadStatus 
ADD CONSTRAINT U_MessageReadStatus_read_status_description UNIQUE (read_status_description);

CREATE TABLE Messages (
    message_id SERIAL,
    user_id INT NOT NULL,
    message_text TEXT NOT NULL,
    send_date DATE NOT NULL,
    media_file_id INT
);
ALTER TABLE Messages ADD COLUMN receiver_id INT;


ALTER TABLE Messages 
ADD CONSTRAINT PK_Messages PRIMARY KEY (message_id);

ALTER TABLE Settlements 
ADD CONSTRAINT FK_Settlements_Countries FOREIGN KEY (country_id) REFERENCES Countries(country_id);

ALTER TABLE Settlements 
ADD CONSTRAINT FK_Settlements_SettlementTypes FOREIGN KEY (settlement_type_id) REFERENCES SettlementTypes(settlement_type_id);

ALTER TABLE Users 
ADD CONSTRAINT FK_Users_Settlements FOREIGN KEY (settlement_id) REFERENCES Settlements(settlement_id);

ALTER TABLE UserInterests 
ADD CONSTRAINT FK_UserInterests_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE UserInterests 
ADD CONSTRAINT FK_UserInterests_Interests FOREIGN KEY (interest_id) REFERENCES Interests(interest_id);

ALTER TABLE Friends 
ADD CONSTRAINT FK_Friends_Users1 FOREIGN KEY (user_id1) REFERENCES Users(user_id);

ALTER TABLE Friends 
ADD CONSTRAINT FK_Friends_Users2 FOREIGN KEY (user_id2) REFERENCES Users(user_id);

ALTER TABLE Communities 
ADD CONSTRAINT FK_Communities_Users FOREIGN KEY (creator_user_id) REFERENCES Users(user_id);

ALTER TABLE CommunityMembers 
ADD CONSTRAINT FK_CommunityMembers_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE CommunityMembers 
ADD CONSTRAINT FK_CommunityMembers_Communities FOREIGN KEY (community_id) REFERENCES Communities(community_id);

ALTER TABLE Posts 
ADD CONSTRAINT FK_Posts_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Posts 
ADD CONSTRAINT FK_Posts_Communities FOREIGN KEY (community_id) REFERENCES Communities(community_id);

ALTER TABLE Comments 
ADD CONSTRAINT FK_Comments_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Comments 
ADD CONSTRAINT FK_Comments_Posts FOREIGN KEY (post_id) REFERENCES Posts(post_id);

ALTER TABLE Comments 
ADD CONSTRAINT FK_Comments_MediaFiles FOREIGN KEY (media_file_id) REFERENCES MediaFiles(media_file_id);

ALTER TABLE Comments 
ADD CONSTRAINT FK_Comments_ParentComments FOREIGN KEY (parent_comment_id) REFERENCES Comments(comment_id);

ALTER TABLE Likes 
ADD CONSTRAINT FK_Likes_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Likes 
ADD CONSTRAINT FK_Likes_Posts FOREIGN KEY (post_id) REFERENCES Posts(post_id);

ALTER TABLE Messages 
ADD CONSTRAINT FK_Messages_Users FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Messages 
ADD CONSTRAINT FK_Messages_MediaFiles FOREIGN KEY (media_file_id) REFERENCES MediaFiles(media_file_id);
