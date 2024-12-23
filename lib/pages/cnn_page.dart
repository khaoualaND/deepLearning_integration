import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CnnPage extends StatefulWidget {
  @override
  CnnPageState createState() => CnnPageState();
}

class CnnPageState extends State<CnnPage> {
  Uint8List? _imageBytes; // For storing image bytes
  String _classificationResult = 'No result yet';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes; // Store the image as bytes
      });
    }
  }

  Future<void> _uploadAndClassify() async {
    if (_imageBytes == null) {
      setState(() {
        _classificationResult = 'Please select an image first!';
      });
      return;
    }

    final Uri uri = Uri.parse('http://192.168.1.215:5000/classify_cnn'); // Flask server URL

    try {
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _imageBytes!,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'), // Specify content type here
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> result = jsonDecode(responseData);

        setState(() {
          if (result.containsKey('label')) {
            _classificationResult = 'Classification: ${result['label']}';
          } else {
            _classificationResult = 'Error: ${result['error']}';
          }
        });
      } else {
        setState(() {
          _classificationResult = 'Failed to classify the image.';
        });
      }
    } catch (e) {
      setState(() {
        _classificationResult = 'Error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Classification'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display selected image
              _imageBytes != null
                  ? Image.memory(_imageBytes!, width: 200, height: 200)
                  : const Icon(Icons.image, size: 200, color: Colors.grey),

              const SizedBox(height: 20),

              // Classification result text
              Text(
                _classificationResult,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Buttons for image selection and classification
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _uploadAndClassify,
                    child: const Text('Classify Image'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
