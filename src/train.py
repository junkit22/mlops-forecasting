import boto3
import joblib
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error

def train_model(data_path, model_path):
    df = pd.read_csv(data_path)
    
    # Split data into features and target
    X = df.drop(columns=['sales'])
    y = df['sales']
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    
    # Train Random Forest model
    model = RandomForestRegressor(n_estimators=100)
    model.fit(X_train, y_train)
    
    # Evaluate the model
    y_pred = model.predict(X_test)
    mae = mean_absolute_error(y_test, y_pred)
    print(f"Model MAE: {mae}")
    
    # Save the trained model
    joblib.dump(model, model_path)

if __name__ == "__main__":
    # Path to processed data
    train_model('data/processed/cleaned_sales_data.csv', 'models/model.joblib')