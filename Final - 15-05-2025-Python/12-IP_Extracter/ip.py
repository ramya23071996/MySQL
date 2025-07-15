import re

def extract_ips_from_log(file_path):
    try:
        with open(file_path, 'r') as file:
            log_content = file.read()

        # Regex to match IPv4 addresses
        ip_pattern = r"\b\d{1,3}(?:\.\d{1,3}){3}\b"
        ip_addresses = re.findall(ip_pattern, log_content)

        return ip_addresses if ip_addresses else ["No IP addresses found"]

    except FileNotFoundError:
        return ["❌ Log file not found"]
    except Exception as e:
        return [f"❌ An error occurred: {e}"]

# Example usage
ips = extract_ips_from_log("server_log.txt")
print(ips)