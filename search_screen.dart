// lib/search_screen.dart
import 'package:flutter/material.dart';
import 'cart.dart'; // Make sure this import path is correct
import 'home.dart'; // Make sure this import path is correct
import 'profile.dart'; // IMPORT THE PROFILE WIDGET
import 'order_history.dart'; // IMPORT THE ORDER HISTORY WIDGET
import 'models/food_item.dart'; // THIS IS THE CORRECT AND ONLY PLACE FOR FoodItem DEFINITION

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _filteredFoodItems = [];

  // Updated list with 15 items
  final List<FoodItem> _foodItems = [
    FoodItem(
      name: 'Herbal Pancake',
      restaurant: 'Warung Herbal',
      price: '\$7', // In a real app, price should be double
      imageUrl: 'assets/images/herbal_pancake.png', // Assuming images are in assets/images/
    ),
    FoodItem(
      name: 'Fruit Salad',
      restaurant: 'Wiji Resto',
      price: '\$5',
      imageUrl: 'assets/images/fruit_salad.png',
    ),
    FoodItem(
      name: 'Green Noodle',
      restaurant: 'Noodle Home',
      price: '\$15',
      imageUrl: 'assets/images/green_noodle.png',
    ),
    FoodItem(
      name: 'Spicy Chicken Ramen',
      restaurant: 'Ramen House',
      price: '\$12',
      imageUrl: 'assets/images/chicken_ramen.png', // Add this image to your assets
    ),
    FoodItem(
      name: 'Vegetable Biryani',
      restaurant: 'Indian Flavors',
      price: '\$10',
      imageUrl: 'assets/images/veg_biryani.png', // Add this image
    ),
    FoodItem(
      name: 'Margherita Pizza',
      restaurant: 'Pizza Central',
      price: '\$18',
      imageUrl: 'assets/images/margherita_pizza.png', // Add this image
    ),
    FoodItem(
      name: 'Beef Burger',
      restaurant: 'Burger Joint',
      price: '\$9',
      imageUrl: 'assets/images/beef_burger.png', // Add this image
    ),
    FoodItem(
      name: 'Chocolate Lava Cake',
      restaurant: 'Sweet Treats',
      price: '\$6',
      imageUrl: 'assets/images/lava_cake.png', // Add this image
    ),
    FoodItem(
      name: 'Sushi Platter',
      restaurant: 'Sakura Sushi',
      price: '\$22',
      imageUrl: 'assets/images/sushi_platter.png', // Add this image
    ),
    FoodItem(
      name: 'Caesar Salad',
      restaurant: 'Healthy Bites',
      price: '\$8',
      imageUrl: 'assets/images/caesar_salad.png', // Add this image
    ),
    FoodItem(
      name: 'Paneer Tikka Masala',
      restaurant: 'Curry House',
      price: '\$14',
      imageUrl: 'assets/images/paneer_tikka.png', // Add this image
    ),
    FoodItem(
      name: 'French Fries',
      restaurant: 'Quick Bites',
      price: '\$4',
      imageUrl: 'assets/images/french_fries.png', // Add this image
    ),
    FoodItem(
      name: 'Mango Lassi',
      restaurant: 'Cool Drinks',
      price: '\$5',
      imageUrl: 'assets/images/mango_lassi.png', // Add this image
    ),
    FoodItem(
      name: 'Tacos Al Pastor',
      restaurant: 'Mexican Fiesta',
      price: '\$11',
      imageUrl: 'assets/images/tacos_pastor.png', // Add this image
    ),
    FoodItem(
      name: 'Strawberry Cheesecake',
      restaurant: 'Dessert Cafe',
      price: '\$7',
      imageUrl: 'assets/images/strawberry_cheesecake.png', // Add this image
    ),
  ];

  List<FoodItem> _cartItems = [];
  double _totalPrice = 0.0;
  int _selectedIndex = 2; // Search is selected

  @override
  void initState() {
    super.initState();
    _filteredFoodItems = _foodItems; // Initially show all items
    _searchController.addListener(_filterFoodItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFoodItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFoodItems = _foodItems.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.restaurant.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addToCart(FoodItem item) {
    setState(() {
      _cartItems.add(item);
      // Ensure price is parsed correctly. Consider making FoodItem.price a double.
      try {
        _totalPrice += double.parse(item.price.replaceAll('\$', '').trim());
      } catch (e) {
        print("Error parsing price for ${item.name}: ${item.price}");
        // Handle error, maybe show a default price or log it
      }
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartWidget(
          cartItems: _cartItems,
          totalPrice: _totalPrice,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 1) {
      _navigateToCart();
    } else if (index == 2) {
      // Current screen
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors used in this screen for consistency
    final Color primaryRed = Colors.red[700]!;
    final Color lightRed = Colors.red[50]!;
    final Color subtleGrey = Colors.grey[100]!;

    return Scaffold(
      backgroundColor: subtleGrey,
      appBar: AppBar(
        toolbarHeight: 0, // Effectively hides the app bar itself
        backgroundColor: Colors.transparent, // Makes it transparent
        elevation: 0, // No shadow
      ),
      body: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0), // Adjust top padding
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: lightRed,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController, // Assign controller
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: primaryRed, size: 24),
                  hintText: 'What are you craving today?',
                  hintStyle: TextStyle(color: primaryRed.withOpacity(0.8), fontSize: 16),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: primaryRed, fontSize: 16),
              ),
            ),
          ),

          // "Popular" Title Section (or "Search Results")
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _searchController.text.isEmpty
                    ? 'Popular Choices'
                    : 'Search Results', // Change title based on search
                style: TextStyle(
                  fontSize: 22, // Slightly adjusted size
                  fontWeight: FontWeight.bold,
                  color: primaryRed,
                ),
              ),
            ),
          ),

          // Food Items List or "Not Found" message
          Expanded(
            child: _filteredFoodItems.isEmpty && _searchController.text.isNotEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Item Not Found!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Try searching for something else.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemCount: _filteredFoodItems.length,
              itemBuilder: (context, index) {
                final item = _filteredFoodItems[index];
                return FoodCard(
                  item: item,
                  onAddToCart: () {
                    _addToCart(item);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.name} added to cart!'),
                        duration: const Duration(seconds: 2), // Slightly longer duration
                        backgroundColor: Colors.green[600], // Success color
                        behavior: SnackBarBehavior.floating, // More modern look
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _cartItems.isNotEmpty // Only show FAB if cart has items
          ? FloatingActionButton.extended(
        onPressed: _navigateToCart,
        backgroundColor: primaryRed,
        icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
        label: Text(
          'View Cart (${_cartItems.length})',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
          : null, // Hide FAB if cart is empty
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  Widget _buildCustomNavigationBar() {
    // Using a consistent color, e.g., the primaryRed or a contrasting white
    final Color selectedIconColor = Colors.red[700]!;
    final Color unselectedIconColor = Colors.grey[600]!;
    final Color selectedLabelColor = Colors.red[700]!;
    final Color selectedBackgroundColor = Colors.red[100]!;

    return Container(
      height: 65.0, // Slightly increased height for better touch targets
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2), // Shadow at the top
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: _selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
            label: 'Home',
            index: 0,
            isSelected: _selectedIndex == 0,
            selectedColor: selectedIconColor,
            unselectedColor: unselectedIconColor,
            selectedLabelColor: selectedLabelColor,
            selectedBackgroundColor: selectedBackgroundColor,
          ),
          _buildNavItem(
            icon: _selectedIndex == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined,
            label: 'Cart',
            index: 1,
            showBadge: _cartItems.isNotEmpty,
            badgeCount: _cartItems.length,
            isSelected: _selectedIndex == 1,
            selectedColor: selectedIconColor,
            unselectedColor: unselectedIconColor,
            selectedLabelColor: selectedLabelColor,
            selectedBackgroundColor: selectedBackgroundColor,
          ),
          _buildNavItem(
            icon: _selectedIndex == 2 ? Icons.search : Icons.search_outlined,
            label: 'Search',
            index: 2,
            isSelected: _selectedIndex == 2,
            selectedColor: selectedIconColor,
            unselectedColor: unselectedIconColor,
            selectedLabelColor: selectedLabelColor,
            selectedBackgroundColor: selectedBackgroundColor,
          ),
          _buildNavItem(
            icon: _selectedIndex == 3 ? Icons.receipt_long : Icons.receipt_long_outlined,
            label: 'Orders',
            index: 3,
            isSelected: _selectedIndex == 3,
            selectedColor: selectedIconColor,
            unselectedColor: unselectedIconColor,
            selectedLabelColor: selectedLabelColor,
            selectedBackgroundColor: selectedBackgroundColor,
          ),
          _buildNavItem(
            icon: _selectedIndex == 4 ? Icons.person : Icons.person_outline,
            label: 'Profile',
            index: 4,
            isSelected: _selectedIndex == 4,
            selectedColor: selectedIconColor,
            unselectedColor: unselectedIconColor,
            selectedLabelColor: selectedLabelColor,
            selectedBackgroundColor: selectedBackgroundColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool showBadge = false,
    int badgeCount = 0,
    // Add these parameters for better color control from the caller
    required bool isSelected,
    required Color selectedColor,
    required Color unselectedColor,
    required Color selectedLabelColor,
    required Color selectedBackgroundColor,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque, // Ensures the whole area is tappable
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjusted padding
        decoration: isSelected
            ? BoxDecoration(
          color: selectedBackgroundColor,
          borderRadius: BorderRadius.circular(25.0), // Pill shape
        )
            : null,
        child: Column( // Changed to Column for icon and label alignment
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 26, // Slightly larger icons
                ),
                if (showBadge && badgeCount > 0)
                  Positioned(
                    top: -4, // Adjusted position
                    right: -6, // Adjusted position
                    child: Container(
                      padding: const EdgeInsets.all(3), // Adjusted padding for badge
                      decoration: BoxDecoration(
                        color: selectedColor, // Badge color matches selected icon color
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18, // Adjusted size
                        minHeight: 18, // Adjusted size
                      ),
                      child: Text(
                        badgeCount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10, // Adjusted font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[ // Show label only when selected for a cleaner look or always if preferred
              const SizedBox(height: 3.0),
              Text(
                label,
                style: TextStyle(
                  color: selectedLabelColor,
                  fontSize: 11, // Smaller font for label
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Ensure your FoodCard widget is defined below or imported.
// I'm assuming it's the same as the one you provided earlier.
class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAddToCart;

  const FoodCard({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryRed = Colors.red[700]!;

    return Card( // Using Card widget for better elevation and default styling
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 3, // Add some elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.imageUrl,
                width: 85, // Slightly increased size
                height: 85,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.fastfood_outlined, color: Colors.grey.shade400, size: 40),
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
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17, // Slightly larger
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.restaurant,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10), // Add some space before price and button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.price, // Ensure this is formatted as needed (e.g., $ before or Rs.)
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17, // Slightly larger
                    color: primaryRed,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: Icon(Icons.add_circle, color: primaryRed, size: 30), // Changed icon
                  onPressed: onAddToCart,
                  padding: EdgeInsets.zero, // Remove default padding if needed
                  constraints: const BoxConstraints(), // Remove default constraints
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// REMEMBER TO DEFINE YOUR FoodItem model class
// (it was in your models/food_item.dart in the initial code)
// Example:
// class FoodItem {
//   final String name;
//   final String restaurant;
//   final String price; // Consider using double for price for calculations
//   final String imageUrl;
//
//   FoodItem({
//     required this.name,
//     required this.restaurant,
//     required this.price,
//     required this.imageUrl,
//   });
// }