// lib/users_login.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Import Facebook Auth
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

import 'users_sign_up.dart'; // Ensure this is the correct path to your SignUpScreen
import 'home.dart';           // Ensure this is the correct path to your HomeScreen
import 'forgetpassword.dart'; // Ensure this is the correct path to your ForgetPasswordScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  final TextEditingController _emailController = TextEditingController(); // Renamed for clarity for Firebase Email Auth
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Animation Controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Start slightly below
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward(); // Start animations on screen load
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // --- Firebase Email/Password Login ---
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) { // Validate all form fields first
      _showSnackBar('Logging in... Please wait...', Colors.blueAccent); // Indicate loading

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        debugPrint('Firebase User Logged In: ${userCredential.user?.email}');
        _showSnackBar('Login successful!', Colors.green);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Too many login attempts. Try again later.';
        } else {
          errorMessage = 'Login failed: ${e.message}';
        }
        debugPrint('Firebase Auth Error: $errorMessage');
        _showSnackBar(errorMessage, Colors.red[800]!); // Show error to user
      } catch (e) {
        debugPrint('General Login Error: $e');
        _showSnackBar('An unexpected error occurred. Please try again.', Colors.red[800]!);
      }
    }
  }

  // --- Facebook Login Integration with Firebase ---
  Future<void> _signInWithFacebook() async {
    _showSnackBar('Initiating Facebook login...', Colors.blueAccent);
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        debugPrint('Facebook Access Token: ${accessToken.token}');

        // Authenticate with Firebase using Facebook credential
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token!);
        await FirebaseAuth.instance.signInWithCredential(credential);

        final userData = await FacebookAuth.instance.getUserData();
        debugPrint('Facebook User Data: $userData');

        _showSnackBar('Logged in with Facebook and Firebase: ${userData['name']}', Colors.green);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        _showSnackBar('Facebook login cancelled.', Colors.orange);
        debugPrint('Facebook login cancelled.');
      } else {
        _showSnackBar('Facebook login failed: ${result.message}', Colors.red[800]!);
        debugPrint('Facebook login failed: ${result.message}');
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error with Facebook: $e');
      _showSnackBar('Firebase linking failed: ${e.message}', Colors.red[800]!);
    } catch (e) {
      debugPrint('Error during Facebook login: $e');
      _showSnackBar('Error during Facebook login: $e', Colors.red[800]!);
    }
  }

  // --- Google Sign-In Integration with Firebase ---
  Future<void> _signInWithGoogle() async {
    _showSnackBar('Initiating Google sign-in...', Colors.blueAccent);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        _showSnackBar('Google sign-in cancelled.', Colors.orange);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      _showSnackBar('Logged in with Google and Firebase: ${googleUser.displayName}', Colors.green);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error with Google: $e');
      _showSnackBar('Firebase linking failed: ${e.message}', Colors.red[800]!);
    } catch (e) {
      debugPrint('Error during Google login: $e');
      _showSnackBar('Error during Google login: $e', Colors.red[800]!);
    }
  }

  void _navigateToSignUp() {
    debugPrint("Navigating to Sign Up Screen");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _forgotPassword() {
    debugPrint("Navigating to Forget Password Screen");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form( // Wrap with Form for validation
              key: _formKey, // Assign the GlobalKey
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/waves_of_food_logo.png', // Keep your logo asset
                      height: 120,
                      width: 120,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.fastfood, size: 120, color: Colors.red[700]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Waves Of Food',
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Your Culinary Journey Starts Here',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    'Log In To Your Account',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _buildTextField(
                    controller: _emailController, // Using the new email controller
                    hintText: 'Email Address', // Clearly state it's for email
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      // Basic email format validation
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isVisible: _isPasswordVisible,
                    toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _forgotPassword,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: double.infinity,
                    child: Hero(
                      tag: 'loginButton',
                      child: ElevatedButton(
                        onPressed: _login, // This now calls the Firebase login function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 8,
                          shadowColor: Colors.red.withOpacity(0.4),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  GestureDetector(
                    onTap: _navigateToSignUp,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign Up Now!',
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.red[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.grey, thickness: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signInWithFacebook, // Facebook login
                          icon: Image.asset(
                            'assets/facebook_logo.png', // Make sure you have this asset
                            height: 26,
                            width: 26,
                            errorBuilder: (c, e, s) => const Icon(Icons.facebook, size: 26, color: Colors.white),
                          ),
                          label: const Text('Facebook',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2), // Facebook blue
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 18.0),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _signInWithGoogle, // Google login
                          icon: Image.asset(
                            'assets/google_logo.png', // Make sure you have this asset
                            height: 26,
                            width: 26,
                            errorBuilder: (c, e, s) => Text("G", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                          ),
                          label: Text('Google',
                              style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey[300]!, width: 1.5)),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  const Text('Crafted with passion by',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 13)),
                  const Text('NeatRoots Technologies',
                      style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text input fields
  // Now takes a validator function
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade300)
      ),
      child: TextFormField( // Changed to TextFormField for validation
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        ),
        validator: validator, // Assign the validator
      ),
    );
  }

  // Helper method to build password input fields
  // Now takes a validator function
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
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade300)
      ),
      child: TextFormField( // Changed to TextFormField for validation
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: Icon(Icons.lock_rounded, color: Colors.grey.shade600, size: 24),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                color: Colors.grey.shade600, size: 24),
            onPressed: toggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        ),
        validator: validator, // Assign the validator
      ),
    );
  }
}

extension on AccessToken {
  get token => null;
}