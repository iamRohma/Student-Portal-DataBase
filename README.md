# Student Portal Database

A Microsoft SQL Server database management system project designed to manage student academic and administrative information.

##  Project Overview

The Student Portal Database provides a structured relational database for managing students, departments, instructors, courses, enrollment, attendance, fees, grades, and timetables.

The project demonstrates core SQL Server and database management concepts including:

* Database and table creation
* Primary and foreign keys
* Identity columns
* Constraints and data validation
* Relationships between entities
* CRUD operations
* Stored procedures
* Views
* Joins
* Sample data
* Referential integrity

##  Database Entities

The database contains the following main tables:

1. `Department`
2. `Department_Phone`
3. `Instructor`
4. `Student`
5. `Course`
6. `Timetable`
7. `Enrollment`
8. `Attendance`
9. `Fee`
10. `Grade`
11. `Course_Instructor`
12. `Student_Timetable`

##  Technologies Used

* Microsoft SQL Server
* SQL
* Relational Database Management System (RDBMS)

##  Project Structure

```text
student-portal-database/
│
├── README.md
│
├── sql/
│   └── StudentPortal.sql
│
└── docs/
```

##  How to Run

### 1. Install Microsoft SQL Server

Install Microsoft SQL Server and a SQL client such as SQL Server Management Studio (SSMS).

### 2. Open the SQL script

Open:

```text
sql/StudentPortal.sql
```

in SQL Server Management Studio.

### 3. Execute the script

Run the script to create the `StudentPortal` database, tables, constraints, stored procedures, sample data, and queries.

### 4. Select the database

After execution, select the `StudentPortal` database and verify the created tables and database objects.

##  Main Features

### Student Management

Stores student information including:

* Student ID
* Name
* Gender
* Email
* Date of birth
* Admission date
* Status
* Department

### Department Management

Stores departments, faculty information, office locations, and department phone numbers.

### Course Management

Manages courses, course types, credit hours, and department relationships.

### Instructor Management

Stores instructor information and their associated departments.

### Enrollment

Tracks which students are enrolled in which courses and records semester, enrollment date, and enrollment status.

### Attendance

Records student attendance for individual courses.

Attendance statuses include:

* Present
* Absent
* Late

### Grades

Stores marks, total marks, grade letters, and GPA points for students.

### Fees

Provides database support for managing student fee information.

### Timetable

Stores course schedules including:

* Day
* Start time
* End time
* Room
* Semester
* Instructor

##  Stored Procedures

The project includes stored procedures for performing database operations such as:

* Insert
* Update
* Retrieve all records
* Retrieve individual records
* Delete

Stored procedures are implemented for major entities including students, instructors, courses, grades, and attendance.

##  SQL Concepts Demonstrated

This project demonstrates:

* `CREATE DATABASE`
* `CREATE TABLE`
* `PRIMARY KEY`
* `FOREIGN KEY`
* `IDENTITY`
* `UNIQUE`
* `CHECK`
* `DEFAULT`
* `NOT NULL`
* `INSERT`
* `UPDATE`
* `DELETE`
* `SELECT`
* `INNER JOIN`
* `STORED PROCEDURE`
* `VIEW`
* Referential integrity
* Cascading and restricted deletes

##  Academic Project

This project was developed as a database management system project to demonstrate relational database design and Microsoft SQL Server concepts.

