import json
import os

TODO_FILE = "todo_data.json"

def load_tasks():
    if not os.path.exists(TODO_FILE):
        return []
    with open(TODO_FILE, "r") as f:
        return json.load(f)

def save_tasks(tasks):
    with open(TODO_FILE, "w") as f:
        json.dump(tasks, f, indent=4)

def add_task(title):
    tasks = load_tasks()
    tasks.append({"title": title, "done": False})
    save_tasks(tasks)
    print(f"✅ Added: {title}")

def list_tasks():
    tasks = load_tasks()
    if not tasks:
        print("📭 No tasks found.")
    else:
        print("\n📝 Todo List:")
        for i, task in enumerate(tasks, 1):
            status = "✔️" if task["done"] else "❌"
            print(f"{i}. {task['title']} [{status}]")

def mark_done(index):
    tasks = load_tasks()
    if 0 <= index < len(tasks):
        tasks[index]["done"] = True
        save_tasks(tasks)
        print(f"🎯 Marked as done: {tasks[index]['title']}")
    else:
        print("⚠️ Invalid task index.")

def delete_task(index):
    tasks = load_tasks()
    if 0 <= index < len(tasks):
        removed = tasks.pop(index)
        save_tasks(tasks)
        print(f"🗑️ Deleted: {removed['title']}")
    else:
        print("⚠️ Invalid task index.")

# Sample usage
add_task("Finish VTS dashboard tweaks")
add_task("Run disk usage report")
list_tasks()
mark_done(0)
delete_task(1)
list_tasks()