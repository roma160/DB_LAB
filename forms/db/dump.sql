-- Видалення існуючих таблиць
-- DROP TABLE IF EXISTS new_schema.Schedule;
-- DROP TABLE IF EXISTS new_schema.Tests;
-- DROP TABLE IF EXISTS new_schema.Exams;
-- DROP TABLE IF EXISTS new_schema.Classrooms;
-- DROP TABLE IF EXISTS new_schema.Subjects;
-- DROP TABLE IF EXISTS new_schema.Professors;
-- DROP TABLE IF EXISTS new_schema.Students;
-- DROP TABLE IF EXISTS new_schema.Groups;

DROP SCHEMA IF EXISTS new_schema;
CREATE SCHEMA new_schema;


-- Створення таблиці "Групи"
CREATE TABLE new_schema.Groups (
    GroupId INT PRIMARY KEY,
    GroupName VARCHAR(50) NOT NULL
);
INSERT INTO new_schema.Groups (GroupId, GroupName) VALUES 
    (1, 'КН-11'),
    (2, 'КН-12'),
    (3, 'КН-21'),
    (4, 'КН-22'),
    (5, 'КН-31');


-- Створення таблиці "Студенти"
CREATE TABLE new_schema.Students (
    StudentId INT PRIMARY KEY auto_increment,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    
    GroupId INT,
    FOREIGN KEY (GroupId) REFERENCES new_schema.Groups(GroupId)
);
INSERT INTO new_schema.Students (StudentId, FirstName, LastName, GroupId) VALUES 
    (1, 'Іван', 'Іванов', 1),
    (2, 'Петро', 'Петров', 1),
    (3, 'Марія', 'Петренко', 1),
    (4, 'Олег', 'Сидоренко', 3),
    (5, 'Віктор', 'Василенко', 5);


-- Створення таблиці "Викладачі"
CREATE TABLE new_schema.Professors (
    ProfessorId INT PRIMARY KEY auto_increment,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Department VARCHAR(50),
    Position VARCHAR(50)
);
INSERT INTO new_schema.Professors (ProfessorId, FirstName, LastName, Email) VALUES 
    (1, 'Іван', 'Кравчук', 'ivan.kravchuk@example.com'),
    (2, 'Марія', 'Сидоренко', 'maria.sydorenko@example.com'),
    (3, 'Олександра', 'Петренко', 'oleksandra.petrenko@example.com'),
    (4, 'Віктор', 'Бондаренко', 'victor.bondarenko@example.com'),
    (5, 'Тарас', 'Марченко', 'taras.marchenko@example.com');

-- Створення таблиці "Предмети"
CREATE TABLE new_schema.Subjects (
    SubjectId INT PRIMARY KEY,
    SubjectName VARCHAR(100) NOT NULL
);
INSERT INTO new_schema.Subjects (SubjectId, SubjectName) VALUES 
    (1, 'Бази даних'),
    (2, 'Алгоритми і структури даних'),
    (3, 'Вища математика'),
    (4, 'Історія України'),
    (5, 'Англійська мова');


-- Створення таблиці "Аудиторії"
CREATE TABLE new_schema.Classrooms (
    ClassroomId INT PRIMARY KEY,
    ClassroomName VARCHAR(50) NOT NULL
);
INSERT INTO new_schema.Classrooms (ClassroomId, ClassroomName) VALUES 
    (1, '101'),
    (2, '102'),
    (3, '201'),
    (4, '301'),
	(5, '311');


-- Створення таблиці "Екзамени"
CREATE TABLE new_schema.Exams (
    ExamId INT PRIMARY KEY auto_increment,
    
    SubjectId INT,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),
    
    ExamDate DATE NOT NULL,
    ExamTime TIME NOT NULL,
    
    ClassroomId INT,
    FOREIGN KEY (ClassroomId) REFERENCES Classrooms(ClassroomId)
);
INSERT INTO new_schema.Exams (ExamId, SubjectId, ExamDate, ExamTime, ClassroomId) VALUES 
    (1, 3, '2023-05-20', '09:00:00', 1),
    (2, 1, '2023-06-15', '12:00:00', 2),
    (3, 2, '2023-06-20', '10:00:00', 3);


-- Створення таблиці "Контрольні роботи"
CREATE TABLE new_schema.Tests (
    TestId INT PRIMARY KEY auto_increment,
    
    SubjectId INT,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),
    
    TestDate DATE NOT NULL,
    TestTime TIME NOT NULL,
    
    ClassroomId INT,
    FOREIGN KEY (ClassroomId) REFERENCES Classrooms(ClassroomId)
);
INSERT INTO new_schema.Tests (TestId, SubjectId, TestDate, TestTime, ClassroomId) VALUES
	(1, 1, '2023-05-15', '08:30:00', 1),
	(2, 2, '2023-05-17', '09:45:00', 2),
	(3, 3, '2023-05-19', '10:30:00', 3),
	(4, 4, '2023-05-21', '11:15:00', 4),
	(5, 5, '2023-05-23', '12:00:00', 5);


-- Створення таблиці "Розклад занять"
CREATE TABLE new_schema.Schedule (
    ScheduleId INT PRIMARY KEY auto_increment,
    
    SubjectId INT,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),
    
    GroupId INT,
    FOREIGN KEY (GroupId) REFERENCES  new_schema.Groups(GroupId),
    
    ProfessorId INT,
    FOREIGN KEY (ProfessorId) REFERENCES Professors(ProfessorId),
    
    ClassroomId INT,
    FOREIGN KEY (ClassroomId) REFERENCES Classrooms(ClassroomId),
    
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    DayOfWeek INT NOT NULL,
    EvenOdd BOOL NOT NULL
);
INSERT INTO new_schema.Schedule (ScheduleId, SubjectId, GroupId, ProfessorId, ClassroomId, StartTime, EndTime, DayOfWeek, EvenOdd) VALUES
	(1, 1, 1, 1, 1, '08:30:00', '10:00:00', 1, true),
	(2, 2, 1, 2, 2, '10:15:00', '11:45:00', 1, true),
	(3, 3, 3, 3, 3, '12:00:00', '13:30:00', 1, true),
	(4, 4, 3, 4, 4, '14:00:00', '15:30:00', 1, true),
	(5, 5, 5, 5, 5, '15:45:00', '17:15:00', 1, true);