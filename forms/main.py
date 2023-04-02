import config
import mysql.connector
from tkinter import *
import tkinter.ttk as ttk

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

    # subjects_button = Button(window, text="Список предметів", command=subjects_window)
    # subjects_button.pack(pady=10)

    # student_lessons_button = Button(window, text="Список пар студента", command=student_lessons_window)
    # student_lessons_button.pack(pady=10)

    # add_professor_button = Button(window, text="Додати викладача", command=add_professor_window)
    # add_professor_button.pack(pady=10)

    # add_student_button = Button(window, text="Додати студента", command=add_student_window)
    # add_student_button.pack(pady=10)

    # add_lesson_button =

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

main_window()

cursor.close()
cnx.close()