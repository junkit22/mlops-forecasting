import joblib
import pandas as pd
from flask import Flask, request, jsonify

app = Flask(__name__)

# Load the model
model = joblib.load('models/model.joblib')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json['data']
    df = pd.DataFrame(data)
    predictions = model.predict(df)
    return jsonify(predictions.tolist())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)