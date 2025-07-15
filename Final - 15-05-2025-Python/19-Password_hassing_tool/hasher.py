from werkzeug.security import generate_password_hash, check_password_hash

def hash_password(password):
    hashed = generate_password_hash(password)
    print(f"🔐 Hashed password:\n{hashed}")
    return hashed

def verify_password(password, stored_hash):
    if check_password_hash(stored_hash, password):
        print("✅ Password verification successful.")
    else:
        print("❌ Incorrect password.")

# Example usage
if __name__ == "__main__":
    raw_password = input("Enter password to hash: ")
    hashed_pw = hash_password(raw_password)

    test_password = input("Re-enter password to verify: ")
    verify_password(test_password, hashed_pw)