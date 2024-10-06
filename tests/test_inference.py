from src.inference import predict

def test_inference():
    predictions = predict('models/model.joblib', 'data/processed/cleaned_sales_data.csv')
    assert len(predictions) > 0