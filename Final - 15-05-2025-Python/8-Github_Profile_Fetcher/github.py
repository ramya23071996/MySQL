import requests

def fetch_github_profile(username):
    url = f"https://api.github.com/users/{username}"
    try:
        response = requests.get(url)
        data = response.json()

        if response.status_code == 200:
            print(f"\n👤 GitHub Profile: {data.get('login', 'N/A')}")
            print("-" * 40)
            print(f"📛 Name        : {data.get('name', 'N/A')}")
            print(f"📝 Bio         : {data.get('bio', 'N/A')}")
            print(f"📍 Location    : {data.get('location', 'N/A')}")
            print(f"📦 Public Repos: {data.get('public_repos', 0)}")
            print(f"👥 Followers   : {data.get('followers', 0)}")
            print(f"👣 Following   : {data.get('following', 0)}")
            print(f"🔗 Profile URL : {data.get('html_url', '')}")
        else:
            print(f"⚠️ Error: {data.get('message', 'User not found')}")

    except Exception as e:
        print(f"❌ Request failed: {e}")

# Example usage
fetch_github_profile("ramya23071996")  