-- Create the students table
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    school_enrollment_date DATE
);

-- Create the professors table
CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100)
);

-- Create the courses table
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT,
    professor_id INT,
    FOREIGN KEY (professor_id) REFERENCES professors(id)
);

-- Create the enrollments table
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Insert data into students
INSERT INTO students (first_name, last_name, email, school_enrollment_date)
VALUES 
('Alice', 'Smith', 'alice.smith@example.com', '2022-09-01'),
('Bob', 'Johnson', 'bob.johnson@example.com', '2022-09-01'),
('Charlie', 'Williams', 'charlie.williams@example.com', '2023-01-15'),
('Diana', 'Brown', 'diana.brown@example.com', '2023-02-01'),
('Ethan', 'Davis', 'ethan.davis@example.com', '2023-03-01');

-- Insert data into professors
INSERT INTO professors (first_name, last_name, department)
VALUES
('John', 'Doe', 'Physics'),
('Jane', 'Miller', 'Mathematics'),
('Emily', 'Clark', 'Computer Science'),
('Paul', 'Adams', 'History');

-- Insert data into courses
INSERT INTO courses (course_name, course_description, professor_id)
VALUES
('Physics 101', 'Introduction to Physics', 1),
('Calculus I', 'Introduction to Differential Calculus', 2),
('History of Europe', 'Survey of European History', 4);

-- Insert data into enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2023-09-01'), -- Alice in Physics 101
(2, 1, '2023-09-01'), -- Bob in Physics 101
(3, 2, '2023-09-01'), -- Charlie in Calculus I
(4, 3, '2023-09-01'), -- Diana in History of Europe
(5, 1, '2023-09-02'); -- Ethan in Physics 101

-- Query 1: Retrieve the full names of all students enrolled in “Physics 101”
SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name
FROM students s
JOIN enrollments e ON s.id = e.student_id
JOIN courses c ON e.course_id = c.id
WHERE c.course_name = 'Physics 101';

-- Query 2: Retrieve a list of all courses along with the professor’s full name
SELECT c.course_name, CONCAT(p.first_name, ' ', p.last_name) AS professor_name
FROM courses c
JOIN professors p ON c.professor_id = p.id;

-- Query 3: Retrieve all courses that have students enrolled in them
SELECT DISTINCT c.course_name
FROM courses c
JOIN enrollments e ON c.id = e.course_id;

-- Update one of the student's emails
UPDATE students
SET email = 'new_bob.johnson@example.com'
WHERE first_name = 'Bob' AND last_name = 'Johnson';

-- Delete: Remove Ethan from Physics 101
DELETE FROM enrollments
WHERE student_id = 5 AND course_id = 1;