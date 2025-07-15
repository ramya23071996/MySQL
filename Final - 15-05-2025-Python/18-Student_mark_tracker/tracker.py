import sqlite3
import os

DB_PATH = "db/marks.db"
os.makedirs("db", exist_ok=True)

def init_db():
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("""
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        math INTEGER,
        science INTEGER,
        english INTEGER,
        average REAL
    )
    """)
    conn.commit()
    conn.close()

    def is_valid_mark(mark):
        return mark.isdigit() and 0 <= int(mark) <= 100

def add_student(name, math, science, english):
    if not all(map(is_valid_mark, [math, science, english])):
        print("❌ Invalid marks entered. Please use integers between 0–100.")
        return
    
    scores = list(map(int, [math, science, english]))
    avg = sum(scores) / len(scores)

    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("INSERT INTO students (name, math, science, english, average) VALUES (?, ?, ?, ?, ?)",
              (name, scores[0], scores[1], scores[2], avg))
    conn.commit()
    conn.close()
    print(f"✅ Student '{name}' added with average: {avg:.2f}")


    def view_students():
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        c.execute("SELECT name, math, science, english, average FROM students")
        rows = c.fetchall()
        conn.close()

        print("\n📚 Student Records:")
        for row in rows:
            name, math, science, english, avg = row
            print(f"🔸 {name}: Math={math}, Science={science}, English={english}, Average={avg:.2f}")


