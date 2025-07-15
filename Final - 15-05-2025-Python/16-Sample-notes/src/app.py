import sqlite3
import os

os.makedirs("db", exist_ok=True)
conn = sqlite3.connect("db/notes.db")
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL
)
""")

conn.commit()
conn.close()