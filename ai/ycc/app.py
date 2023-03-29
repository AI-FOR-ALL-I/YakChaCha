from flask import Flask, request, jsonify, render_template
from proj_pill.proj_pill.main_cls01_dir import *
from PIL import Image

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict_images():
    list_test_image = request.files.getlist('image')
    
    temp_dir = r'./proj_pill/proj_pill/dir_testimage'
    os.makedirs(temp_dir, exist_ok=True)
    
    for i, file in enumerate(list_test_image):
        print(os.path.join(temp_dir, f'image_{i}.png'))
        file.save(os.path.join(temp_dir, f'image_{i}.png'))
        
    prediction = run_search_model()

    for file in os.listdir(temp_dir):
        os.remove(os.path.join(temp_dir, file))
    
    print(prediction)
    return jsonify({'prediction': prediction})

if __name__ == '__main__':
    app.run(host='0.0.0.0',
            port=8090)