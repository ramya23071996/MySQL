import json

def load_resume(json_path):
    try:
        with open(json_path, 'r') as file:
            resume = json.load(file)
    except Exception as e:
        print(f"Error loading file: {e}")
        return

    print("\n📄 Resume Summary")
    print("-" * 40)
    print(f"Name    : {resume.get('name', 'N/A')}")
    print(f"Title   : {resume.get('title', 'N/A')}")
    print(f"Email   : {resume.get('email', 'N/A')}")
    
    print("\n🛠 Skills")
    for skill in resume.get('skills', []):
        print(f" - {skill}")
    
    print("\n💼 Experience")
    for job in resume.get('experience', []):
        company = job.get('company', 'N/A')
        role = job.get('role', 'N/A')
        duration = job.get('duration', 'N/A')
        print(f"• {role} at {company} ({duration})")

# Example usage
load_resume('resume.json')