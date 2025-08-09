from fastapi import FastAPI, Request
import requests
import os
import json

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

@app.post("/mcp")
async def mcp_handler(request: Request):
    payload = await request.json()
    method = payload.get("method")
    req_id = payload.get("id")

    if method == "initialize":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "protocolVersion": "2024-11-05",
                "capabilities": {
                    "tools": True
                },
                "serverInfo": {
                    "name": "Weather MCP Server",
                    "version": "1.0.0"
                }
            }
        }

    elif method == "list_tools":
        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "tools": [
                    {
                        "name": "getWeather",
                        "description": "Get the current weather for a city",
                        "parameters": {
                            "type": "object",
                            "properties": {
                                "city": {
                                    "type": "string",
                                    "description": "Name of the city"
                                }
                            },
                            "required": ["city"]
                        }
                    }
                ]
            }
        }

    elif method == "call_tool":
        params = payload.get("params", {})
        name = params.get("name")
        args = params.get("arguments", {})

        if name == "getWeather":
            city = args.get("city")
            result = get_weather(city)
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {"content": result}
            }

    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "error": {"code": -32601, "message": "Method not found"}
    }
