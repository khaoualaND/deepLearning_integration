import 'package:flutter/material.dart';
import '../Widgets/app_drawer.dart'; // Import the AppDrawer

class HomePage extends StatelessWidget {
  final String name;
  final String email;

  const HomePage({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      drawer: AppDrawer(name: name, email: email), // Pass name and email to AppDrawer
      body: Center(
        child: const Text("Welcome to the Home Page!"),
      ),
    );
  }
}
