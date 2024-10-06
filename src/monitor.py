import numpy as np
import pandas as pd

def detect_drift(new_data, reference_data):
    """Compares the distribution of new data against reference data to detect drift."""
    new_mean = np.mean(new_data)
    reference_mean = np.mean(reference_data)
    
    drift_detected = abs(new_mean - reference_mean) > 0.1 * reference_mean
    return drift_detected

if __name__ == "__main__":
    # Example of drift detection logic:
    new_data = pd.read_csv('data/raw/sales_data.csv')['sales']
    reference_data = pd.read_csv('data/processed/cleaned_sales_data.csv')['sales']
    
    drift = detect_drift(new_data, reference_data)
    if drift:
        print("Data drift detected.")
    else:
        print("No data drift detected.")
