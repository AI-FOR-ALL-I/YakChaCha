from flask import Flask, request, jsonify
from proj_pill.proj_pill.main_cls01_dir import *
from PIL import Image

app = Flask(__name__)

@app.route('/')
@app.route('/home')
def home():
    return 'Hello world'

@app.route('/pill_search')
def pill_search():
    return run_search_model()

@app.route('/predict', methods=['POST'])
def predict_images():
    list_test_image = request.files.getlist('image')

    prediction = run_prediction_model_1(list_test_image)
    return jsonify({'prediction': prediction.tolist()})

if __name__ == '__main__':
    app.run(host='0.0.0.0',
            port=8090)