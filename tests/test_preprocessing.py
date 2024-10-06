import pandas as pd
from src.preprocessing import preprocess_data

def test_preprocessing():
    data = {'sales': [200, 300, 400, None, 500]}
    df = pd.DataFrame(data)
    preprocess_data(df, 'data/processed/test_cleaned_data.csv')
    processed_df = pd.read_csv('data/processed/test_cleaned_data.csv')
    assert processed_df.isnull().sum().sum() == 0