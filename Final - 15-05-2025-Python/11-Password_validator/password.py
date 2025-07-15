import re

def validate_password(password):
    # Define regex patterns
    has_upper = re.search(r'[A-Z]', password)
    has_digit = re.search(r'\d', password)
    has_special = re.search(r'[!@#$%^&*(),.?":{}|<>]', password)

    if has_upper and has_digit and has_special:
        return "✅ Password is valid"
    else:
        return "❌ Password must include at least one uppercase letter, one digit, and one special character"

# Example usage
print(validate_password("Hello@123"))  
print(validate_password("hello123"))   
print(validate_password("HELLO@"))     