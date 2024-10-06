import pandas as pd

def preprocess_data(input_path, output_path):
    df = pd.read_csv(input_path)
    df.dropna(inplace=True)
    df['sales_moving_avg'] = df['sales'].rolling(window=7).mean()
    df['sales'] = (df['sales'] - df['sales'].mean()) / df['sales'].std()
    df.to_csv(output_path, index=False)

if __name__ == "__main__":
    preprocess_data('data/raw/sales_data.csv', 'data/processed/cleaned_sales_data.csv')
