import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For File class

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController(text: 'lorem ipsum');
  final TextEditingController _addressController = TextEditingController(
      text: 'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual');
  final TextEditingController _emailController = TextEditingController(text: 'lorem_ipsum@gmail.com');
  final TextEditingController _phoneController = TextEditingController(text: '123456789');
  final TextEditingController _passwordController = TextEditingController(text: '*********');

  bool _isPasswordVisible = false; // RE-ADDED: To control password visibility

  String? _selectedLocation; // For the dropdown
  File? _restaurantImage; // To store the selected restaurant image

  // Sample locations (you would get these from a real database/API)
  final List<String> _locations = ['Pakistan', 'India', 'USA', 'UK', 'Canada'];

  // Sample country codes
  String _selectedCountryCode = '+92'; // Default to Pakistan's code
  final List<String> _countryCodes = ['+1', '+44', '+91', '+92', '+61']; // Example codes

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to clear text on tap if it's the initial placeholder
  void _clearTextOnFocus(TextEditingController controller, String initialText) {
    if (controller.text == initialText) {
      controller.clear();
    }
  }

  // Function to pick an image for the restaurant
  Future<void> _pickRestaurantImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _restaurantImage = File(image.path);
      });
      print('Restaurant Image picked: ${image.path}');
    } else {
      print('No restaurant image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935); // A red color similar to the image

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5, // Subtle shadow under the app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Admin Profile',
          style: TextStyle(
            // fontFamily: 'RobotoSlab', // Assuming a custom font for the title
            color: primaryRed,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Choose Your Location
            const Text(
              'Choose Your Location',
              style: TextStyle(
                fontSize: 14,
                color: primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildLocationDropdown(primaryRed),
            const SizedBox(height: 16),

            // Name
            _buildProfileTextField(
              controller: _nameController,
              label: 'Name',
              readOnly: false, // Make it editable
              initialText: 'lorem ipsum', // To clear on tap
              trailingIcon: Icons.edit,
              onTrailingIconPressed: () {
                // Handle edit name
                print('Edit Name tapped');
              },
            ),
            const SizedBox(height: 16),

            // Address
            _buildProfileTextField(
              controller: _addressController,
              label: 'Address',
              readOnly: false, // Make it editable
              maxLines: 4, // Allow multiple lines for address
              initialText: 'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual', // To clear on tap
              trailingIcon: Icons.edit,
              leadingIcon: Icons.location_on_outlined, // Location icon
              onTrailingIconPressed: () {
                // Handle edit address
                print('Edit Address tapped');
              },
            ),
            const SizedBox(height: 16),

            // Email
            _buildProfileTextField(
              controller: _emailController,
              label: 'Email',
              readOnly: false, // Make it editable
              initialText: 'lorem_ipsum@gmail.com', // To clear on tap
              keyboardType: TextInputType.emailAddress,
              trailingIcon: Icons.edit,
              onTrailingIconPressed: () {
                // Handle edit email
                print('Edit Email tapped');
              },
            ),
            const SizedBox(height: 16),

            // Phone
            _buildProfileTextField(
              controller: _phoneController,
              label: 'Phone',
              readOnly: false, // Make it editable
              initialText: '123456789', // To clear on tap
              keyboardType: TextInputType.phone,
              isPhoneField: true, // Special handling for phone field
              trailingIcon: Icons.edit,
              onTrailingIconPressed: () {
                // Handle edit phone
                print('Edit Phone tapped');
              },
            ),
            const SizedBox(height: 16),

            // Password
            _buildProfileTextField(
              controller: _passwordController,
              label: 'Password',
              readOnly: false, // Make it editable
              initialText: '*********', // To clear on tap
              obscureText: !_isPasswordVisible, // Use _isPasswordVisible to toggle
              trailingIcon: Icons.edit,
              leadingIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Eye icon for password
              onLeadingIconPressed: () { // Callback for eye icon
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              onTrailingIconPressed: () {
                // Handle edit password
                print('Edit Password tapped');
              },
            ),
            const SizedBox(height: 16),

            // Restaurant Image
            _buildRestaurantImageField(primaryRed),
            const SizedBox(height: 30),

            // Save Information Button
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Save Information
                    print('Save Information button pressed');
                    print('Name: ${_nameController.text}');
                    print('Address: ${_addressController.text}');
                    print('Email: ${_emailController.text}');
                    print('Phone: $_selectedCountryCode${_phoneController.text}');
                    print('Password: ${_passwordController.text}');
                    if (_restaurantImage != null) {
                      print('Restaurant Image Path: ${_restaurantImage!.path}');
                    } else {
                      print('No restaurant image selected.');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    foregroundColor: primaryRed, // Red text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: primaryRed, width: 1.5), // Red border
                    ),
                    elevation: 1, // Subtle shadow
                  ),
                  child: const Text(
                    'Save Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Design By NeatRoots
            Center(
              child: Column(
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
                      // fontFamily: 'Montserrat', // Consistent with other screens
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // Helper widget for profile text fields
  Widget _buildProfileTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    IconData? trailingIcon,
    VoidCallback? onTrailingIconPressed,
    IconData? leadingIcon, // For location icon or password eye icon
    VoidCallback? onLeadingIconPressed, // For password visibility icon
    bool isPhoneField = false, // To handle phone country code
    String initialText = '', // To store initial text for clearing
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        onTap: () => _clearTextOnFocus(controller, initialText), // Clear text on tap
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 15, color: Colors.grey[600]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: InputBorder.none,
          suffixIcon: Row( // Use a Row for suffix icons
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null && onLeadingIconPressed != null) // For password eye icon
                IconButton(
                  icon: Icon(leadingIcon, color: Colors.grey),
                  onPressed: onLeadingIconPressed,
                ),
              if (trailingIcon != null) // For edit icon
                IconButton(
                  icon: Icon(trailingIcon, color: Colors.grey),
                  onPressed: onTrailingIconPressed,
                ),
            ],
          ),
          prefixIcon: isPhoneField
              ? IntrinsicHeight( // Use IntrinsicHeight to size the row correctly
            child: Row(
              mainAxisSize: MainAxisSize.min, // To make the row only take necessary space
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCountryCode,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountryCode = newValue!;
                      });
                    },
                    items: _countryCodes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: Colors.grey), // Divider after country code
                const SizedBox(width: 8), // Spacing after divider
              ],
            ),
          )
              : (leadingIcon != null && onLeadingIconPressed == null) // This will handle the location icon for address
              ? Icon(leadingIcon, color: Colors.grey)
              : null,
        ),
      ),
    );
  }

  // Helper widget for location dropdown (no changes needed here)
  Widget _buildLocationDropdown(Color primaryRed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocation ?? _locations[0], // Default to first location
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          isExpanded: true,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLocation = newValue;
            });
          },
          items: _locations.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Modified Helper widget for restaurant image field
  Widget _buildRestaurantImageField(Color primaryRed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Restaurant Image',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          Row( // Use a Row to display image preview and the add icon
            children: [
              if (_restaurantImage != null)
                Container(
                  width: 50, // Smaller preview size
                  height: 50,
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: FileImage(_restaurantImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
              // Placeholder if no image is selected
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade100,
                  ),
                  child: Icon(Icons.image, size: 30, color: Colors.grey[400]),
                ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: primaryRed), // Plus icon in red
                onPressed: _pickRestaurantImage, // Call image picker
              ),
            ],
          ),
        ],
      ),
    );
  }
}