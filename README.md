# copulas_r_backend

see https://arxiv.org/pdf/2305.06961.pdf


```
import requests
import numpy as np
import json

# Create numpy arrays
U1 = np.array([0.1, 0.2, 0.3])
U2 = np.array([0.4, 0.5, 0.6])
key = "my_model2"

U1_str = ",".join(map(str, U1))
U2_str = ",".join(map(str, U2))

# Prepare data for POST request
data = {
    "U1": U1_str,
    "U2": U2_str,
    "key": key
}

# Make a POST request to the /predict endpoint
response = requests.post("http://localhost:8000/train", data=json.dumps(data))

# Print the response
print(response.json())

# If the response is successful and the model was created,
# you can use it to make a prediction:

data = {
    "U1": U1_str,
    "U2": U2_str,
    "key": key
}

response = requests.post("http://localhost:8000/predict", data=json.dumps(data))

print(response.json())
```
