import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';

class VoiceRecognitionPage extends StatefulWidget {
  @override
  _VoiceRecognitionPageState createState() => _VoiceRecognitionPageState();
}

class _VoiceRecognitionPageState extends State<VoiceRecognitionPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _transcribedText = 'Tap the button and start speaking';
  String _responseText = '';
  late GenerativeModel _model;
  final String _apiKey = 'AIzaSyAgzvusIUMcY98ba-Jbo8CGHeOJgZ9TiOY';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _transcribedText = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      await _sendToGeminiAPI(_transcribedText);
    }
  }

  Future<void> _sendToGeminiAPI(String prompt) async {
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      setState(() {
        _responseText = response.text!;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Failed to generate response: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Recognition'),
        backgroundColor: Colors.deepPurple.shade100,
        elevation: 0,
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom rounded mic button
              GestureDetector(
                onTap: _listen,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _isListening ? 90 : 120,
                  height: _isListening ? 90 : 120,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.shade300,
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Tap the mic to speak',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade900,
                ),
              ),
              SizedBox(height: 24),
              // Transcribed text container with a rounded border and gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _transcribedText,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              // Response text container with shadow and rounded corners
              Container(
                width: double.infinity,
                height: 150,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade100,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _responseText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
