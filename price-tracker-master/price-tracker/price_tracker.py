from io import BytesIO
from PIL import Image
from tracker import Tracker
from food import Food

food = Food()
tracker = Tracker()

tracker.load("best.pt")

from fastapi import FastAPI, Form, Response, UploadFile, File
from starlette.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, HTMLResponse, JSONResponse, RedirectResponse, PlainTextResponse
from fastapi.staticfiles import StaticFiles
from typing import Annotated
app = FastAPI()

origins = [
    "http://localhost",
    "https://localhost",
    "http://localhost:8080"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.get("/")
def read_root():
    return FileResponse("./public/index.html", media_type="text/html; charset=utf-8")


@app.get("/price")
def get_price(class_name):
    return food.get_price(class_name)

@app.post("/track")
async def track_upload_file(image : UploadFile = Form()):
    image_bytes = image.file.read()
    image_stream = BytesIO(image_bytes)
    imageFile = Image.open(image_stream)
    results = tracker.track(imageFile)
    
    return JSONResponse(content=results.tojson())


