import hashlib
import os

def hash_password(password):
    salt = os.urandom(16)
    hashed = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 100000)
    return salt.hex() + hashed.hex()

def verify_password(password, stored_hash):
    salt = bytes.fromhex(stored_hash[:32])
    stored = stored_hash[32:]
    check = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 100000).hex()
    return check == stored