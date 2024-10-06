import joblib
import pandas as pd

def predict(model_path, input_data_path):
    model = joblib.load(model_path)
    input_data = pd.read_csv(input_data_path).drop(columns=['sales'])
    prediction = model.predict(input_data)
    return prediction

if __name__ == "__main__":
    predictions = predict('models/model.joblib', 'data/processed/cleaned_sales_data.csv')
    print(predictions)
