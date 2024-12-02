import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String errorMessage = '';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    String name = _name.text.trim();
    String email = _email.text.trim();
    String password = _password.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields';
      });
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Update the user's display name
        await user.updateDisplayName(name);

        // Reload the user to ensure the display name is updated
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              name: user?.displayName ?? "User Name",
              email: user?.email ?? "user@example.com",
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'email-already-in-use') {
        setState(() {
          errorMessage = 'This email is already in use.';
        });
      } else if (e.code == 'weak-password') {
        setState(() {
          errorMessage = 'Password is too weak.';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to sign up. Please try again.';
        });
      }
    } catch (e) {
      // Handle generic errors
      setState(() {
        errorMessage = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), backgroundColor: Colors.pinkAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name Field
              TextField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.pinkAccent),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                  ),
                  prefixIcon: const Icon(Icons.email, color: Colors.pinkAccent),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.pinkAccent),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.pinkAccent),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
