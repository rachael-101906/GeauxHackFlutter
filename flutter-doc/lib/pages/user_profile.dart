import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/user.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text("Mike the Tiger"),
              const SizedBox(height: 20),
              Text(FirebaseAuth.instance.currentUser?.email ?? "No User/Email"),
              const SizedBox(height: 20),
              Text("Status: ${currentUserProfile.status}"),
              
              if (currentUserProfile.status > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    currentUserProfile.status,
                    (index) => const Icon(
                      Icons.forest, 
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),
                ),
          
              const SizedBox(height: 30),
              if (FirebaseAuth.instance.currentUser != null)
              ElevatedButton(
                onPressed: _signOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 186, 96, 89),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
