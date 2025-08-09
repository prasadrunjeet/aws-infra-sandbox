# Build image
docker build -t mcp-server .

# Run with your weather API key
docker run -d -p 8000:8000 --name mcpserver-v-1.0.0 \
  -e WEATHER_API_KEY=your_openweathermap_api_key \
  mcp-server
