from jinja2 import Environment, FileSystemLoader
import os

# Prepare data (can be loaded from a file too)
invoice_data = {
    "invoice_number": "INV-2025-014",
    "date": "2025-07-15",
    "client_name": "CodeCraft Ltd",
    "items": [
        {"name": "UI Audit", "quantity": 1, "price": 5000},
        {"name": "Dashboard Build", "quantity": 1, "price": 12000}
    ],
    "total": 17000
}

# Set up folders and template
env = Environment(loader=FileSystemLoader("templates"))
template = env.get_template("invoice.html")

# Render invoice
output_html = template.render(invoice_data)

# Ensure output directory exists
os.makedirs("output", exist_ok=True)

# Save file
output_path = f"output/invoice_{invoice_data['invoice_number']}.html"
with open(output_path, "w", encoding="utf-8") as f:
    f.write(output_html)

print(f"✅ Invoice saved at: {output_path}")