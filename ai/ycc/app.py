from flask import Flask, request, jsonify, render_template
from proj_pill.proj_pill.main_cls01_dir import *
from proj_pill.proj_pill.ocr_prescription import *

app = Flask(__name__)

@app.route('/run/os')
def check_os():
    return os.name

@app.route('/run/prescription', methods=['POST'])
def prescription_ocr():
    image = request.files['image']
    
    temp_dir = r'./proj_pill/proj_pill/dir_prescription'
    os.makedirs(temp_dir, exist_ok=True)
    image.save(os.path.join(temp_dir, f'imagefile.png'))
            
    prediction = run_ocr_model()

    for file in os.listdir(temp_dir):
        os.remove(os.path.join(temp_dir, file))
    
    print(prediction)
    return jsonify({'prediction': prediction})

@app.route('/run/predict', methods=['POST'])
def predict_images():
    image = request.files['image']
    
    temp_dir = r'./proj_pill/proj_pill/dir_testimage'
    os.makedirs(temp_dir, exist_ok=True)
    image.save(os.path.join(temp_dir, f'imagefile.png'))
            
    prediction = run_search_model()

    for file in os.listdir(temp_dir):
        os.remove(os.path.join(temp_dir, file))
    
    print(prediction)
    return jsonify(prediction)

if __name__ == '__main__':
    app.run(host='0.0.0.0',
            port=8090)