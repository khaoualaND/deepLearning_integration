import tensorflow as tf
from flask import Flask, request, jsonify
import yfinance as yf
import numpy as np
from sklearn.preprocessing import MinMaxScaler

app = Flask(__name__)

# Load the TensorFlow Lite model
interpreter = tf.lite.Interpreter(model_path=r"C:\Users\HP\Documents\DeepLearning\flutter\flutter_project\assets\models\stock_prediction_model.tflite")

# Allocate tensors (this is necessary to initialize the interpreter)
interpreter.allocate_tensors()

# Get input and output tensor details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Function to prepare data
def prepare_data(data, time_step=60):
    X, Y = [], []
    for i in range(len(data) - time_step - 1):
        X.append(data[i:i + time_step, 0])
        Y.append(data[i + time_step, 0])
    return np.array(X), np.array(Y)

@app.route('/predict', methods=['POST'])
def predict_stock():
    stock_symbol = request.json['symbol']
    stock_data = yf.download(stock_symbol, start="2010-01-01", end="2023-12-31")

    # Use only the 'Close' prices
    data = stock_data[['Close']]

    # Normalize the data
    scaler = MinMaxScaler(feature_range=(0, 1))
    scaled_data = scaler.fit_transform(data)

    # Prepare the data for prediction
    time_step = 60
    X, _ = prepare_data(scaled_data, time_step)

    # Reshape X for LSTM input
    X = X.reshape(X.shape[0], X.shape[1], 1)

    # Set input tensor and invoke the model
    interpreter.set_tensor(input_details[0]['index'], X[-1].reshape(1, time_step, 1).astype(np.float32))
    interpreter.invoke()

    # Get the predicted price from the output tensor
    predicted_price = interpreter.get_tensor(output_details[0]['index'])

    # Inverse transform the predicted value
    predicted_price = scaler.inverse_transform(predicted_price)

    return jsonify({'predicted_price': predicted_price[0][0]})

if __name__ == '__main__':
    app.run(debug=True)
