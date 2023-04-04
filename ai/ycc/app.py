from flask import Flask, request, jsonify
from proj_pill.proj_pill.main_cls01_dir import *
from proj_pill.proj_pill.ocr_prescription import *
from proj_pill.proj_pill.new_prediction import *
from PIL import Image
import os

app = Flask(__name__)

@app.route('/run/os')
def check_os():
    return os.name

@app.route('/run/prescription', methods=['POST'])
def prescription_ocr():
    image = request.files['image']
    image = Image.open(image)

    ocr_result = run_ocr_model(image)

    print(ocr_result)
    return jsonify(ocr_result)

@app.route('/run/predict', methods=['POST'])
def predict_images():
    image = request.files['image']
    pil_image = Image.open(image)
    
    prediction = run_search_model(pil_image)

    print(prediction)
    return jsonify(prediction)

@app.route('/run/new_predict', methods=['POST'])
def new_predict_image():
    image = request.files['image']
    image = Image.open(image)

    ocr_result = run_predict_model(image)

    print(ocr_result)
    return jsonify(ocr_result)

if __name__ == '__main__':
    app.run(host='0.0.0.0',
            port=8090)