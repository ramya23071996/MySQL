import json
import os

SETTINGS_FILE = "user_settings.json"

# Default settings
default_settings = {
    "theme": "light",
    "language": "en",
    "notifications": True
}

def load_settings():
    if not os.path.exists(SETTINGS_FILE):
        save_settings(default_settings)
        return default_settings

    try:
        with open(SETTINGS_FILE, "r") as f:
            return json.load(f)
    except Exception as e:
        print(f"⚠️ Error loading settings: {e}")
        return default_settings

def save_settings(settings):
    try:
        with open(SETTINGS_FILE, "w") as f:
            json.dump(settings, f, indent=4)
    except Exception as e:
        print(f"⚠️ Error saving settings: {e}")

def update_setting(key, value):
    settings = load_settings()
    settings[key] = value
    save_settings(settings)
    print(f"✅ Updated '{key}' to '{value}'")

# Example usage
update_setting("theme", "dark")
update_setting("language", "ta")