import requests

API_KEY = "5934ae0500410f560a1754d449847867"  
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

def get_weather(city):
    params = {
        "q": city,
        "appid": API_KEY,
        "units": "metric"
    }
    try:
        response = requests.get(BASE_URL, params=params)
        data = response.json()

        if response.status_code == 200:
            print(f"\n🌍 Weather for {city.title()}")
            print("-" * 30)
            print(f"🌡 Temperature : {data['main']['temp']} °C")
            print(f"☁️ Condition   : {data['weather'][0]['description'].title()}")
            print(f"💨 Wind Speed  : {data['wind']['speed']} m/s")
            print(f"🕒 Updated at  : {data['dt']}")
        else:
            print(f"⚠️ Error: {data.get('message', 'Failed to fetch weather data')}")

    except Exception as e:
        print(f"❌ Request failed: {e}")

# Example usage
get_weather("Coimbatore")