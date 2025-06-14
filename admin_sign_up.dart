import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class AdminsignupWidget extends StatefulWidget {
  const AdminsignupWidget({super.key});

  @override
  State<AdminsignupWidget> createState() => _AdminsignupWidgetState();
}

class _AdminsignupWidgetState extends State<AdminsignupWidget> with SingleTickerProviderStateMixin {
  String? _selectedLocation; // Holds the selected value for the dropdown
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false; // Added for confirm password visibility

  final _formKey = GlobalKey<FormState>(); // For form validation

  // Controllers for input fields
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _restaurantNameController = TextEditingController();
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Added confirm password controller

  // Define your font families (ensure they are in pubspec.yaml and assets)
  static const String yeonSungFont = 'Yeon Sung';
  static const String latoFont = 'Lato';

  // Animation controllers
  late AnimationController _textAnimationController;
  late Animation<double> _textScaleAnimation;

  // List of 100+ countries
  final List<String> _countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda',
    'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas',
    'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin',
    'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei',
    'Bulgaria', 'Burkina Faso', 'Burundi', 'Cabo Verde', 'Cambodia', 'Cameroon',
    'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia',
    'Comoros', 'Congo (Congo-Brazzaville)', 'Costa Rica', 'Croatia', 'Cuba',
    'Cyprus', 'Czechia (Czech Republic)', 'Democratic Republic of the Congo',
    'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Ecuador', 'Egypt',
    'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini (formerly Swaziland)',
    'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany',
    'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana',
    'Haiti', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq',
    'Ireland', 'Israel', 'Italy', 'Ivory Coast', 'Jamaica', 'Japan', 'Jordan',
    'Kazakhstan', 'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia',
    'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
    'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands',
    'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia',
    'Montenegro', 'Morocco', 'Mozambique', 'Myanmar (formerly Burma)', 'Namibia', 'Nauru',
    'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea',
    'North Macedonia (formerly Macedonia)', 'Norway', 'Oman', 'Pakistan', 'Palau',
    'Palestine State', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines',
    'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis',
    'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino',
    'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles',
    'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia',
    'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan',
    'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania',
    'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia',
    'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates',
    'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City',
    'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
  ];


  @override
  void initState() {
    super.initState();
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.elasticOut, // A bouncy, playful curve
      ),
    );

    _textAnimationController.forward();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _ownerNameController.dispose();
    _restaurantNameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _textAnimationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  // --- Firebase Registration Function ---
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location.')),
        );
        return;
      }

      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registering... Please wait...')),
      );

      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailPhoneController.text.trim(), // Use trim to remove leading/trailing spaces
          password: _passwordController.text.trim(),
        );

        debugPrint("Firebase User Registered: ${credential.user?.email}");

        // Optionally, you can store other user data in Firestore or Realtime Database here
        // For example:
        // FirebaseFirestore.instance.collection('admins').doc(credential.user!.uid).set({
        //   'ownerName': _ownerNameController.text,
        //   'restaurantName': _restaurantNameController.text,
        //   'email': _emailPhoneController.text,
        //   'location': _selectedLocation,
        //   'registrationDate': FieldValue.serverTimestamp(),
        // });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! You can now log in.')),
        );

        // Navigate to the login screen after successful registration
        Navigator.pop(context); // Go back to the login screen

      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        }
        else {
          errorMessage = 'Registration failed: ${e.message}';
        }
        debugPrint("Firebase Registration Error: $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        debugPrint("General Registration Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred during registration.')),
        );
      }
    }
  }
  // --- End Firebase Registration Function ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set Scaffold background to transparent so the Container's gradient is visible
      backgroundColor: Colors.transparent,
      body: Container(
        // The Container now holds the gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Start with a very light, warm orange (consistent with other screens)
              Color(0xFFFFF3E0), // Equivalent to a very light orange/cream
              // End with a soft peach color (consistent with other screens)
              Color(0xFFFFCCBC), // Equivalent to a light peach
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Logo
                    const Icon(Icons.restaurant_menu, size: 80, color: Color(0xFFE53935)),
                    const SizedBox(height: 15),

                    // "Waves Of Food" Text with animation
                    ScaleTransition(
                      scale: _textScaleAnimation,
                      child: const Text(
                        'Waves Of Food',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: yeonSungFont,
                          fontSize: 38, // Slightly larger
                          fontWeight: FontWeight.bold, // Make it bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // "Sign Up Here..." Text
                    const Text(
                      'Sign Up For Your Admin Dashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(187, 12, 36, 1),
                        fontFamily: latoFont,
                        fontSize: 17, // Slightly larger
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w700, // Make it bolder
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Elevated Card for the form fields
                    Card(
                      elevation: 8.0, // Increased elevation for a more prominent shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // More rounded corners
                      ),
                      shadowColor: Colors.black.withOpacity(0.2), // Softer shadow color
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Choose Location Section
                            _buildLocationDropdown(),
                            const SizedBox(height: 20),

                            // Input Fields
                            _buildTextField(
                              controller: _ownerNameController, // Assign controller
                              hintText: 'Name of Owner',
                              icon: Icons.person_outline,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter owner name' : null,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _restaurantNameController, // Assign controller
                              hintText: 'Name of Restaurant',
                              icon: Icons.storefront_outlined,
                              validator: (value) => value == null || value.isEmpty ? 'Please enter restaurant name' : null,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _emailPhoneController, // Assign controller
                              hintText: 'Email Address', // Changed hint to explicitly ask for email
                              icon: Icons.alternate_email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                // Basic email validation using a regex
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _passwordController, // Assign controller
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            // Confirm Password Field
                            _buildTextField(
                              controller: _confirmPasswordController, // Assign controller
                              hintText: 'Confirm Password',
                              icon: Icons.lock_outline,
                              obscureText: !_isConfirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
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
                            const SizedBox(height: 35),

                            // Create Account Button
                            SizedBox(
                              width: double.infinity, // Make button wider
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromRGBO(190, 20, 20, 1).withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _registerUser, // Call the new registration function
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: const Color.fromRGBO(190, 20, 20, 1), // Darker red
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: yeonSungFont,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already Have An Account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already Have An Account? ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: latoFont,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Go back to the login screen
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromRGBO(187, 12, 36, 1),
                              fontFamily: latoFont,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Design By NeatRoots
                    const Column(
                      children: [
                        Text(
                          'Design By',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontFamily: yeonSungFont,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'NeatRoots',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontFamily: yeonSungFont,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, // Added controller parameter
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller, // Assign controller
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: latoFont, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontFamily: latoFont,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white, // Changed to white for better contrast with the card
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 2), // Slightly thicker focus border
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildLocationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 6.0),
          child: Text(
            'Choose Your Location',
            style: TextStyle(
              color: Color.fromRGBO(187, 12, 36, 1),
              fontFamily: yeonSungFont,
              fontSize: 18, // Slightly larger for emphasis
              fontWeight: FontWeight.bold, // Make it bolder
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: _selectedLocation,
          isExpanded: true,
          hint: Text(
            'Select Location',
            style: TextStyle(
                color: Colors.grey[600], fontFamily: latoFont, fontSize: 14),
          ),
          icon: Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey[700]),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white, // Changed to white
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFFE53935), width: 2), // Thicker focus border
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          items: _countries // Use the new _countries list here
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontFamily: latoFont, color: Colors.black87)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLocation = newValue;
            });
          },
          validator: (value) => value == null ? 'Please select a location' : null,
        ),
      ],
    );
  }
}