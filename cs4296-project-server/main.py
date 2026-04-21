from PIL.Image import Resampling
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import Response
from mangum import Mangum
import io
from PIL import Image

app = FastAPI()
handler = Mangum(app)

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/image/")
async def covert_image(image:UploadFile = File(...)):
    accept_type = ["image/jpeg"]
    if image.content_type not in accept_type:
        raise HTTPException(status_code=400, detail="Invalid image type")
    uploaded_image = Image.open(image.file)
    uploaded_image.thumbnail((300,300), Resampling.LANCZOS)
    final_image = io.BytesIO()
    uploaded_image.save(final_image, "png")
    final_image.seek(0)
    return Response(content=final_image.getvalue(), media_type="image/png")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)