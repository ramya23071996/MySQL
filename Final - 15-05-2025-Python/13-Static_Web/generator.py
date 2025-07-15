from jinja2 import Environment, FileSystemLoader
import os

# Load template from /templates
env = Environment(loader=FileSystemLoader("templates"))
template = env.get_template("base.html")

# Sample data
data = {
    "title": "Modular Static Site",
    "menu": [
        {"label": "Home", "url": "/home"},
        {"label": "About", "url": "/about"},
        {"label": "Contact", "url": "/contact"}
    ]
}

# Render and write output
output_html = template.render(data)
os.makedirs("output", exist_ok=True)

with open("output/index.html", "w", encoding="utf-8") as f:
    f.write(output_html)