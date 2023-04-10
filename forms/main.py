import config
import mysql.connector
from tkinter import *
import tkinter.ttk as ttk
import tkinter.simpledialog as simpledialog
import tkinter.messagebox as messagebox
from datetime import time, datetime

cnx = mysql.connector.connect(
    user=config.username,
    password=config.password,
    host='localhost',
    database='new_schema'
)
cursor = cnx.cursor()

def main_window():
    global window
    window = Tk()
    window.title("Розклад факультету")
    window.geometry("300x300")

    professors_button = Button(window, text="Викладачі", command=professors_window)
    professors_button.pack(pady=10)

    students_button = Button(window, text="Список студентів", command=students_window)
    students_button.pack(pady=10)

    students_button = Button(window, text="Додати пару", command=add_schedule_element)
    students_button.pack(pady=10)

    window.mainloop()

def refresh_professors():
    if professors_table is None:
        return

    for item in professors_table.get_children():
        professors_table.delete(item)

    # Отримання даних з бази даних та заповнення таблиці
    cursor.execute("SELECT * FROM Professors")
    for row in cursor.fetchall():
        professors_table.insert("", END, values=row)

professors_table = None
def professors_window():
    # Створення вікна
    professor_window = Toplevel(window)
    professor_window.title("Викладачі")

    update_button = Button(
        professor_window, text="Оновити", command=refresh_professors
    )
    update_button.pack()

    # Створення таблиці
    global professors_table
    professors_table = ttk.Treeview(professor_window, selectmode="browse")
    professors_table.pack(padx=10, pady=10)

    # Визначення колонок таблиці
    professors_table["columns"] = (
        "id", "first_name", "last_name", "email", "phone", "department",
        "position"
    )
    professors_table.column("#0", width=0, stretch=NO)
    professors_table.column("id", anchor=CENTER, width=50)
    professors_table.column("first_name", anchor=W, width=100)
    professors_table.column("last_name", anchor=W, width=100)
    professors_table.column("email", anchor=W, width=100)
    professors_table.column("phone", anchor=W, width=100)
    professors_table.column("department", anchor=W, width=100)
    professors_table.column("position", anchor=W, width=100)

    # Встановлення заголовків колонок
    professors_table.heading("#0", text="")
    professors_table.heading("id", text="ID")
    professors_table.heading("first_name", text="Ім'я")
    professors_table.heading("last_name", text="Прізвище")
    professors_table.heading("email", text="Email")
    professors_table.heading("phone", text="Phone")
    professors_table.heading("department", text="Department")
    professors_table.heading("position", text="Position")

    refresh_professors()

    # Створення кнопки для додавання викладача
    add_professor_btn = Button(professor_window, text="Додати викладача", command=add_professor_window)
    add_professor_btn.pack(pady=10)


def add_professor_window():
    # Створення вікна
    add_professor_window = Toplevel(window)
    add_professor_window.title("Додати викладача")
    add_professor_window.geometry("250x350")

    # Створення елементів для заповнення даних викладача
    first_name_label = Label(add_professor_window, text="Ім'я:")
    first_name_label.pack()
    first_name_entry = Entry(add_professor_window)
    first_name_entry.pack()

    last_name_label = Label(add_professor_window, text="Прізвище:")
    last_name_label.pack()
    last_name_entry = Entry(add_professor_window)
    last_name_entry.pack()

    email_label = Label(add_professor_window, text="Email:")
    email_label.pack()
    email_entry = Entry(add_professor_window)
    email_entry.pack()

    phone_label = Label(add_professor_window, text="Телефон:")
    phone_label.pack()
    phone_entry = Entry(add_professor_window)
    phone_entry.pack()

    department_label = Label(add_professor_window, text="Департамент:")
    department_label.pack()
    department_entry = Entry(add_professor_window)
    department_entry.pack()

    position_label = Label(add_professor_window, text="Позиція:")
    position_label.pack()
    position_entry = Entry(add_professor_window)
    position_entry.pack()

    # Функція, яка додає викладача до бази даних
    def save_new_professor():
        # Отримання даних з полів вводу
        first_name = first_name_entry.get()
        last_name = last_name_entry.get()
        email = email_entry.get()
        phone = phone_entry.get()
        department = department_entry.get()
        position = position_entry.get()

        # SQL запит на додавання викладача до таблиці Professors
        query = "INSERT INTO Professors (FirstName, LastName, Email, Phone, Department, Position) VALUES (%s, %s, %s, %s, %s, %s)"
        values = (first_name, last_name, email, phone, department, position)
        cursor.execute(query, values)

        # Закриття вікна
        add_professor_window.destroy()

        refresh_professors()

    # Кнопка для збереження викладача
    save_button = Button(
        add_professor_window, text="Зберегти", command=save_new_professor
    )
    save_button.pack()


def student_lessons_window(student_id):
    # вибираємо групу, до якої належить студент
    query = f"""SELECT * FROM Students
WHERE Students.StudentId = {student_id}
"""
    cursor.execute(query)
    result = cursor.fetchone()
    if not result:
        messagebox.showinfo("Увага!", f"Не було знайдено студента!")
        return

    _, f_name, l_name, group_id = result
    student_name = f_name + " " + l_name

    query = "SELECT GroupName FROM new_schema.Groups WHERE GroupId = %s"
    # виконуємо запит з параметром group_id
    cursor.execute(query, (group_id,))

    student_lessons_window = Toplevel(window)
    student_lessons_window.title(f"Заняття студента {student_name}")
    student_lessons_window.geometry("600x300")

    # виводимо інформацію про студента
    Label(student_lessons_window, text=f"Студент: {student_name}").grid(column=0, row=0)
    Label(student_lessons_window, text=f"Група: {cursor.fetchone()[0]}").grid(column=1, row=0)

    # виводимо розклад занять для групи студента
    query = f"""SELECT Subjects.SubjectName, CONCAT(Professors.FirstName, ' ', Professors.LastName), Classrooms.ClassroomName, Schedule.StartTime, Schedule.EndTime, Schedule.DayOfWeek
FROM Schedule
JOIN Subjects ON Schedule.SubjectId = Subjects.SubjectId
JOIN Professors ON Schedule.ProfessorId = Professors.ProfessorId
JOIN Classrooms ON Schedule.ClassroomId = Classrooms.ClassroomId
WHERE Schedule.GroupId = {group_id}
ORDER BY Schedule.DayOfWeek, Schedule.StartTime"""
    cursor.execute(query)
    rows = cursor.fetchall()

    # Create table to display the student's schedule
    table = ttk.Treeview(
        student_lessons_window,
        columns=(
            "subject", "professor", "classroom", "start_time", "end_time",
            "day_of_week"
        )
    )
    table.heading("subject", text="Предмет")
    table.heading("professor", text="Викладач")
    table.heading("classroom", text="Аудиторія")
    table.heading("start_time", text="Початок")
    table.heading("end_time", text="Кінець")
    table.heading("day_of_week", text="День тижня")

    table.column("#0", width=0, stretch=NO)
    table.column("subject", anchor="center", width=100)
    table.column("professor", anchor="center", width=100)
    table.column("classroom", anchor="center", width=100)
    table.column("start_time", anchor="center", width=100)
    table.column("end_time", anchor="center", width=100)
    table.column("day_of_week", anchor="center", width=100)

    # Insert data into the table
    for row in rows:
        row = list(row)
        row[-1] = [
            "Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця", "Субота",
            "Неділя"
        ][row[-1]]
        table.insert("", "end", values=row)

    table.grid(row=1, column=0, columnspan=2)


def group_lessons_window(group_id, parent_window):
    query = "SELECT GroupName FROM new_schema.Groups WHERE GroupId = %s"
    # виконуємо запит з параметром group_id
    cursor.execute(query, (group_id,))
    group_name = cursor.fetchone()[0]

    student_lessons_window = Toplevel(parent_window)
    student_lessons_window.title(f"Заняття групи {group_name}")
    student_lessons_window.geometry("600x300+400+100")

    # виводимо розклад занять для групи студента
    query = f"""SELECT Subjects.SubjectName, CONCAT(Professors.FirstName, ' ', Professors.LastName), Classrooms.ClassroomName, Schedule.StartTime, Schedule.EndTime, Schedule.DayOfWeek
FROM Schedule
JOIN Subjects ON Schedule.SubjectId = Subjects.SubjectId
JOIN Professors ON Schedule.ProfessorId = Professors.ProfessorId
JOIN Classrooms ON Schedule.ClassroomId = Classrooms.ClassroomId
WHERE Schedule.GroupId = {group_id}
ORDER BY Schedule.DayOfWeek, Schedule.StartTime"""
    cursor.execute(query)
    rows = cursor.fetchall()

    # Create table to display the student's schedule
    table = ttk.Treeview(
        student_lessons_window,
        columns=(
            "subject", "professor", "classroom", "start_time", "end_time",
            "day_of_week"
        )
    )
    table.heading("subject", text="Предмет")
    table.heading("professor", text="Викладач")
    table.heading("classroom", text="Аудиторія")
    table.heading("start_time", text="Початок")
    table.heading("end_time", text="Кінець")
    table.heading("day_of_week", text="День тижня")

    table.column("#0", width=0, stretch=NO)
    table.column("subject", anchor="center", width=100)
    table.column("professor", anchor="center", width=100)
    table.column("classroom", anchor="center", width=100)
    table.column("start_time", anchor="center", width=100)
    table.column("end_time", anchor="center", width=100)
    table.column("day_of_week", anchor="center", width=100)

    # Insert data into the table
    for row in rows:
        row = list(row)
        row[-1] = [
            "Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця", "Субота",
            "Неділя"
        ][row[-1]]
        table.insert("", "end", values=row)

    table.grid(row=1, column=0, columnspan=2)

    return student_lessons_window



def students_window():
    # Отримання списку студентів з бази даних
    cursor.execute(
        "SELECT Students.FirstName, Students.LastName, new_schema.Groups.GroupName, Students.StudentId FROM Students JOIN new_schema.Groups ON Students.GroupId = new_schema.Groups.GroupId"
    )
    students = cursor.fetchall()

    # Створення вікна
    students_window = Toplevel(window)
    students_window.title("Студенти")
    students_window.geometry("400x300")

    # Створення таблиці
    table = ttk.Treeview(students_window)
    table["columns"] = ("1", "2", "3", "id")
    table.column("#0", width=0, stretch=NO)
    table.column("1", width=100, minwidth=100, anchor="center")
    table.column("2", width=100, minwidth=100, anchor="center")
    table.column("3", width=100, minwidth=100, anchor="center")
    table.column("id", width=0, stretch=NO)

    table.heading("#0", text="")
    table.heading("1", text="Ім'я")
    table.heading("2", text="Прізвище")
    table.heading("3", text="Група")

    # Заповнення таблиці даними
    for row in students:
        table.insert("", "end", values=row)

    # Додавання події вибору елемента таблиці
    def on_select(event):
        selected_item = table.focus()
        values = table.item(selected_item, "values")
        if not values:
            return
        # print(values)
        student_lessons_window(values[-1])

    table.bind("<Double-Button-1>", on_select)

    table.pack(padx=10, pady=10)


def get_subjects():
    cursor.execute("SELECT SubjectId, SubjectName FROM Subjects")
    # Отримуємо результат запиту
    result = cursor.fetchall()

    ids = []
    values = []
    for k, v in result:
        ids.append(k)
        values.append(v)
    return ids, values


def get_groups():
    cursor.execute("SELECT GroupId, GroupName FROM new_schema.Groups")
    # Отримуємо результат запиту
    result = cursor.fetchall()
    # Повертаємо список груп
    ids = []
    values = []
    for k, v in result:
        ids.append(k)
        values.append(v)
    return ids, values


def get_professors():
    cursor.execute("SELECT ProfessorId, CONCAT(LastName, ' ', FirstName) FROM Professors")
    # Отримуємо результат запиту
    result = cursor.fetchall()
    # Повертаємо список викладачів
    ids = []
    values = []
    for k, v in result:
        ids.append(k)
        values.append(v)
    return ids, values


def get_classrooms():
    cursor.execute("SELECT ClassroomId, ClassroomName FROM Classrooms")
    # Отримуємо результат запиту
    result = cursor.fetchall()
    # Повертаємо список аудиторій
    ids = []
    values = []
    for k, v in result:
        ids.append(k)
        values.append(v)
    return ids, values


def add_schedule_element():
    add_schedule_window = Toplevel(window)
    add_schedule_window.title("Додати нову пару")
    add_schedule_window.geometry("300x400")

    subject_label = Label(add_schedule_window, text="Предмет:")
    subject_label.pack()
    subject_ids, subject_names = get_subjects()
    subject_entry = ttk.Combobox(add_schedule_window, values=subject_names)
    subject_entry.pack()

    group_label = Label(add_schedule_window, text="Група:")
    group_label.pack()
    groups_ids, groups_names = get_groups()
    group_entry = ttk.Combobox(add_schedule_window, values=groups_names)
    group_entry.pack()

    group_info_window = [None]
    def on_group_selected(e):
        if group_info_window[0] is not None:
            group_info_window[0].destroy()
        if group_entry.current() == -1:
            return
        group_info_window[0] = group_lessons_window(groups_ids[group_entry.current()], add_schedule_window)
        add_schedule_window.focus_force()
    group_entry.bind("<<ComboboxSelected>>", on_group_selected)

    professor_label = Label(add_schedule_window, text="Викладач:")
    professor_label.pack()
    professors_ids, professors_names = get_professors()
    professor_entry = ttk.Combobox(add_schedule_window, values=professors_names)
    professor_entry.pack()

    classroom_label = Label(add_schedule_window, text="Аудиторія:")
    classroom_label.pack()
    classrooms_ids, classrooms_names = get_classrooms()
    classroom_entry = ttk.Combobox(add_schedule_window, values=classrooms_names)
    classroom_entry.pack()


    # # Час початку
    # start_time_frame = Frame(add_schedule_window)
    # start_time_frame.pack()
    # Label(start_time_frame, text="Час початку:").pack(side=TOP)

    # start_time_frame_picking = Frame(start_time_frame)
    # start_time_frame_picking.pack(side=TOP)
    # start_time_hours = Spinbox(start_time_frame_picking, from_=0, to=23, width=5)
    # start_time_hours.pack(side=LEFT, padx=5, pady=5)
    # Label(start_time_frame_picking, text=":").pack(side=LEFT)
    # start_time_minutes = Spinbox(start_time_frame_picking, from_=0, to=59, width=5)
    # start_time_minutes.pack(side=LEFT, padx=5, pady=5)

    # # Час закінчення
    # end_time_frame = Frame(add_schedule_window)
    # end_time_frame.pack()
    # Label(end_time_frame, text="Час закінчення:").pack(side=TOP)

    # end_time_frame_picking = Frame(end_time_frame)
    # end_time_frame_picking.pack(side=TOP)
    # end_time_hours = Spinbox(end_time_frame_picking, from_=0, to=23, width=5, validate="key",
    #         #validatecommand=
    # )
    # end_time_hours.pack(side=LEFT, padx=5, pady=5)
    # Label(end_time_frame_picking, text=":").pack(side=LEFT)
    # end_time_minutes = Spinbox(end_time_frame_picking, from_=0, to=59, width=5)
    # end_time_minutes.pack(side=LEFT, padx=5, pady=5)

    time_label = Label(add_schedule_window, text="Номер пари:")
    time_label.pack()
    time_entry = ttk.Combobox(add_schedule_window, values=[f"{i} пара" for i in range(1, 5)])
    time_entry.pack()

    start_label = Label(add_schedule_window, text="Початок:")
    start_label.pack()
    end_label = Label(add_schedule_window, text="Кінець:")
    end_label.pack()

    def on_time_selected(e):
        times = ["8:40", "10:15", "10:35", "12:10", "12:20", "13:55", "14:05", "15:40"]
        if time_entry.current() == -1:
            return
        start_label.config(text=f"Початок: {times[2*time_entry.current()]}")
        end_label.config(text=f"Кінець: {times[2*time_entry.current() + 1]}")
    time_entry.bind("<<ComboboxSelected>>", on_time_selected)

    print(group_entry.current())

    day_of_week_label = Label(add_schedule_window, text="День тижня:")
    day_of_week_label.pack()
    day_of_week_entry = ttk.Combobox(
        add_schedule_window,
        values=[
            "Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця", "Субота",
            "Неділя"
        ]
    )
    day_of_week_entry.pack()

    even_odd_label = Label(add_schedule_window, text="Парний тиждень:")
    even_odd_label.pack()
    even_odd_entry = ttk.Combobox(add_schedule_window, values=["Так", "Ні"])
    even_odd_entry.pack()

    def save_new_schedule():
        indexes = [el.current() for el in [subject_entry, group_entry, professor_entry, classroom_entry, time_entry, day_of_week_entry, even_odd_entry]]
        # start_time = time(int(start_time_hours.get()), int(start_time_minutes.get()))
        # end_time = time(int(end_time_hours.get()), int(end_time_minutes.get()))
        if any(i == -1 for i in indexes):
            messagebox.showerror("Помилка!", f"Існують незаповнені поля!")
            return
        times = ["8:40", "10:15", "10:35", "12:10", "12:20", "13:55", "14:05", "15:40"]
        start_time = datetime.strptime(times[2*indexes[4]], "%H:%M")
        end_time = datetime.strptime(times[2*indexes[4] + 1], "%H:%M")

        # SQL запит на додавання викладача до таблиці Professors
        query = "INSERT INTO new_schema.Schedule (SubjectId, GroupId, ProfessorId, ClassroomId, StartTime, EndTime, DayOfWeek, EvenOdd) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        values = (
            subject_ids[indexes[0]],
            groups_ids[indexes[1]],
            professors_ids[indexes[2]],
            classrooms_ids[indexes[3]],
            start_time.strftime("%H:%M"),
            end_time.strftime("%H:%M"),
            indexes[5],
            indexes[6]
        )
        cursor.execute(query, values)

        messagebox.showinfo("Увага!", f"Запис успішно додано!")

        # Закриття вікна
        add_schedule_window.destroy()


    save_button = Button(
        add_schedule_window,
        text="Зберегти",
        command=save_new_schedule
    )
    save_button.pack()



# print(get_subjects())
main_window()

cursor.close()
cnx.close()