import requests

def convert_currency(amount, from_currency, to_currency):
    url = f"https://open.er-api.com/v6/latest/{from_currency.upper()}"

    try:
        response = requests.get(url)
        data = response.json()

        if data.get("result") == "success":
            rate = data["rates"].get(to_currency.upper())
            if rate:
                converted = amount * rate
                print(f"\n💸 {amount} {from_currency.upper()} = {converted:.2f} {to_currency.upper()}")
            else:
                print(f"⚠️ '{to_currency.upper()}' not found in response.")
        else:
            print("⚠️ Failed to fetch exchange rates.")
    except Exception as e:
        print(f"❌ Request error: {e}")

# Example usage
convert_currency(100, "USD", "INR")