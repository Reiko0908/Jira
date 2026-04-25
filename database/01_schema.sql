-- ============================================================
-- Assignment 2 – Part 1: Full Table Creation + Sample Data
-- Database Systems – Semester 2, 2025-2026
-- DBMS: MySQL
-- ============================================================

DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

CREATE TABLE PhoneNumber (
    ProfileID INT AUTO_INCREMENT PRIMARY KEY,
    PhoneNumber CHAR(10) NOT NULL,

    FOREIGN KEY (ProfileID) REFERENCES Profile(ProfileID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    CHECK (PhoneNumber REGEXP '^[0-9]{10}$')
);

CREATE TABLE COMMENT (
    CommentID INT AUTO_INCREMENT PRIMARY KEY,
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    CommentContent VARCHAR(500) NOT NULL,
    ProfileID INT NOT NULL,

    FOREIGN KEY(TaskID) REFERENCES Task(TaskID),
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY(ProfileID) REFERENCES Profile(ProfileID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    Check (CHAR_LENGTH(CommentContent) > 0)
);

CREATE TABLE Notification (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(500) NOT NULL,
    CommentID INT,
    TaskID INT NOT NULL,

    FOREIGN KEY(TaskID) REFERENCES Task(TaskID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (CHAR_LENGTH(Description) > 0)
);

ALTER TABLE Notification
    ADD FOREIGN KEY(CommentID) REFERENCES COMMENT(CommentID)
    ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE Receive (
    ProfileID INT AUTO_INCREMENT PRIMARY KEY,
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    SentTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 
    FOREIGN KEY (ProfileID) REFERENCES Profile(ProfileID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (NotificationID) REFERENCES Notification(NotificationID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (SentTime <= NOW())
);

CREATE TABLE ActivityLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    LogContent VARCHAR(500) NOT NULL,
    Timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ProfileID INT NOT NULL,
    TaskID INT NOT NULL,

    FOREIGN KEY(ProfileID) REFERENCES Profile(ProfileID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(TaskID) REFERENCES Task(TaskID)
    ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (CHAR_LENGTH(LogContent) > 0)
);

CREATE TABLE Task (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(50) NOT NULL,
    Description VARCHAR(255),
    Priority VARCHAR(10),
    DueDate TIMESTAMP,
    CreationTime TIMESTAMP NOT NULL,
    UpdateTime TIMESTAMP,
    ParentTaskID INT,
    StatusID INT,
    MilestoneID INT,
    ReporterID INT,
    AssigneeID INT NOT NULL,
    BoardID INT,

    FOREIGN KEY(ParentTaskID) REFERENCES Task(TaskID),
    FOREIGN KEY(StatusID) REFERENCES Status(StatusID),
    FOREIGN KEY(MileStoneID) REFERENCES Milestone(MilestoneID),
    FOREIGN KEY(ReporterID) REFERENCES Profile(ProfileID),
    FOREIGN KEY(AssigneeID) REFERENCES Profile(ProfileID),
    FOREIGN KEY(BoardID) REFERENCES Board(BoardID)
);

CREATE TABLE Story (
    TaskID INT PRIMARY KEY,
    StoryPoint INT
);

CREATE TABLE Bug (
    TaskID INT PRIMARY KEY,
    Severity INT NOT NULL
);

CREATE TABLE Epic (
    TaskID INT PRIMARY KEY,
    Goal VARCHAR NOT NULL
);

CREATE TABLE LinkedItem (
    TaskID INT,
    LinkedItem VARCHAR(2048) NOT NULL
);
""" vấn đề phát sinh: status của milestone và status của task"""
CREATE TABLE Milestone(
    MilestoneID INT AUTO_INCREMENT PRIMARY KEy,
    MilestoneName VARCHAR(50),
    MilestoneStatus VARCHAR(15),
    MilestoneGoal VARCHAR(255),
    StartDate DATE,
    EndDate DATE
);
