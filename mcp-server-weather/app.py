from fastapi import FastAPI
import requests
import os

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "MCP Server is running"}

@app.get("/weather")
def get_weather(city: str):
    api_key = os.getenv("WEATHER_API_KEY")
    if not api_key:
        return {"error": "WEATHER_API_KEY not set"}

    url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"
    resp = requests.get(url)

    if resp.status_code != 200:
        return {"error": "Could not fetch weather data"}

    data = resp.json()
    return {
        "city": city,
        "temperature": data["main"]["temp"],
        "description": data["weather"][0]["description"]
    }
