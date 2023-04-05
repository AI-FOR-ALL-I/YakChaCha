from flask import Flask, request, jsonify
from proj_pill.proj_pill.ocr_prescription import *
from proj_pill.proj_pill.new_prediction import *
from PIL import Image
import os

app = Flask(__name__)
os.environ['KMP_DUPLICATE_LIB_OK']='True'

@app.route('/run/os')
def check_os():
    return os.name

@app.route('/run/prescription', methods=['POST'])
def prescription_ocr():
    image = request.files['image']
    image = image.read()

    ocr_result = run_ocr_model(image)

    print(ocr_result)
    print('done')
    return jsonify(ocr_result)

@app.route('/run/new_predict', methods=['POST'])
def predict_image():
    image = request.files['image']
    image = Image.open(image)

    predict_result = run_predict_model(image)

    print('done')
    return jsonify(predict_result)

if __name__ == '__main__':
    app.run(host='0.0.0.0',
            port=8090)