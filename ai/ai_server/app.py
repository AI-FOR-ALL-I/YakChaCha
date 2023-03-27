from flask import Flask, request, jsonify
from proj_pill.proj_pill.main_cls01_dir import run_search_model

app = Flask(__name__)

@app.route('/')
@app.route('/home')
def home():
    return 'Hello world'

@app.route('/pill_search')
def pill_search():
    return run_search_model()

if __name__ == '__main__':
    app.run(debug=True, port=80)