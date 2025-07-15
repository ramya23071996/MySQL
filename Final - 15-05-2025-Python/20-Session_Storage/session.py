from werkzeug.datastructures import CallbackDict

class CLISession:
    def __init__(self):
        self._session = CallbackDict(on_update=self._on_update)

    def _on_update(self, session):
        print(f"📌 Session updated: {session}")

    def login(self, username):
        self._session["user"] = username
        self._session["authenticated"] = True
        print(f"🔓 {username} logged in.")

    def logout(self):
        self._session.clear()
        print("🔒 Session cleared. User logged out.")

    def track_action(self, action):
        history = self._session.get("history", [])
        history.append(action)
        self._session["history"] = history

    def get_session_data(self):
        return dict(self._session)

# ✅ Example usage
if __name__ == "__main__":
    session = CLISession()
    session.login("ramya")
    session.track_action("Viewed Dashboard")
    session.track_action("Edited Profile")

    print("\n🧾 Session Snapshot:")
    print(session.get_session_data())

    session.logout()