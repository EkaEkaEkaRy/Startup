from unittest import result
from PIL import Image
from ultralytics import YOLO

class Tracker:
    
    def __init__(self, default_model_name = "yolov8n-seg.pt"):
        self.load(default_model_name)
        
    def load(self, model_path):
        self.model = YOLO(model_path)
        
    def train(self, epochs=25):
        self.model.train(data="config.yaml", epochs=epochs, workers=0)
        
    def test(self, in_image_path="../test/in.jpg", out_image_path="../test/out.jpg"):
        results = self.model.predict([in_image_path])
        for result in results:
            result.save(filename=out_image_path)
            
    def track(self, image : Image):
        results = self.model.predict(image)
        
        return results[0]
        

if __name__ == '__main__':
    tracker = Tracker()
    tracker.train()