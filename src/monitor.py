from prometheus_client import Counter, start_http_server

# Start Prometheus metrics server on port 8000
start_http_server(8000)

# Counter to track the number of predictions made
prediction_counter = Counter('predictions_total', 'Total number of predictions made')

def increment_counter():
    prediction_counter.inc()

# Example of how to use the counter
if __name__ == "__main__":
    increment_counter()
    print("Metrics exposed on port 8000.")