import requests
from PIL import Image
import io

# 1. Setup the request
url = "YOUR_SERVERLESS_FUNCTION_URL"
files = {'image': open('input.jpg', 'rb')}

# 2. Call API
response = requests.post(url, files=files)

# 3. Display metadata clearly for the video
print(f"--- API Response Received ---")
print(f"Content-Type: {response.headers.get('Content-Type')}")
print(f"File Size: {len(response.content) / 1024:.2f} KB")

# 4. Save and inspect
with open("output.png", "wb") as f:
    f.write(response.content)

img = Image.open("output.png")
print(f"Dimensions: {img.size[0]}x{img.size[1]} pixels")