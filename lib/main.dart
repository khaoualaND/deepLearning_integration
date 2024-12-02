import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/login_page..dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCH4BgrQpS_7HOBjjNNWMMe4gEYvz-hKro",
            authDomain: "flutter-project-a4236.firebaseapp.com",
            projectId: "flutter-project-a4236",
            storageBucket: "flutter-project-a4236.firebasestorage.app",
            messagingSenderId: "599370555753",
            appId: "1:599370555753:web:c868496d798a025aae9df8"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginPage(), // Set LoginPage as the home
    );
  }
}
