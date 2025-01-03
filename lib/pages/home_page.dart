import 'package:flutter/material.dart';
import 'package:flutter_project/pages/ann_page.dart';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Home Icon
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: const Icon(Icons.home, size: 120, color: Colors.deepPurple),
                ),
                // Welcome Text
                Text(
                  "Welcome, $name!",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "You're logged in as $email",
                  style: const TextStyle(fontSize: 16, color: Colors.black45),
                ),
                const SizedBox(height: 30),

                // Image Classification Intro Text
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Explore Image Classification with ANN and CNN",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "Artificial Neural Networks (ANN) and Convolutional Neural Networks (CNN) are powerful tools used for classifying images.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "With ANN, we recognize objects based on learned patterns, while CNN is specifically designed for processing visual data. Both models excel at classifying objects in images.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade500,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Button to Voice Recognition Page
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Voice Recognition Page or any other functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VoiceRecognitionPage()),
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
                const SizedBox(height: 20),
                // Button to Image Classification Page (Navigating to AnnPage)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnnPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Image Classification', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
