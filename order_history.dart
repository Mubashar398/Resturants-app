// Ensure this import is at the top of your file and the package is in pubspec.yaml
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Keep if you use SVGs

// Import your navigation destinations
import 'home.dart';
import 'cart.dart';
import 'search_screen.dart';
import 'profile.dart';
import 'models/food_item.dart';

// Placeholder for a Delivery Screen
class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery')),
      body: const Center(child: Text('Delivery Screen Content')),
    );
  }
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedIndex = 3;

  final List<FoodItem> _cartItems = [
    FoodItem(name: 'Dummy Burger', restaurant: 'Fast Food', price: '\$10', imageUrl: 'assets/herbal_pancake.png', quantity: 1),
    FoodItem(name: 'Dummy Fries', restaurant: 'Fast Food', price: '\$5', imageUrl: 'assets/fruit_salad.png', quantity: 1),
  ];

  // CORRECTED _makePhoneCall method
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      // These are top-level functions from the url_launcher package.
      // They are NOT methods of _OrderHistoryScreenState.
      if (await canLaunchUrl(launchUri)) { // CORRECT: Called as a top-level function
        await launchUrl(launchUri);      // CORRECT: Called as a top-level function
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $phoneNumber. Please ensure a dialing app is available.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching call: $e')),
        );
      }
    }
  }

  // --- Navigation Logic for Bottom Navigation Bar ---
  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateToCart() {
    // Calculate total price for dummy items
    double totalPrice = _cartItems.fold(0.0, (sum, item) {
      final priceString = item.price.replaceAll('\$', '');
      final priceDouble = double.tryParse(priceString) ?? 0.0;
      return sum + (priceDouble * item.quantity);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartWidget(
          cartItems: _cartItems,
          totalPrice: totalPrice,
        ),
      ),
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  void _navigateToDelivery() {
    // This screen is effectively the "Delivery/History" screen based on the icon.
    // If you had a separate screen specifically for active deliveries, you'd navigate there.
    print('Already on Order History / Delivery related screen.');
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileWidget()),
    );
  }

  void _onItemTapped(int index) {
    // If already on the selected tab (index 3 for History), do nothing.
    if (_selectedIndex == index && index == 3) {
      print("Already on Order History (index 3)");
      return;
    }

    // If navigating to a different screen, update the selected index
    // and then perform navigation.
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    switch (index) {
      case 0:
        _navigateToHome();
        break;
      case 1:
        _navigateToCart();
        break;
      case 2:
        _navigateToSearch();
        break;
      case 3:
      // Since this screen IS the one for index 3, if we reach here,
      // it means we are navigating TO it from another tab.
      // The setState above has already updated _selectedIndex.
      // No explicit navigation needed if this OrderHistoryScreen is the destination.
      // If index 3 was for a *different* screen like a dedicated "DeliveryTrackingScreen",
      // then you would call _navigateToDelivery() or similar here.
        break;
      case 4:
        _navigateToProfile();
        break;
    }
  }
  // --- End Navigation Logic ---


  @override
  Widget build(BuildContext context) {
    // Define your primary and accent colors
    const Color primaryRed = Color(0xFFFC6011); // A vibrant red
    const Color accentGreen = Color(0xFF14BE77); // The green used in the call button

    return Scaffold(
      backgroundColor: Colors.white, // Changed background to white
      appBar: AppBar(
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.black), // Title remains black for contrast
        ),
        centerTitle: false,
        backgroundColor: Colors.white, // AppBar background is white
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, lorem ipsum',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryRed, // Changed to primary red
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Call For Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Remains black
              ),
            ),
            const SizedBox(height: 10),
            _buildContactCard(
              context,
              'Mr Kemplas',
              '20 minutes on the way',
              'assets/profile_kemplas.png',
              '+1234567890',
            ),
            const SizedBox(height: 20),
            _buildFoodHistoryCard(
              'Spacy fresh crab',
              'Waroenk kita',
              '\$ 35',
              'assets/spacy_fresh_crab.png',
            ),
            const SizedBox(height: 15),
            _buildFoodHistoryCard(
              'Spacy fresh crab',
              'Waroenk kita',
              '\$ 35',
              'assets/fruit_salad.png',
            ),
            const SizedBox(height: 15),
            _buildFoodHistoryCard(
              'Spacy fresh crab',
              'Waroenk kita',
              '\$ 35',
              'assets/green_noodle.png',
            ),
            const SizedBox(height: 15),
            _buildFoodHistoryCard(
              'Spacy fresh crab',
              'Waroenk kita',
              '\$ 35',
              'assets/herbal_pancake.png',
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  Widget _buildContactCard(
      BuildContext context, String name, String status, String imageUrl, String phoneNumber) {
    const Color primaryRed = Color(0xFFFC6011); // Define here for local use
    const Color accentGreen = Color(0xFF14BE77);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  print('Error loading image ($imageUrl): $exception');
                },
              ),
              const SizedBox(width: 15),
              Expanded( // Added Expanded to prevent overflow if text is long
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () => _makePhoneCall(phoneNumber), // This will now use the corrected function
              icon: const Icon(Icons.call, color: accentGreen), // Use accent green
              label: const Text(
                'Call',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: accentGreen, // Use accent green
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: accentGreen, width: 1.5), // Use accent green
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodHistoryCard(
      String foodName, String restaurantName, String price, String imageUrl) {
    const Color primaryRed = Color(0xFFFC6011); // Define here for local use

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image ($imageUrl): $error');
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  restaurantName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryRed, // Changed to primary red
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('Buy Again: $foodName');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Adding $foodName to cart...')),
                );
              }
              // In a real app, you would add this item to your cart state
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed, // Changed to primary red
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Buy Again',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildCustomNavigationBar() {
    return Container(
      height: 60.0, // Standard height for bottom nav bar
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1), // Shadow on top
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home, // Optional: different icon when selected
            label: 'Home',
            index: 0,
            onTap: () => _onItemTapped(0),
          ),
          _buildNavItem(
            icon: Icons.shopping_cart_outlined,
            selectedIcon: Icons.shopping_cart,
            label: 'Cart',
            index: 1,
            onTap: () => _onItemTapped(1),
            showBadge: _cartItems.isNotEmpty,
            badgeCount: _cartItems.length,
          ),
          _buildNavItem(
            icon: Icons.search_outlined,
            selectedIcon: Icons.search,
            label: 'Search',
            index: 2,
            onTap: () => _onItemTapped(2),
          ),
          _buildNavItem(
            icon: Icons.assignment_outlined,
            selectedIcon: Icons.assignment,
            label: 'History',
            index: 3, // This screen's index
            onTap: () => _onItemTapped(3),
            // showLabel is determined by isSelected in _buildNavItem,
            // but for the active tab (History), it will be true.
          ),
          _buildNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Profile',
            index: 4,
            onTap: () => _onItemTapped(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    IconData? selectedIcon, // Optional selected icon
    required String label,
    required int index,
    required VoidCallback onTap,
    bool showBadge = false,
    int badgeCount = 0,
  }) {
    final bool isSelected = _selectedIndex == index;
    // Define your primary color here for consistent use
    const Color primaryRed = Color(0xFFFC6011);
    final Color inactiveColor = Colors.grey.shade600;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          // Optional: Highlight for selected item
          decoration: isSelected
              ? BoxDecoration(
            // color: activeColor.withOpacity(0.1), // Subtle background highlight
            // borderRadius: BorderRadius.circular(12),
          )
              : null,
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? (selectedIcon ?? icon) : icon,
                    color: isSelected ? primaryRed : inactiveColor, // Changed to primary red
                    size: 24,
                  ),
                  if (showBadge && badgeCount > 0)
                    Positioned(
                      top: -5,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Center(
                          child: Text(
                            badgeCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
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
                  color: isSelected ? primaryRed : inactiveColor, // Changed to primary red
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}