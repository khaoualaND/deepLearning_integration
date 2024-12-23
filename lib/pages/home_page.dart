import 'package:flutter/material.dart';
import '../Widgets/app_drawer.dart'; // Import the AppDrawer
import '../pages/voice_recognition_page.dart'; // Add other pages

class HomePage extends StatelessWidget {
  final String name;
  final String email;

  const HomePage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.deepPurple.shade300, // Matching with AppDrawer
      ),
      drawer: AppDrawer(name: name, email: email), // Pass name and email to AppDrawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 20),
              Text(
                "Welcome, $name!",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              Text(
                "You're logged in as $email",
                style: const TextStyle(fontSize: 16, color: Colors.black45),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Voice Recognition Page or any other functionality
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  VoiceRecognitionPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade200,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Start Voice Recognition', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
