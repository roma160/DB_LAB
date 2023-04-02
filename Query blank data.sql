SELECT Schedule.ScheduleId, Subjects.SubjectName, new_schema.Groups.GroupName, Professors.FirstName, Professors.LastName, Classrooms.ClassroomName, Schedule.StartTime, Schedule.EndTime, Schedule.DayOfWeek, Schedule.EvenOdd
FROM Schedule
JOIN Subjects ON Schedule.SubjectId = Subjects.SubjectId
JOIN new_schema.Groups ON Schedule.GroupId = new_schema.Groups.GroupId
JOIN Professors ON Schedule.ProfessorId = Professors.ProfessorId
JOIN Classrooms ON Schedule.ClassroomId = Classrooms.ClassroomId;
