import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import 'users_login.dart'; // Ensure this path is correct for your LoginScreen

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // GlobalKey for the Form widget to enable form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Renamed for clarity as Firebase uses email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // --- Firebase Sign-Up Function ---
  Future<void> _signUp() async {
    // Validate all form fields first
    if (_formKey.currentState!.validate()) {
      // Show a loading indicator (SnackBar or CircularProgressIndicator)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creating account... Please wait...')),
      );

      try {
        // Attempt to create a user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), // Use email for Firebase Auth
          password: _passwordController.text.trim(),
        );

        // If user creation is successful, you can access user details
        debugPrint('Firebase User Registered: ${userCredential.user?.email}');

        // Optionally, save additional user data (first name, last name) to Firestore or Realtime Database
        // This is a common practice to store user profiles associated with their Firebase Auth UID.
        // For example, if you have Cloud Firestore set up:
        /*
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(), // Timestamp of creation
        });
        */

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully! Please log in.')),
        );

        // Navigate back to the login screen after successful registration
        if (mounted) {
          Navigator.pop(context); // This assumes SignUpScreen was pushed from LoginScreen
        }

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else {
          errorMessage = 'Sign up failed: ${e.message}';
        }
        debugPrint('Firebase Auth Error: $errorMessage');
        _showSnackBar(errorMessage); // Show the specific error to the user
      } catch (e) {
        debugPrint('General Sign Up Error: $e');
        _showSnackBar('An unexpected error occurred. Please try again.');
      }
    }
  }

  // --- End Firebase Sign-Up Function ---

  void _signInWithFacebook() {
    _showSnackBar('Sign in with Facebook pressed! (Integration needed)');
    // TODO: Implement Facebook login integration
  }

  void _signInWithGoogle() {
    _showSnackBar('Sign in with Google pressed! (Integration needed)');
    // TODO: Implement Google login integration
  }

  void _navigateToLogin() {
    debugPrint('Already Have An Account? Navigating to Login...');
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // If LoginScreen is not directly below, push it and remove all other routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFCCBC),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form( // Wrap your Column with a Form widget
            key: _formKey, // Assign the GlobalKey to the Form
            child: Column(
              children: [
                const SizedBox(height: 72.0),
                // App Logo
                Image.asset(
                  'assets/waves_of_food_logo.png',
                  height: 120,
                  width: 120,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 120, color: Colors.grey);
                  },
                ),
                const SizedBox(height: 16.0),
                // App Name
                const Text(
                  'Waves Of Food',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Slogan
                const Text(
                  'Deliver Favorite Food',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24.0),
                // Sign Up Here Text
                const Text(
                  'Sign Up Here',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),

                // First Name Input
                _buildTextField(
                  controller: _firstNameController,
                  hintText: 'First name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Last Name Input
                _buildTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Email Input (changed from Email or Phone Number for Firebase Auth)
                _buildTextField(
                  controller: _emailController, // Using the new email controller
                  hintText: 'Email Address', // Clearly state it's for email
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Password Input
                _buildPasswordField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isVisible: _isPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Confirm Password Input
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp, // This will now call the Firebase sign-up function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Or Sign Up With Text
                const Text(
                  'or Sign Up With',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Social Sign-Up Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _signInWithFacebook,
                        icon: Image.asset(
                          'assets/facebook_logo.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.facebook, size: 24, color: Colors.white);
                          },
                        ),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B5998),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: Image.asset(
                          'assets/google_logo.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text("G", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF757575)));
                          },
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(color: Color(0xFF757575)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color(0xFFDDDDDD), width: 1)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                // Already Have An Account?
                GestureDetector(
                  onTap: _navigateToLogin,
                  child: const Text(
                    'Already Have An Account?',
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text input fields
  // Now includes validator
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator, // Added validator parameter
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField( // Changed from TextField to TextFormField for validation
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: validator, // Assign the validator
      ),
    );
  }

  // Helper method to build password input fields
  // Now includes validator
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator, // Added validator parameter
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField( // Changed from TextField to TextFormField for validation
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: validator, // Assign the validator
      ),
    );
  }
}