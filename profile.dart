import 'package:flutter/material.dart';
import 'home.dart'; // <--- IMPORT YOUR HOME SCREEN
import 'cart.dart'; // Import CartWidget for navigation
import 'search_screen.dart'; // Import SearchScreen for navigation
import 'order_history.dart'; // Import OrderHistoryScreen for navigation
import 'package:image_picker/image_picker.dart'; // Required for image picking
import 'dart:io'; // Required for File

// Define theme colors for easy access and consistency in this file
// If you have a global AppColors class, you can use that instead.
class _ProfileScreenColors {
  static const Color primaryRed = Color(0xFFD32F2F); // A strong red
  static const Color accentRed = Color(0xFFE57373); // A lighter, accent red

  static const Color textPrimaryDark = Color(0xFF212121); // For primary text on light backgrounds
  static const Color textSecondaryDark = Color(0xFF757575); // For secondary text
  static const Color textPrimaryLight = Colors.white; // For text on dark/red backgrounds

  static const Color backgroundWhite = Colors.white; // Pure white background
  static const Color cardBackground = Colors.white; // Background for cards
  static const Color dividerColor = Color(0xFFE0E0E0); // For dividers and borders
  static const Color iconColorDark = Color(0xFF424242); // For icons on light backgrounds
  static const Color iconColorLight = Colors.white; // For icons on dark/red backgrounds

  static const Color selectedItemColor = primaryRed; // Red for selected/active elements
  static const Color unselectedItemColor = textSecondaryDark; // Grey for unselected
  static const Color selectedBgColor = Color(0xFFFEEBEE); // Light red for selected background
}


// Define a class for country codes
class Country {
  final String name;
  final String code;
  final String flag; // For flag emoji or image path

  Country({required this.name, required this.code, required this.flag});
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> with TickerProviderStateMixin {
  int _selectedIndex = 4; // Set to 4 to highlight 'Profile' initially

  // Removed old color variables, will use _ProfileScreenColors

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  String? _editingFieldKey;
  bool _isPasswordVisible = false;
  Country? _selectedCountry;
  File? _imageFile; // For storing the selected image

  final List<Country> _countries = [
    Country(name: "USA", code: "+1", flag: "🇺🇸"),
    Country(name: "Canada", code: "+1", flag: "🇨🇦"),
    Country(name: "UK", code: "+44", flag: "🇬🇧"),
    Country(name: "Australia", code: "+61", flag: "🇦🇺"),
    Country(name: "Germany", code: "+49", flag: "🇩🇪"),
    Country(name: "France", code: "+33", flag: "🇫🇷"),
    Country(name: "Japan", code: "+81", flag: "🇯🇵"),
    Country(name: "India", code: "+91", flag: "🇮🇳"),
    Country(name: "Brazil", code: "+55", flag: "🇧🇷"),
    Country(name: "South Africa", code: "+27", flag: "🇿🇦"),
    Country(name: "Pakistan", code: "+92", flag: "🇵🇰"),
    Country(name: "Nigeria", code: "+234", flag: "🇳🇬"),
    Country(name: "Egypt", code: "+20", flag: "🇪🇬"),
    Country(name: "Mexico", code: "+52", flag: "🇲🇽"),
    Country(name: "Argentina", code: "+54", flag: "🇦🇷"),
    Country(name: "China", code: "+86", flag: "🇨🇳"),
    Country(name: "Russia", code: "+7", flag: "🇷🇺"),
    Country(name: "Saudi Arabia", code: "+966", flag: "🇸🇦"),
    Country(name: "UAE", code: "+971", flag: "🇦🇪"),
    Country(name: "Singapore", code: "+65", flag: "🇸🇬"),
  ];

  // Animation Controllers
  late AnimationController _avatarAnimationController;
  late Animation<double> _avatarScaleAnimation;
  late Animation<double> _avatarFadeAnimation;

  late AnimationController _contentAnimationController;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'John Doe');
    _addressController = TextEditingController(text: '123 Foodie Lane, Flavorville, FL 90210');
    _emailController = TextEditingController(text: 'john.doe@delicious.com');
    _phoneController = TextEditingController(text: '03001234567');
    _passwordController = TextEditingController(text: '●●●●●●●●');

    if (_countries.isNotEmpty) {
      _selectedCountry = _countries.firstWhere((c) => c.code == "+92", orElse: () => _countries.first);
    }

    _avatarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Slightly faster
    );
    _avatarScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _avatarAnimationController, curve: Curves.elasticOut),
    );
    _avatarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _avatarAnimationController, curve: Curves.easeIn),
    );

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Slightly faster
    );
    _contentSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate( // Subtle slide
      CurvedAnimation(parent: _contentAnimationController, curve: Curves.easeOutQuad),
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentAnimationController, curve: Curves.easeIn),
    );

    _avatarAnimationController.forward();
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _avatarAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      if (index == 4) return; // Already on profile
    }

    setState(() {
      _selectedIndex = index;
      _editingFieldKey = null;
    });

    PageRouteBuilder pageRoute(Widget screen) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      );
    }

    // No delay needed if using PageRouteBuilder for transition
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, pageRoute(const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, pageRoute(const CartWidget(cartItems: [], totalPrice: 0.0)));
        break;
      case 2:
        Navigator.pushReplacement(context, pageRoute(const SearchScreen()));
        break;
      case 3:
        Navigator.pushReplacement(context, pageRoute(const OrderHistoryScreen()));
        break;
      case 4:
      // Already on Profile screen
        break;
    }
  }

  // Helper method for building navigation bar items
  Widget _buildNavItem({
    required IconData outlinedIcon,
    required IconData filledIcon,
    required String label,
    required int index,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color itemColor = isSelected ? _ProfileScreenColors.selectedItemColor : _ProfileScreenColors.unselectedItemColor;
    // final Color bgColor = isSelected ? _ProfileScreenColors.selectedBgColor : Colors.transparent; // Use if you want background highlight

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? filledIcon : outlinedIcon,
                    color: itemColor,
                    size: 24, // Standard icon size
                  ),
                  if (showBadge && badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          color: _ProfileScreenColors.accentRed, // Use themed red for badge
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          badgeCount > 9 ? '9+' : badgeCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _ProfileScreenColors.textPrimaryLight,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 11, // Slightly smaller label for cleaner look
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _toggleEditField(String fieldKey) {
    setState(() {
      if (_editingFieldKey == fieldKey) {
        _editingFieldKey = null; // Save or cancel will handle this
      } else {
        _editingFieldKey = fieldKey;
      }
    });
  }

  void _saveInformation() {
    // Basic validation example (can be expanded)
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty.'),
          backgroundColor: _ProfileScreenColors.accentRed,
        ),
      );
      return;
    }
    // Add more validation as needed

    setState(() {
      _editingFieldKey = null; // Exit editing mode
    });
    String name = _nameController.text;
    String address = _addressController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneController.text;
    String countryCode = _selectedCountry?.code ?? '';
    // Password handling should be more secure in a real app

    print('Saving Information:');
    print('Name: $name');
    print('Address: $address');
    print('Email: $email');
    print('Phone: $countryCode $phoneNumber');
    // print('Password: $password'); // Avoid printing password

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile information updated!'),
        backgroundColor: _ProfileScreenColors.primaryRed, // Use themed color
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile picture updated!'),
          backgroundColor: _ProfileScreenColors.primaryRed,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      // User cancelled picker or an error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No image selected.'),
          backgroundColor: _ProfileScreenColors.accentRed, // Use themed color for warnings
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ProfileScreenColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: _ProfileScreenColors.backgroundWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: _ProfileScreenColors.textPrimaryDark,
            fontSize: 22, // Adjusted size
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: _ProfileScreenColors.iconColorDark),
          onPressed: () {
            // Navigate back or to home if it's the root of profile section
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              _onItemTapped(0); // Go to Home if cannot pop
            }
          },
        ),
        actions: [
          if (_editingFieldKey != null)
            ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate( // Subtle scale
                CurvedAnimation(parent: _contentAnimationController, curve: Curves.elasticOut),
              ),
              child: IconButton(
                icon: const Icon(Icons.check_circle_outline_rounded, color: _ProfileScreenColors.primaryRed, size: 28),
                onPressed: _saveInformation,
                tooltip: 'Save Changes',
              ),
            ),
          const SizedBox(width: 8), // Add some spacing for the save button
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _avatarFadeAnimation,
              child: ScaleTransition(
                scale: _avatarScaleAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _ProfileScreenColors.primaryRed.withOpacity(0.5), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: _ProfileScreenColors.primaryRed.withOpacity(0.15),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55, // Slightly smaller
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider<Object>
                            : const AssetImage('assets/profile_placeholder.png'), // Ensure placeholder exists
                        backgroundColor: _ProfileScreenColors.dividerColor,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: _ProfileScreenColors.primaryRed, // Themed button
                            shape: BoxShape.circle,
                            border: Border.all(color: _ProfileScreenColors.backgroundWhite, width: 2.5),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded, // Changed icon
                            color: _ProfileScreenColors.iconColorLight,
                            size: 20, // Adjusted size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              // Handle case where name might be empty initially
              'Hey, ${_nameController.text.isNotEmpty ? _nameController.text.split(" ").first : "User"}!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold, // Adjusted weight
                color: _ProfileScreenColors.textPrimaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Manage your personal information below.', // More direct
              style: TextStyle(
                fontSize: 15,
                color: _ProfileScreenColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _contentFadeAnimation,
              child: SlideTransition(
                position: _contentSlideAnimation,
                child: Column(
                  children: [
                    _buildInfoCard('Full Name', _nameController, TextInputType.name, Icons.person_outline_rounded),
                    const SizedBox(height: 16),
                    _buildInfoCard('Delivery Address', _addressController, TextInputType.streetAddress, Icons.location_on_outlined, isAddress: true),
                    const SizedBox(height: 16),
                    _buildInfoCard('Email Address', _emailController, TextInputType.emailAddress, Icons.email_outlined),
                    const SizedBox(height: 16),
                    _buildInfoCard('Phone Number', _phoneController, TextInputType.phone, Icons.phone_outlined, isPhone: true),
                    const SizedBox(height: 16),
                    _buildInfoCard('Password', _passwordController, TextInputType.visiblePassword, Icons.lock_outline_rounded, isPassword: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveInformation,
              style: ElevatedButton.styleFrom(
                backgroundColor: _ProfileScreenColors.primaryRed,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _ProfileScreenColors.textPrimaryLight,
                ),
              ),
              child: const Text('Save All Changes', style: TextStyle(color: _ProfileScreenColors.textPrimaryLight)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 65.0, // Standard height
        decoration: BoxDecoration(
          color: _ProfileScreenColors.backgroundWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06), // Softer shadow
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(top: BorderSide(color: _ProfileScreenColors.dividerColor.withOpacity(0.5), width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding for nav items
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(outlinedIcon: Icons.home_outlined, filledIcon: Icons.home_rounded, label: 'Home', index: 0),
            _buildNavItem(outlinedIcon: Icons.shopping_cart_outlined, filledIcon: Icons.shopping_cart_rounded, label: 'Cart', index: 1, showBadge: true, badgeCount: 0 /* Replace with actual cart count */),
            _buildNavItem(outlinedIcon: Icons.search_outlined, filledIcon: Icons.search_rounded, label: 'Search', index: 2),
            _buildNavItem(outlinedIcon: Icons.receipt_long_outlined, filledIcon: Icons.receipt_long_rounded, label: 'Orders', index: 3),
            _buildNavItem(outlinedIcon: Icons.person_outline_rounded, filledIcon: Icons.person_rounded, label: 'Profile', index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title,
      TextEditingController controller,
      TextInputType keyboardType,
      IconData leadingIcon, { // Added leading icon parameter
        bool isAddress = false,
        bool isPassword = false,
        bool isPhone = false,
      }) {
    bool isEditing = _editingFieldKey == title;
    Widget valueWidget;

    InputDecoration inputDecoration = InputDecoration(
      border: InputBorder.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
      hintText: isEditing ? 'Enter $title' : '',
      hintStyle: const TextStyle(color: _ProfileScreenColors.textSecondaryDark, fontSize: 15),
      suffixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 30), // Ensure suffix icon space
    );


    if (isEditing) {
      if (isPhone) {
        valueWidget = Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              margin: const EdgeInsets.only(right: 8.0),
              decoration: BoxDecoration(
                color: _ProfileScreenColors.backgroundWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _ProfileScreenColors.dividerColor, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  value: _selectedCountry,
                  icon: const Icon(Icons.arrow_drop_down_rounded, color: _ProfileScreenColors.iconColorDark, size: 20),
                  style: const TextStyle(fontSize: 15, color: _ProfileScreenColors.textPrimaryDark),
                  items: _countries.map((Country country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: Text("${country.flag} ${country.code}", style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (Country? newValue) {
                    setState(() {
                      _selectedCountry = newValue;
                    });
                  },
                  hint: const Text("Code", style: TextStyle(color: _ProfileScreenColors.textSecondaryDark, fontSize: 14)),
                  itemHeight: 48, // Consistent item height
                  dropdownColor: _ProfileScreenColors.backgroundWhite,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(fontSize: 15, color: _ProfileScreenColors.textPrimaryDark),
                decoration: inputDecoration.copyWith(hintText: "Phone Number"),
                autofocus: true, // Autofocus when editing starts
              ),
            ),
          ],
        );
      } else {
        valueWidget = TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !_isPasswordVisible,
          style: const TextStyle(fontSize: 15, color: _ProfileScreenColors.textPrimaryDark),
          decoration: inputDecoration.copyWith(
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: _ProfileScreenColors.iconColorDark, size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : null,
          ),
          autofocus: true,
        );
      }
    } else {
      String displayValue = controller.text;
      if (isPassword) {
        displayValue = '●●●●●●●●';
      } else if (isPhone && _selectedCountry != null) {
        displayValue = '${_selectedCountry!.flag} ${_selectedCountry!.code} ${controller.text}';
      } else if (displayValue.isEmpty){
        displayValue = 'Not set'; // Placeholder for empty fields
      }

      valueWidget = Text(
        displayValue,
        style: TextStyle(
          fontSize: 15,
          color: displayValue == 'Not set' ? _ProfileScreenColors.textSecondaryDark.withOpacity(0.7) : _ProfileScreenColors.textPrimaryDark,
        ),
        maxLines: isAddress ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Card(
      elevation: isEditing ? 3.0 : 1.5, // Subtle elevation change
      margin: EdgeInsets.zero, // Card handles its own margin via parent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isEditing ? _ProfileScreenColors.primaryRed : _ProfileScreenColors.dividerColor.withOpacity(0.7),
          width: isEditing ? 1.5 : 1.0,
        ),
      ),
      color: _ProfileScreenColors.cardBackground,
      child: InkWell( // Make the whole card tappable to enter edit mode
        onTap: () {
          if (!isEditing) {
            _toggleEditField(title);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(leadingIcon, color: isEditing ? _ProfileScreenColors.primaryRed : _ProfileScreenColors.iconColorDark, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13, // Smaller title for info card
                        fontWeight: FontWeight.normal,
                        color: _ProfileScreenColors.textSecondaryDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedSwitcher( // Smooth transition for value widget
                        duration: const Duration(milliseconds: 200),
                        child: Align( // Ensure it takes up space correctly
                          key: ValueKey(isEditing.toString() + title), // Unique key
                          alignment: Alignment.centerLeft,
                          child: valueWidget,
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isEditing ? Icons.done_rounded : Icons.edit_outlined,
                    key: ValueKey<bool>(isEditing),
                    color: isEditing ? _ProfileScreenColors.primaryRed : _ProfileScreenColors.iconColorDark.withOpacity(0.7),
                    size: 22,
                  ),
                ),
                onPressed: () {
                  if(isEditing) {
                    _saveInformation(); // Or a specific field save if desired
                  } else {
                    _toggleEditField(title);
                  }
                },
                tooltip: isEditing ? "Save" : "Edit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}