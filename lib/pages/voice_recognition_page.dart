import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  late String _apiKey;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadApiKey();
  }

  void _loadApiKey() async {
    await dotenv.load();
    setState(() {
      _apiKey = dotenv.env['API_KEY'] ?? '';
      if (_apiKey.isEmpty) {
        _responseText = 'API key not found. Please check your .env file.';
      } else {
        _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: _apiKey,
        );
      }
    });
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
        _responseText = response.text ?? 'No response from Gemini';
      });
    } catch (e) {
      setState(() {
        _responseText = 'Failed to generate response: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recognition'),
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink.shade100,
              child: Icon(
                Icons.mic,
                size: 60,
                color: _isListening ? Colors.green : Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tap to start speaking',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _transcribedText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _responseText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            FloatingActionButton(
              onPressed: _listen,
              backgroundColor: _isListening ? Colors.green.shade400 : Colors.pink.shade100,
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
