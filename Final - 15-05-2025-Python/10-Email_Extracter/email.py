import re

def extract_emails_from_file(file_path):
    email_pattern = r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+"

    try:
        with open(file_path, "r", encoding="utf-8") as file:
            content = file.read()
            emails = re.findall(email_pattern, content)

            if emails:
                print(f"\n📬 Found {len(emails)} email addresses:\n")
                for email in set(emails):  # Using set() to avoid duplicates
                    print(f" - {email}")
            else:
                print("\n❌ No email addresses found.")
    except FileNotFoundError:
        print("⚠️ File not found.")
    except Exception as e:
        print(f"❌ Error reading file: {e}")

# Example usage
extract_emails_from_file("sample.txt")