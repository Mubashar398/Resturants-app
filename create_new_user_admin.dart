// create_new_user_admin.dart
import 'package:flutter/material.dart';

class CreateNewUserAdminScreen extends StatefulWidget {
  const CreateNewUserAdminScreen({super.key});

  @override
  State<CreateNewUserAdminScreen> createState() => _CreateNewUserAdminScreenState();
}

class _CreateNewUserAdminScreenState extends State<CreateNewUserAdminScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935); // A red color similar to the image

    return Scaffold(
      backgroundColor: Colors.white, // White background as per image
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // No shadow under the app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) { // Good practice to check if canPop
              Navigator.of(context).pop();
            }
          },
        ),
        // No title in the app bar based on the screenshot
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              // Logo
              Image.asset(
                'assets/waves_of_food_logo.png', // <<< ENSURE 'assets/waves_of_food_logo.png' IS CORRECT
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 16),

              // Waves Of Food Text
              const Text(
                'Waves Of Food',
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat', // <<< ENSURE 'Montserrat' FONT IS SET UP
                ),
              ),
              const SizedBox(height: 8),

              // Create New User Admin Text
              const Text(
                'Create New User Admin',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              // Name TextField
              _buildTextField(
                controller: _nameController,
                hintText: 'Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),

              // Email or Phone Number TextField
              _buildTextField(
                controller: _emailPhoneController,
                hintText: 'Email or Phone Number',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password TextField
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 40),

              // Create New User Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle create new user logic
                    print('Create New User button pressed');
                    print('Name: ${_nameController.text}');
                    print('Email/Phone: ${_emailPhoneController.text}');
                    print('Password: ${_passwordController.text}');
                    // Add further logic like form validation and API calls here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Create New User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Space before footer

              // Design By NeatRoots
              Column(
                children: [
                  Text(
                    'Design By',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Text(
                    'NeatRoots',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                      fontFamily: 'Montserrat', // <<< ENSURE 'Montserrat' FONT IS SET UP
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for common text field styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}