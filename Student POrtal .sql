Create Database StudentPortal;

--DDL COMMANDS__

Create table Department(
dept_id INT PRIMARY KEY IDENTITY(1,1),
dept_name       VARCHAR(100)  NOT NULL,
faculty_name    VARCHAR(100)  NOT NULL,
office_location VARCHAR(100)
);

Create Table Department_Phone(
phone_id INT PRIMARY KEY IDENTITY(1,1),
dept_id   INT         NOT NULL,
phone_no  VARCHAR(20) NOT NULL,
CONSTRAINT FK_DeptPhone_Dept FOREIGN KEY (dept_id)
REFERENCES Department(dept_id) ON DELETE NO ACTION
);

CREATE TABLE Instructor (
    instructor_id INT          PRIMARY KEY IDENTITY(1,1),
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    designation   VARCHAR(50),
    dept_id       INT,
    CONSTRAINT FK_Instructor_Dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id) ON DELETE SET NULL
);

CREATE TABLE Student (
    student_id     INT          PRIMARY KEY IDENTITY(1,1),
    first_name     VARCHAR(50)  NOT NULL,
    last_name      VARCHAR(50)  NOT NULL,
    gender         CHAR(1)      CHECK (gender IN ('M','F','O')),
    email          VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth  DATE         NOT NULL,
    admission_date DATE         NOT NULL,
    status         VARCHAR(20)  NOT NULL DEFAULT 'Active'
                                CHECK (status IN ('Active','Inactive','Graduated','Suspended')),
    dept_id        INT,
    CONSTRAINT FK_Student_Dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id) ON DELETE SET NULL
);

CREATE TABLE Course (
    course_id    INT          PRIMARY KEY IDENTITY(1,1),
    course_name  VARCHAR(100) NOT NULL,
    course_type  VARCHAR(30)  NOT NULL
                              CHECK (course_type IN ('Core','Elective','Lab')),
    credit_hours INT          NOT NULL CHECK (credit_hours BETWEEN 1 AND 6),
    dept_id      INT,
    CONSTRAINT FK_Course_Dept FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id) ON DELETE SET NULL
);

CREATE TABLE Timetable (
    timetable_id  INT         PRIMARY KEY IDENTITY(1,1),
    course_id     INT         NOT NULL,
    instructor_id INT         NULL,
    day_of_week   VARCHAR(10) NOT NULL
                              CHECK (day_of_week IN ('Monday','Tuesday','Wednesday',
                                                      'Thursday','Friday','Saturday','Sunday')),
    start_time    TIME        NOT NULL,
    end_time      TIME        NOT NULL,
    room_no       VARCHAR(20) NOT NULL,
    semester      VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Timetable_Course     FOREIGN KEY (course_id)
        REFERENCES Course(course_id),
    CONSTRAINT FK_Timetable_Instructor FOREIGN KEY (instructor_id)
        REFERENCES Instructor(instructor_id) ON DELETE SET NULL
);

CREATE TABLE Enrollment (
    enrollment_id INT         PRIMARY KEY IDENTITY(1,1),
    student_id    INT         NOT NULL,
    course_id     INT         NOT NULL,
    semester      VARCHAR(20) NOT NULL,
    enroll_date   DATE        NOT NULL,
    status        VARCHAR(20) NOT NULL DEFAULT 'Active'
                              CHECK (status IN ('Active','Dropped','Completed')),
    CONSTRAINT FK_Enrollment_Student FOREIGN KEY (student_id)
        REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT FK_Enrollment_Course  FOREIGN KEY (course_id)
        REFERENCES Course(course_id),
    CONSTRAINT UQ_Enrollment UNIQUE (student_id, course_id, semester)
);

CREATE TABLE Attendance (
    attendance_id   INT         PRIMARY KEY IDENTITY(1,1),
    student_id      INT         NOT NULL,
    course_id       INT         NOT NULL,
    attendance_date DATE        NOT NULL,
    status          VARCHAR(10) NOT NULL
                                CHECK (status IN ('Present','Absent','Late')),
    CONSTRAINT FK_Attendance_Student FOREIGN KEY (student_id)
        REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT FK_Attendance_Course  FOREIGN KEY (course_id)
        REFERENCES Course(course_id)
);

CREATE TABLE Fee (
    fee_id         INT           PRIMARY KEY IDENTITY(1,1),
    student_id     INT           NOT NULL,
    semester       VARCHAR(20)   NOT NULL,
    amount_due     DECIMAL(10,2) NOT NULL,
    amount_paid    DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_status VARCHAR(20)   NOT NULL DEFAULT 'Unpaid'
                                 CHECK (payment_status IN ('Paid','Unpaid','Overdue')),
    due_date       DATE          NOT NULL,
    CONSTRAINT FK_Fee_Student FOREIGN KEY (student_id)
        REFERENCES Student(student_id) ON DELETE CASCADE
);
CREATE TABLE Grade (
    grade_id       INT           PRIMARY KEY IDENTITY(1,1),
    student_id     INT           NOT NULL,
    course_id      INT           NOT NULL,
    marks_obtained DECIMAL(5,2)  NOT NULL,
    total_marks    DECIMAL(5,2)  NOT NULL DEFAULT 100,
    grade_letter   CHAR(2)       NOT NULL
                                 CHECK (grade_letter IN ('A+','A','B+','B','C+','C','D','F')),
    GPA_points     DECIMAL(3,2)  NOT NULL CHECK (GPA_points BETWEEN 0 AND 4),
    CONSTRAINT FK_Grade_Student FOREIGN KEY (student_id)
        REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT FK_Grade_Course  FOREIGN KEY (course_id)
        REFERENCES Course(course_id),
    CONSTRAINT UQ_Grade UNIQUE (student_id, course_id)
);
CREATE TABLE Course_Instructor (
    course_id     INT NOT NULL,
    instructor_id INT NOT NULL,
    CONSTRAINT PK_Course_Instructor PRIMARY KEY (course_id, instructor_id),
    CONSTRAINT FK_CI_Course     FOREIGN KEY (course_id)
        REFERENCES Course(course_id)     ON DELETE CASCADE,
    CONSTRAINT FK_CI_Instructor FOREIGN KEY (instructor_id)
        REFERENCES Instructor(instructor_id) ON DELETE CASCADE
);
CREATE TABLE Student_Timetable (
    student_id   INT NOT NULL,
    timetable_id INT NOT NULL,
    CONSTRAINT PK_Student_Timetable PRIMARY KEY (student_id, timetable_id),
    CONSTRAINT FK_ST_Student   FOREIGN KEY (student_id)
        REFERENCES Student(student_id)     ON DELETE CASCADE,
    CONSTRAINT FK_ST_Timetable FOREIGN KEY (timetable_id)
        REFERENCES Timetable(timetable_id) ON DELETE CASCADE
);


--DML-- INSERTING DATA __

INSERT INTO Department (dept_name, faculty_name, office_location) VALUES
    ('Computer Science',        'Dr. Ahmed Ali',       'Block A, Room 101'),
    ('Electrical Engineering',  'Dr. Sara Khan',       'Block B, Room 205'),
    ('Business Administration', 'Prof. Usman Malik',   'Block C, Room 310'),
    ('Mathematics',             'Dr. Ayesha Raza',     'Block A, Room 115'),
    ('Physics',                 'Dr. Kamran Siddiqui', 'Block D, Room 401');

INSERT INTO Department_Phone (dept_id, phone_no) VALUES
    (1, '042-111-0001'), (1, '042-111-0002'),
    (2, '042-111-0010'), (2, '042-111-0011'),
    (3, '042-111-0020'),
    (4, '042-111-0030'), (4, '042-111-0031'),
    (5, '042-111-0040');

INSERT INTO Instructor (first_name, last_name, email, designation, dept_id) VALUES
    ('Ali',    'Hassan',   'ali.hassan@uni.edu',  'Professor',           1),
    ('Sara',   'Noor',     'sara.noor@uni.edu',   'Associate Professor', 1),
    ('Bilal',  'Chaudhry', 'bilal.ch@uni.edu',    'Assistant Professor', 2),
    ('Amna',   'Sheikh',   'amna.sheikh@uni.edu', 'Lecturer',            2),
    ('Tariq',  'Mahmood',  'tariq.m@uni.edu',     'Professor',           3),
    ('Hina',   'Baig',     'hina.baig@uni.edu',   'Associate Professor', 4),
    ('Zubair', 'Iqbal',    'zubair.iq@uni.edu',   'Lecturer',            5),
    ('Nadia',  'Farooq',   'nadia.f@uni.edu',     'Assistant Professor', 1);

  
INSERT INTO Student (first_name, last_name, gender, email, date_of_birth, admission_date, status, dept_id) VALUES
    ('Hamza',   'Malik',   'M', 'hamza.malik@std.edu', '2002-03-15', '2021-09-01', 'Active',    1),
    ('Zara',    'Ahmed',   'F', 'zara.ahmed@std.edu',  '2001-07-22', '2020-09-01', 'Active',    1),
    ('Omar',    'Butt',    'M', 'omar.butt@std.edu',   '2003-01-10', '2022-09-01', 'Active',    2),
    ('Sana',    'Riaz',    'F', 'sana.riaz@std.edu',   '2002-11-05', '2021-09-01', 'Active',    2),
    ('Faisal',  'Qureshi', 'M', 'faisal.q@std.edu',   '2000-06-18', '2019-09-01', 'Graduated', 3),
    ('Mehwish', 'Javed',   'F', 'mehwish.j@std.edu',  '2001-09-30', '2020-09-01', 'Active',    3),
    ('Talha',   'Awan',    'M', 'talha.awan@std.edu', '2003-04-25', '2022-09-01', 'Active',    1),
    ('Ayesha',  'Farhan',  'F', 'ayesha.f@std.edu',   '2002-08-14', '2021-09-01', 'Active',    4),
    ('Imran',   'Sohail',  'M', 'imran.s@std.edu',    '2001-12-01', '2020-09-01', 'Inactive',  5),
    ('Rabia',   'Khalid',  'F', 'rabia.k@std.edu',    '2003-05-20', '2022-09-01', 'Active',    1);


INSERT INTO Course (course_name, course_type, credit_hours, dept_id) VALUES
    ('Introduction to Programming',  'Core',     3, 1),
    ('Data Structures & Algorithms', 'Core',     3, 1),
    ('Database Systems',             'Core',     3, 1),
    ('Circuit Analysis',             'Core',     3, 2),
    ('Digital Electronics',          'Lab',      2, 2),
    ('Principles of Management',     'Core',     3, 3),
    ('Financial Accounting',         'Elective', 3, 3),
    ('Calculus I',                   'Core',     3, 4),
    ('Linear Algebra',               'Core',     3, 4),
    ('Mechanics',                    'Core',     3, 5);


INSERT INTO Timetable (course_id, instructor_id, day_of_week, start_time, end_time, room_no, semester) VALUES
    (1,  1, 'Monday',    '08:00', '09:30', 'CS-101',   'Fall 2024'),
    (2,  2, 'Tuesday',   '10:00', '11:30', 'CS-102',   'Fall 2024'),
    (3,  1, 'Wednesday', '12:00', '13:30', 'CS-101',   'Fall 2024'),
    (4,  3, 'Monday',    '09:00', '10:30', 'EE-201',   'Fall 2024'),
    (5,  4, 'Thursday',  '14:00', '16:00', 'EE-Lab',   'Fall 2024'),
    (6,  5, 'Tuesday',   '08:00', '09:30', 'BBA-301',  'Fall 2024'),
    (7,  5, 'Wednesday', '10:00', '11:30', 'BBA-302',  'Fall 2024'),
    (8,  6, 'Friday',    '08:00', '09:30', 'MATH-101', 'Fall 2024'),
    (9,  6, 'Friday',    '10:00', '11:30', 'MATH-101', 'Fall 2024'),
    (10, 7, 'Thursday',  '08:00', '09:30', 'PHY-401',  'Fall 2024');

INSERT INTO Enrollment (student_id, course_id, semester, enroll_date, status) VALUES
    (1,  1, 'Fall 2024', '2024-09-02', 'Active'),
    (1,  2, 'Fall 2024', '2024-09-02', 'Active'),
    (1,  3, 'Fall 2024', '2024-09-02', 'Active'),
    (2,  1, 'Fall 2024', '2024-09-02', 'Active'),
    (2,  2, 'Fall 2024', '2024-09-02', 'Dropped'),
    (3,  4, 'Fall 2024', '2024-09-02', 'Active'),
    (3,  5, 'Fall 2024', '2024-09-02', 'Active'),
    (4,  4, 'Fall 2024', '2024-09-02', 'Active'),
    (5,  6, 'Fall 2024', '2024-09-02', 'Completed'),
    (6,  6, 'Fall 2024', '2024-09-02', 'Active'),
    (6,  7, 'Fall 2024', '2024-09-02', 'Active'),
    (7,  1, 'Fall 2024', '2024-09-02', 'Active'),
    (8,  8, 'Fall 2024', '2024-09-02', 'Active'),
    (8,  9, 'Fall 2024', '2024-09-02', 'Active'),
    (10, 1, 'Fall 2024', '2024-09-02', 'Active');
INSERT INTO Attendance (student_id, course_id, attendance_date, status) VALUES
    (1,  1, '2024-09-09', 'Present'),
    (1,  1, '2024-09-16', 'Present'),
    (1,  1, '2024-09-23', 'Absent'),
    (1,  2, '2024-09-10', 'Present'),
    (1,  2, '2024-09-17', 'Late'),
    (2,  1, '2024-09-09', 'Present'),
    (2,  1, '2024-09-16', 'Absent'),
    (2,  1, '2024-09-23', 'Absent'),
    (3,  4, '2024-09-09', 'Present'),
    (3,  4, '2024-09-16', 'Present'),
    (4,  4, '2024-09-09', 'Late'),
    (4,  4, '2024-09-16', 'Present'),
    (6,  6, '2024-09-10', 'Present'),
    (6,  6, '2024-09-17', 'Present'),
    (7,  1, '2024-09-09', 'Absent'),
    (7,  1, '2024-09-16', 'Absent'),
    (8,  8, '2024-09-13', 'Present'),
    (8,  8, '2024-09-20', 'Present'),
    (10, 1, '2024-09-09', 'Present'),
    (10, 1, '2024-09-16', 'Late');


INSERT INTO Fee (student_id, semester, amount_due, amount_paid, payment_status, due_date) VALUES
    (1,  'Fall 2024', 50000.00, 50000.00, 'Paid',    '2024-09-30'),
    (2,  'Fall 2024', 50000.00, 25000.00, 'Unpaid',  '2024-09-30'),
    (3,  'Fall 2024', 45000.00, 45000.00, 'Paid',    '2024-09-30'),
    (4,  'Fall 2024', 45000.00,     0.00, 'Overdue', '2024-09-30'),
    (5,  'Fall 2024', 48000.00, 48000.00, 'Paid',    '2024-09-30'),
    (6,  'Fall 2024', 48000.00, 20000.00, 'Unpaid',  '2024-09-30'),
    (7,  'Fall 2024', 50000.00, 50000.00, 'Paid',    '2024-09-30'),
    (8,  'Fall 2024', 42000.00,     0.00, 'Overdue', '2024-09-30'),
    (9,  'Fall 2024', 42000.00, 42000.00, 'Paid',    '2024-09-30'),
    (10, 'Fall 2024', 50000.00, 50000.00, 'Paid',    '2024-09-30');


INSERT INTO Grade (student_id, course_id, marks_obtained, total_marks, grade_letter, GPA_points) VALUES
    (1,  1, 85.00, 100, 'A',  3.70),
    (1,  2, 78.00, 100, 'B+', 3.30),
    (1,  3, 91.00, 100, 'A+', 4.00),
    (2,  1, 62.00, 100, 'C+', 2.30),
    (3,  4, 74.00, 100, 'B',  3.00),
    (4,  4, 45.00, 100, 'F',  0.00),
    (5,  6, 88.00, 100, 'A',  3.70),
    (6,  6, 55.00, 100, 'C',  2.00),
    (6,  7, 70.00, 100, 'B',  3.00),
    (7,  1, 40.00, 100, 'F',  0.00),
    (8,  8, 95.00, 100, 'A+', 4.00),
    (8,  9, 82.00, 100, 'A',  3.70);

INSERT INTO Course_Instructor (course_id, instructor_id) VALUES
    (1,  1), (1, 8),
    (2,  2),
    (3,  1),
    (4,  3),
    (5,  4),
    (6,  5), (7, 5),
    (8,  6), (9, 6),
    (10, 7);


 INSERT INTO Student_Timetable (student_id, timetable_id) VALUES
    (1,  1), (1, 2), (1, 3),
    (2,  1),
    (3,  4), (3, 5),
    (4,  4),
    (6,  6), (6, 7),
    (7,  1),
    (8,  8), (8, 9),
    (10, 1);

SELECT 'Department'        AS table_name, COUNT(*) AS row_count FROM Department        UNION ALL
SELECT 'Department_Phone',                COUNT(*)              FROM Department_Phone   UNION ALL
SELECT 'Instructor',                      COUNT(*)              FROM Instructor         UNION ALL
SELECT 'Student',                         COUNT(*)              FROM Student            UNION ALL
SELECT 'Course',                          COUNT(*)              FROM Course             UNION ALL
SELECT 'Timetable',                       COUNT(*)              FROM Timetable          UNION ALL
SELECT 'Enrollment',                      COUNT(*)              FROM Enrollment         UNION ALL
SELECT 'Attendance',                      COUNT(*)              FROM Attendance         UNION ALL
SELECT 'Fee',                             COUNT(*)              FROM Fee                UNION ALL
SELECT 'Grade',                           COUNT(*)              FROM Grade              UNION ALL
SELECT 'Course_Instructor',               COUNT(*)              FROM Course_Instructor  UNION ALL
SELECT 'Student_Timetable',               COUNT(*)              FROM Student_Timetable;

SELECT * FROM Department;
SELECT * FROM Department_Phone;
SELECT * FROM Instructor;
SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Timetable;
SELECT * FROM Enrollment;
SELECT * FROM Attendance;
SELECT * FROM Fee;
SELECT * FROM Grade;
SELECT * FROM Course_Instructor;
SELECT * FROM Student_Timetable;

select dept_name from Department
where dept_id=3;

select phone_no from Department_Phone
where dept_id=5;

update Department
set
dept_name='Fashion Design'
where dept_id=4;

select first_name,last_name from Instructor
where dept_id=2

select first_name,last_name from Student
where gender='M'

update  Student
set
first_name='Ali'
where
first_name='Talha';

update  Student
set
status='inactive'
where
student_id=6;

delete from student
where last_name='sohail'

select grade_letter from Grade
    where student_id=5;

    update Grade
    set
    grade_letter='A'
    where
     course_id=8

     select * from Grade



     delete from Grade
     where grade_Letter='C'
select course_name from Course
where course_name like'C%'

delete Course
where dept_id=1


-- VIEW --

CREATE VIEW vw_StudentPortal AS
SELECT
  
    s.student_id,
    s.first_name + ' ' + s.last_name AS Student_Name,
    s.gender,
    s.email AS Student_Email,
    s.admission_date,
    s.status AS Student_Status,

  
    d.dept_name,
    d.faculty_name,
    d.office_location,
    dp.phone_no AS Department_Phone,


    c.course_id,
    c.course_name,
    c.course_type,
    c.credit_hours,

   
    e.semester,
    e.enroll_date,
    e.status AS Enrollment_Status,

   
    i.instructor_id,
    i.first_name + ' ' + i.last_name AS Instructor_Name,
    i.designation,
    i.email AS Instructor_Email,

   
    t.day_of_week,
    t.start_time,
    t.end_time,
    t.room_no,

  
    a.attendance_date,
    a.status AS Attendance_Status,
    g.marks_obtained,
    g.total_marks,
    g.grade_letter,
    g.GPA_points,

    f.amount_due,
    f.amount_paid,
    f.payment_status,
    f.due_date

FROM Student s
LEFT JOIN Department d
    ON s.dept_id = d.dept_id

LEFT JOIN Department_Phone dp
    ON d.dept_id = dp.dept_id

LEFT JOIN Enrollment e
    ON s.student_id = e.student_id

LEFT JOIN Course c
    ON e.course_id = c.course_id

LEFT JOIN Course_Instructor ci
    ON c.course_id = ci.course_id

LEFT JOIN Instructor i
    ON ci.instructor_id = i.instructor_id

LEFT JOIN Timetable t
    ON c.course_id = t.course_id

LEFT JOIN Attendance a
    ON s.student_id = a.student_id
    AND c.course_id = a.course_id

LEFT JOIN Grade g
    ON s.student_id = g.student_id
    AND c.course_id = g.course_id

LEFT JOIN Fee f
    ON s.student_id = f.student_id
    Go

    SELECT * FROM vw_StudentPortal


    --Stored Procedures
CREATE PROCEDURE SP_Departmentd
@condition INT,
@dept_id INT,
@dept_name VARCHAR(100),
@faculty_name VARCHAR(100),
@office_location VARCHAR(100)

AS
BEGIN

IF(@condition=1)
BEGIN
INSERT INTO Department(dept_name,faculty_name,office_location)
VALUES(@dept_name,@faculty_name,@office_location)
END

ELSE IF(@condition=2)
BEGIN
UPDATE Department
SET
dept_name=ISNULL(@dept_name,dept_name),
faculty_name=ISNULL(@faculty_name,faculty_name),
office_location=ISNULL(@office_location,office_location)
WHERE dept_id=@dept_id
END

ELSE IF(@condition=3)
BEGIN
SELECT * FROM Department
END

ELSE IF(@condition=4)
BEGIN
SELECT * FROM Department
WHERE dept_id=@dept_id
END

ELSE IF(@condition=5)
BEGIN
DELETE FROM Department
WHERE dept_id=@dept_id
END

ELSE
PRINT 'Please select correct option'

END

Go
CREATE PROCEDURE SP_Student
@condition INT,
@student_id INT=NULL,
@first_name VARCHAR(50),
@last_name VARCHAR(50),
@gender CHAR(1),
@email VARCHAR(100),
@date_of_birth DATE,
@admission_date DATE,
@status VARCHAR(20),
@dept_id INT

AS
BEGIN

IF(@condition=1)
BEGIN
INSERT INTO Student(first_name,last_name,gender,email,date_of_birth,admission_date,status,dept_id)
VALUES(@first_name,@last_name,@gender,@email,@date_of_birth,@admission_date,@status,@dept_id)
END


ELSE IF(@condition=2)
BEGIN
UPDATE Student
SET
first_name=ISNULL(@first_name,first_name),
last_name=ISNULL(@last_name,last_name),
gender=ISNULL(@gender,gender),
email=ISNULL(@email,email),
date_of_birth=ISNULL(@date_of_birth,date_of_birth),
admission_date=ISNULL(@admission_date,admission_date),
status=ISNULL(@status,status),
dept_id=ISNULL(@dept_id,dept_id)
WHERE student_id=@student_id
END

ELSE IF(@condition=3)
BEGIN
SELECT * FROM Student
END

ELSE IF(@condition=4)
BEGIN
SELECT * FROM Student
WHERE student_id=@student_id
END

ELSE IF(@condition=5)
BEGIN
DELETE FROM Student
WHERE student_id=@student_id
END

ELSE
PRINT 'Please select correct option'

END
Go

CREATE PROCEDURE SP_instructor
@condition INT,
@instructor_id INT,
@first_name VARCHAR(50),
@last_name VARCHAR(50),
@email VARCHAR(100),
@designation VARCHAR(50),
@dept_id INT

AS
BEGIN

IF(@condition=1)
BEGIN
INSERT INTO Instructor(first_name,last_name,email,designation,dept_id)
VALUES(@first_name,@last_name,@email,@designation,@dept_id)
END

ELSE IF(@condition=2)
BEGIN
UPDATE Instructor
SET
first_name=ISNULL(@first_name,first_name),
last_name=ISNULL(@last_name,last_name),
email=ISNULL(@email,email),
designation=ISNULL(@designation,designation),
dept_id=ISNULL(@dept_id,dept_id)
WHERE instructor_id=@instructor_id
END

ELSE IF(@condition=3)
BEGIN
SELECT * FROM Instructor
END

ELSE IF(@condition=4)
BEGIN
SELECT * FROM Instructor
WHERE instructor_id=@instructor_id
END

ELSE IF(@condition=5)
BEGIN
DELETE FROM Instructor
WHERE instructor_id=@instructor_id
END

ELSE
PRINT 'Please select correct option'

END

Go

CREATE PROCEDURE SP_Course
@condition INT,
@course_id INT,
@course_name VARCHAR(100),
@course_type VARCHAR(30),
@credit_hours INT,
@dept_id INT

AS
BEGIN

IF(@condition=1)
BEGIN
INSERT INTO Course(course_name,course_type,credit_hours,dept_id)
VALUES(@course_name,@course_type,@credit_hours,@dept_id)
END

ELSE IF(@condition=2)
BEGIN
UPDATE Course
SET
course_name=ISNULL(@course_name,course_name),
course_type=ISNULL(@course_type,course_type),
credit_hours=ISNULL(@credit_hours,credit_hours),
dept_id=ISNULL(@dept_id,dept_id)
WHERE course_id=@course_id
END

ELSE IF(@condition=3)
BEGIN
SELECT * FROM Course
END

ELSE IF(@condition=4)
BEGIN
SELECT * FROM Course
WHERE course_id=@course_id
END

ELSE IF(@condition=5)
BEGIN
DELETE FROM Course
WHERE course_id=@course_id
END

ELSE
PRINT 'Please select correct option'

END
go

CREATE PROCEDURE SP_Grade
@condition INT,
@grade_id INT,
@student_id INT,
@course_id INT,
@marks_obtained DECIMAL(5,2),
@total_marks DECIMAL(5,2),
@grade_letter CHAR(2),
@GPA_points DECIMAL(3,2)

AS
BEGIN

IF(@condition=1)
BEGIN
INSERT INTO Grade(student_id,course_id,marks_obtained,total_marks,grade_letter,GPA_points)
VALUES(@student_id,@course_id,@marks_obtained,@total_marks,@grade_letter,@GPA_points)
END

ELSE IF(@condition=2)
BEGIN
UPDATE Grade
SET
student_id=ISNULL(@student_id,student_id),
course_id=ISNULL(@course_id,course_id),
marks_obtained=ISNULL(@marks_obtained,marks_obtained),
total_marks=ISNULL(@total_marks,total_marks),
grade_letter=ISNULL(@grade_letter,grade_letter),
GPA_points=ISNULL(@GPA_points,GPA_points)
WHERE grade_id=@grade_id
END

ELSE IF(@condition=3)
BEGIN
SELECT * FROM Grade
END

ELSE IF(@condition=4)
BEGIN
SELECT * FROM Grade
WHERE grade_id=@grade_id
END

ELSE IF(@condition=5)
BEGIN
DELETE FROM Grade
WHERE grade_id=@grade_id
END

ELSE
PRINT 'Please select correct option'

END
go

CREATE PROCEDURE SP_Attendance
@condition INT,
@attendance_id INT,
@student_id INT,
@course_id INT,
@attendance_date DATE,
@status VARCHAR(10)

AS
BEGIN

IF(@condition = 1)
BEGIN
    INSERT INTO Attendance(student_id, course_id, attendance_date, status)
    VALUES(@student_id, @course_id, @attendance_date, @status)
END

ELSE IF(@condition = 2)
BEGIN
    UPDATE Attendance
    SET
        student_id = ISNULL(@student_id, student_id),
        course_id = ISNULL(@course_id, course_id),
        attendance_date = ISNULL(@attendance_date, attendance_date),
        status = ISNULL(@status, status)
    WHERE attendance_id = @attendance_id
END

ELSE IF(@condition = 3)
BEGIN
    SELECT * FROM Attendance
END

ELSE IF(@condition = 4)
BEGIN
    SELECT * FROM Attendance
    WHERE attendance_id = @attendance_id
END

ELSE IF(@condition = 5)
BEGIN
    DELETE FROM Attendance
    WHERE attendance_id = @attendance_id
END

ELSE
BEGIN
    PRINT 'Please select correct option'
END

END
GO
--Department procedure

EXEC SP_Departmentd 1, NULL, 'Computer Science', 'Engineering', 'Block A'

EXEC SP_Departmentd 3,NULL,NULL,NUll,NUll
EXEC SP_Departmentd 4,6,NULL,NUll,NUll
exec SP_Departmentd 2,6,NULL,'Ali KHAN',null

--Student procedure
EXEC SP_Student 1, NULL, 'Ali', 'Khan', 'M', 'ali@gmail.com', '2004-01-10', '2024-09-01', 'Active', 1
EXEC SP_Student 3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NUll,NUll
EXEC SP_Student 3,2,NULL,NULL,NULL,NULL,NULL,NULL,NUll,NUll
EXEC SP_Student 5,11,NULL,NULL,NULL,NULL,NULL,NULL,NUll,NUll

--instructor  procedure
EXEC SP_Instructor 1, NULL, 'Ahmed', 'Ali', 'ahmed@gmail.com', 'Lecturer', 1

EXEC SP_Instructor 3,NULL,NULL,NULL,NULL,NUll,NUll
EXEC SP_Instructor 3,4,NULL,NULL,NULL,NUll,NUll

--Course  procedure

EXEC SP_Course 1, NULL, 'Database Systems', 'Core', 3, 1
EXEC SP_Course 4,5,NULL,NULL,NUll,NUll

--Grade  procedure
EXEC SP_Grade 1, NULL,4, 1, 85, 100, 'A', 3.5
EXEC SP_Grade 3,NULL,NULL,NULL,NULL,NUll,NUll,null
EXEC SP_Grade 2,7,NULL,NULL,NULL,null,'C',NUll
--Attendance procedure
EXEC SP_Attendance 1, NULL,1,1,'2026-06-22','Present'
EXEC SP_Attendance 3,NULL,NULL,NUll,NUll,null


--THE END --


select g.grade_letter, g.GPA_points, s.first_name , s.last_name from Grade g
inner join Student s
on 
g.student_id  = s.student_id 
