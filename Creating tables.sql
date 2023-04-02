-- Створення таблиці "Групи"
CREATE TABLE new_schema.Groups (
    GroupId INT PRIMARY KEY,
    GroupName VARCHAR(50) NOT NULL
);

-- Створення таблиці "Студенти"
CREATE TABLE new_schema.Students (
    StudentId INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    
    GroupId INT,
    FOREIGN KEY (GroupId) REFERENCES new_schema.Groups(GroupId)
);

-- Створення таблиці "Викладачі"
CREATE TABLE new_schema.Professors (
    ProfessorId INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Department VARCHAR(50),
    Position VARCHAR(50)
);

-- Створення таблиці "Предмети"
CREATE TABLE new_schema.Subjects (
    SubjectId INT PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL
);

-- Створення таблиці "Аудиторії"
CREATE TABLE new_schema.Classrooms (
    ClassroomId INT PRIMARY KEY,
    ClassroomName VARCHAR(50) NOT NULL
);

-- Створення таблиці "Екзамени"
CREATE TABLE new_schema.Exams (
    ExamId INT PRIMARY KEY,
    
    SubjectId INT,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),
    
    ExamDate DATE NOT NULL,
    ExamTime TIME NOT NULL,
    
    ClassroomId INT,
    FOREIGN KEY (ClassroomId) REFERENCES Classrooms(ClassroomId)
);

-- Створення таблиці "Контрольні роботи"
CREATE TABLE new_schema.Tests (
    TestId INT PRIMARY KEY,
    
    SubjectId INT,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(SubjectId),
    
    TestDate DATE NOT NULL,
    TestTime TIME NOT NULL,
    
    ClassroomId INT,
    FOREIGN KEY (ClassroomId) REFERENCES Classrooms(ClassroomId)
);

-- Створення таблиці "Розклад занять"
CREATE TABLE new_schema.Schedule (
    ScheduleId INT PRIMARY KEY,
    
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
