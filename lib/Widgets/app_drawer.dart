import 'package:flutter/material.dart';
import '../pages/voice_recognition_page.dart';
import '../pages/cnn_page.dart'; // Import CNN page
import '../pages/ann_page.dart';

class AppDrawer extends StatelessWidget {
  final String name;
  final String email;

  const AppDrawer({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              name.isNotEmpty ? name : 'Guest User',
              style: const TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              email.isNotEmpty ? email : 'guest@example.com',
              style: const TextStyle(fontSize: 16),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            decoration: const BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.image, color: Colors.blueAccent),
            title: const Text("Image Classification"),
            subtitle: const Text("Fashion Mnist"),
            children: [
              ListTile(
                title: const Text("ANN"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnnPage()),
                  );
                },
              ),
              ListTile(
                title: const Text("CNN"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CnnPage()),
                  );
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text("Stock Price Prediction"),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to Stock Price Prediction screen
            },
          ),
          ListTile(
            leading: Icon(Icons.mic, color: Colors.purple),
            title: Text("Voice Recognition"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VoiceRecognitionPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.orange),
            title: const Text("Rag"),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to Rag screen
            },
          ),
        ],
      ),
    );
  }
}
