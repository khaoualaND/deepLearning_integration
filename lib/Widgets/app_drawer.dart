import 'package:flutter/material.dart';
import '../pages/stock.dart';  // Ensure this is correctly imported
import '../pages/voice_recognition_page.dart';
import '../pages/cnn_page.dart';
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
          // Header with User Info
          UserAccountsDrawerHeader(
            accountName: Text(
              name.isNotEmpty ? name : 'Guest User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email.isNotEmpty ? email : 'guest@example.com',
              style: const TextStyle(fontSize: 16),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade300, Colors.pink.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
              ),
            ),
          ),

          // Navigation Section: Image Classification
          ExpansionTile(
            leading: const Icon(Icons.image, color: Colors.deepPurple),
            title: const Text("Image Classification"),
            subtitle: const Text("Fashion MNIST", style: TextStyle(fontSize: 14)),
            children: [
              ListTile(
                title: const Text("ANN", style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnnPage()),
                  );
                },
              ),
              ListTile(
                title: const Text("CNN", style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CnnPage()),
                  );
                },
              ),
            ],
          ),

          // Stock Price Prediction
          ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text("Stock Price Prediction", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StockPredictionPage()), // Corrected navigation
              );
            },
          ),

          // Voice Recognition
          ListTile(
            leading: const Icon(Icons.mic, color: Colors.purple),
            title: const Text("Voice Recognition", style: TextStyle(fontSize: 16)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VoiceRecognitionPage()),
              );
            },
          ),

          // Rag Section
          ListTile(
            leading: const Icon(Icons.lightbulb, color: Colors.orange),
            title: const Text("Rag", style: TextStyle(fontSize: 16)),
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
