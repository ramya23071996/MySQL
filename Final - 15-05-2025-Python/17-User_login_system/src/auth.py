import sqlite3
import os
from utils.crypto import hash_password, verify_password
import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from utils.crypto import hash_password, verify_password

DB_PATH = "db/users.db"
os.makedirs("db", exist_ok=True)

def init_db():
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("""
    CREATE TABLE IF NOT EXISTS users (
        username TEXT PRIMARY KEY,
        password TEXT NOT NULL
    )""")
    conn.commit()
    conn.close()

def register(username, password):
    hashed = hash_password(password)
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    try:
        c.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, hashed))
        conn.commit()
        print("✅ User registered successfully.")
    except sqlite3.IntegrityError:
        print("❌ Username already exists.")
    conn.close()

def login(username, password):
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.execute("SELECT password FROM users WHERE username = ?", (username,))
    result = c.fetchone()
    conn.close()
    if result and verify_password(password, result[0]):
        print(f"🔓 Welcome back, {username}!")
    else:
        print("🚫 Login failed. Invalid credentials.")

# Example usage
if __name__ == "__main__":
    init_db()
    register("ramya", "secure123")
    login("ramya", "secure123")