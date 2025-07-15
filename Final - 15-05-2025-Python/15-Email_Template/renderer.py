from jinja2 import Environment, FileSystemLoader
import os
import json

# Load template
env = Environment(loader=FileSystemLoader("templates"))
template = env.get_template("email_template.html")

# Load user data
with open("data/users.json", "r", encoding="utf-8") as f:
    users = json.load(f)

# Ensure output folder exists
os.makedirs("output", exist_ok=True)

# Render email for each user
for user in users:
    rendered_email = template.render(user)
    filename = f"output/email_{user['name'].lower()}.html"

    with open(filename, "w", encoding="utf-8") as f:
        f.write(rendered_email)

    print(f"✅ Email generated for {user['name']}: {filename}")