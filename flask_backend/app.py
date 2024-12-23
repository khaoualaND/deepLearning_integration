from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
from PIL import Image
import io
from flask_cors import CORS  # Add this import to enable CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the ANN TFLite model
ann_interpreter = tf.lite.Interpreter(model_path=r"C:\Users\HP\Documents\DeepLearning\flutter\flutter_project\assets\models\ann_model.tflite")
ann_interpreter.allocate_tensors()

# Load the CNN TFLite model
cnn_interpreter = tf.lite.Interpreter(model_path=r"C:\Users\HP\Documents\DeepLearning\flutter\flutter_project\assets\models\cnn_model.tflite")
cnn_interpreter.allocate_tensors()

# Define the input and output details for both models
ann_input_details = ann_interpreter.get_input_details()
ann_output_details = ann_interpreter.get_output_details()

cnn_input_details = cnn_interpreter.get_input_details()
cnn_output_details = cnn_interpreter.get_output_details()

# Define labels (this should match the order of the training classes)
labels = [
    "Apple", "Banana", "Avocado", "Cherry", "Kiwi", "Mango", 
    "Orange", "Pineapple", "Strawberry", "Watermelon"
]

# ANN Classification Route
@app.route('/classify_ann', methods=['POST'])
def classify_ann():
    try:
        image_file = request.files['image']
        if not image_file:
            return jsonify({'error': 'No image provided'}), 400

        image = Image.open(io.BytesIO(image_file.read()))
        image = image.resize((64, 64))  # Resize to ANN model input size
        image_array = np.array(image)
        image_array = image_array / 255.0  # Normalize the image
        image_array = np.expand_dims(image_array, axis=0)

        # Run inference on the ANN model
        ann_interpreter.set_tensor(ann_input_details[0]['index'], image_array.astype(np.float32))
        ann_interpreter.invoke()

        output = ann_interpreter.get_tensor(ann_output_details[0]['index'])
        label_index = np.argmax(output[0])  # Get the predicted label index
        label_name = labels[label_index]

        return jsonify({'label': label_name})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# CNN Classification Route
@app.route('/classify_cnn', methods=['POST'])
def classify_cnn():
    try:
        image_file = request.files['image']
        if not image_file:
            return jsonify({'error': 'No image provided'}), 400

        image = Image.open(io.BytesIO(image_file.read()))
        image = image.convert('RGB')  # Ensure RGB
        image = image.resize((150, 150))  # Resize to match model input size
        image_array = np.array(image)
        image_array = image_array / 255.0  # Normalize
        image_array = np.expand_dims(image_array, axis=0)  # Add batch dimension

        # Run inference on CNN model
        cnn_interpreter.set_tensor(cnn_input_details[0]['index'], image_array.astype(np.float32))
        cnn_interpreter.invoke()

        # Get model output
        output = cnn_interpreter.get_tensor(cnn_output_details[0]['index'])
        label_index = np.argmax(output[0])  # Get predicted label index
        label_name = labels[label_index]

        return jsonify({'label': label_name})

    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
