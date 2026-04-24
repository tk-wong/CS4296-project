import requests
from PIL import Image
import io

# 1. Set up the request
url = "https://ilhgcmtt7kijaoc3zq656pmmre0uhymz.lambda-url.us-east-1.on.aws/image"
with open ("image.jpg", "rb") as f:
    files = {'image': ("upload.jpeg", f.read(), "image/jpeg")}
    image = Image.open(f)
    image_type = image.format
    print(f"Image format send the API: {image_type}")
    print(f"Dimensions: {image.size[0]}x{image.size[1]} pixels")
    

# 2. Call API
    response = requests.post(url, files=files, timeout=60)

# 3. Display metadata clearly for the video
print(f"=== API Response Received ===")
print(f"Status Code: {response.status_code}")
if response.status_code != 200:
    print(f"Error: {response.text}")
    exit(1)
print(f"Content-Type: {response.headers.get('Content-Type')}")
print(f"File Size: {len(response.content) / 1024:.2f} KB")

# 4. Save and inspect
with open("output.png", "wb") as f:
    f.write(response.content)

img = Image.open("output.png")
print(f"Dimensions: {img.size[0]}x{img.size[1]} pixels")
print(f"Image format in the response: {img.format}")