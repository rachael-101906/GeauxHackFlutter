import 'dart:developer';
import '../components/auth_service.dart';
import 'login_page.dart';
import 'home_page.dart';
import '../components/button.dart';
import '../components/textfield.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/intro_picture.jpeg'), 
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Logo
                      InkWell(
                        onTap: () => goToHome(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            'assets/images/ecoeden.jpeg',
                            height: 80,
                            width: 270,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Signup Card
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 218, 236, 198).withOpacity(0.95),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF232D25),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF232D25),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Join EcoEden to help endangered species",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Name Field
                            CustomTextField(
                              hint: "Enter Name",
                              label: "Name",
                              controller: _name,
                            ),
                            const SizedBox(height: 16),
                            
                            // Email Field
                            CustomTextField(
                              hint: "Enter Email",
                              label: "Email",
                              controller: _email,
                            ),
                            const SizedBox(height: 16),
                            
                            // Password Field
                            CustomTextField(
                              hint: "Enter Password",
                              label: "Password",
                              isPassword: true,
                              controller: _password,
                            ),
                            const SizedBox(height: 24),
                            
                            // Signup Button
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                label: "Sign Up",
                                onPressed: _signup,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: Color(0xFF232D25),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => goToLogin(context),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Color(0xFF232D25),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

  _signup() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Successfully");
      goToHome(context);
    }
  }
}