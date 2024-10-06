from src.train import train_model
import os

def test_train_model():
    train_model('data/processed/cleaned_sales_data.csv', 'models/test_model.joblib')
    assert os.path.exists('models/test_model.joblib')