from urllib.parse import urljoin, urlencode

# Base URL
base_url = "https://example.com/api/"

# Build path
user_path = "users/42/profile"
full_path = urljoin(base_url, user_path)
print(f"🔗 User Profile URL: {full_path}")

# Build query string
params = {
    "sort": "name",
    "limit": 10,
    "include": ["email", "role"]
}
query_string = urlencode(params, doseq=True)
query_url = f"{urljoin(base_url, 'users')}?{query_string}"
print(f"🔗 Query URL: {query_url}")