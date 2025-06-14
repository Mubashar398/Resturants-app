import 'package:flutter/material.dart';
import 'pay_out.dart';
import 'models/food_item.dart'; // Make sure this import path is correct
import 'home.dart'; // Import your HomeScreen widget
import 'profile.dart'; // Import your ProfileWidget
import 'search_screen.dart'; // Import SearchScreen for navigation
import 'order_history.dart'; // Import OrderHistoryScreen for navigation

// Define theme colors for easy access and consistency in this file
// If you have a global AppColors class, you can use that instead.
class _CartScreenColors {
  static const Color primaryRed = Color(0xFFD32F2F); // Matches HomeScreen's primaryRed
  static const Color accentRed = Color(0xFFE57373); // Matches HomeScreen's accentRed

  static const Color textPrimaryDark = Color(0xFF212121);
  static const Color textSecondaryDark = Color(0xFF757575);
  static const Color textPrimaryLight = Colors.white;

  static const Color backgroundWhite = Colors.white; // Or a very light grey like Color(0xFFF8F9FA)
  static const Color cardBackground = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color iconColorDark = Color(0xFF424242); // For icons on light background
  static const Color iconColorLight = Colors.white;
}

class CartWidget extends StatefulWidget {
  final List<FoodItem> cartItems;
  final double totalPrice;

  const CartWidget({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<FoodItem> _cartItems;
  late double _totalPrice;
  int _selectedIndex = 1; // Cart is selected

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
    _calculateTotalPrice();
  }

  void _calculateTotalPrice() {
    double newTotal = 0.0;
    for (var item in _cartItems) {
      newTotal += double.parse(item.price.replaceAll('\$', '').trim()) * item.quantity;
    }
    setState(() {
      _totalPrice = newTotal;
    });
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      if (_cartItems[index].quantity + change >= 0) { // Allow quantity to be 0 for potential removal
        _cartItems[index].quantity += change;
        if (_cartItems[index].quantity == 0) {
          // Optionally, auto-remove if quantity becomes 0
          // _removeItem(index);
        }
        _calculateTotalPrice();
      }
    });
  }

  void _removeItem(int index) {
    if (index < 0 || index >= _cartItems.length) return;
    final FoodItem removedItem = _cartItems[index];
    _cartItems.removeAt(index);
    if (_listKey.currentState != null) {
      _listKey.currentState!.removeItem(
        index,
            (context, animation) => _buildRemovedItem(removedItem, animation),
        duration: const Duration(milliseconds: 300),
      );
    } else {
      setState(() {}); // Fallback for safety, though AnimatedList should have a state
    }
    _calculateTotalPrice();
  }

  void _navigateToPayout(BuildContext context) {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Your cart is empty. Add items to proceed."),
          backgroundColor: _CartScreenColors.primaryRed,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PayoutWidget()),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // If tapping the current screen again, do nothing or refresh.
      if (index == 1) return; // Already on cart screen
    }
    setState(() => _selectedIndex = index);

    PageRouteBuilder pageRoute(Widget screen) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      );
    }

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, pageRoute(const HomeScreen()));
        break;
      case 1:
      // Already on Cart, do nothing
        break;
      case 2:
        Navigator.pushReplacement(context, pageRoute(const SearchScreen()));
        break;
      case 3: // Assuming this is Order History based on previous context
        Navigator.pushReplacement(context, pageRoute(const OrderHistoryScreen()));
        break;
      case 4:
        Navigator.pushReplacement(context, pageRoute(const ProfileWidget()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _CartScreenColors.backgroundWhite, // Use themed background
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _cartItems.isEmpty
              ? _buildEmptyCart()
              : AnimatedList(
            key: _listKey,
            initialItemCount: _cartItems.length,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 230), // Adjusted padding for total section
            itemBuilder: (context, index, animation) {
              // Ensure index is within bounds, crucial for animations after removal
              if (index >= _cartItems.length) return const SizedBox.shrink();
              return _buildAnimatedCartItem(_cartItems[index], index, animation);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildTotalSection(),
          ),
        ],
      ),
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Cart',
        style: TextStyle(color: _CartScreenColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: _CartScreenColors.backgroundWhite, // Themed AppBar
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: _CartScreenColors.iconColorDark),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 100, color: _CartScreenColors.textSecondaryDark.withOpacity(0.3)),
            const SizedBox(height: 24),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _CartScreenColors.textPrimaryDark),
            ),
            const SizedBox(height: 8),
            Text(
              "Looks like you haven't added anything to your cart yet.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: _CartScreenColors.textSecondaryDark),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _onItemTapped(0), // Navigate home
              style: ElevatedButton.styleFrom(
                  backgroundColor: _CartScreenColors.primaryRed, // Themed button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _CartScreenColors.textPrimaryLight)
              ),
              child: const Text('Start Shopping', style: TextStyle(color: _CartScreenColors.textPrimaryLight)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCartItem(FoodItem item, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: _buildCartItemCard(item, index),
      ),
    );
  }

  Widget _buildRemovedItem(FoodItem item, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0), // Slide from left
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: _buildCartItemCard(item, -1), // Index -1 signifies it's for display during removal
      ),
    );
  }

  Widget _buildCartItemCard(FoodItem item, int index) {
    // Check if the item is valid, especially the price string
    double itemPrice = 0.0;
    try {
      itemPrice = double.parse(item.price.replaceAll('\$', '').trim());
    } catch (e) {
      // Handle error or set a default price if parsing fails
      debugPrint("Error parsing price for item: ${item.name}, price: ${item.price}. Error: $e");
      // Optionally show a placeholder or error in UI for this item
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Consistent margin
      child: Dismissible(
        key: ValueKey<String>("${item.name}_${item.restaurant}_$index"), // More robust key
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (index >= 0) _removeItem(index); // Ensure index is valid before removing
        },
        background: Container(
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: _CartScreenColors.accentRed.withOpacity(0.8), // Themed dismiss background
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete_sweep_outlined, color: _CartScreenColors.iconColorLight, size: 28),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _CartScreenColors.cardBackground, // Themed card
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _CartScreenColors.dividerColor.withOpacity(0.7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70, height: 70, color: _CartScreenColors.dividerColor.withOpacity(0.2),
                    child: Icon(Icons.restaurant_menu, color: _CartScreenColors.textSecondaryDark.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _CartScreenColors.textPrimaryDark)),
                    const SizedBox(height: 3),
                    Text(item.restaurant, style: TextStyle(fontSize: 13, color: _CartScreenColors.textSecondaryDark)),
                    const SizedBox(height: 6),
                    Text(
                      '\$${(itemPrice * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _CartScreenColors.primaryRed),
                    ),
                  ],
                ),
              ),
              if (index >= 0) // Only show quantity controls for actual cart items
                Row( // Using Row for better alignment of quantity controls
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQuantityButton(Icons.remove, () => _updateQuantity(index, -1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(item.quantity.toString(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _CartScreenColors.textPrimaryDark)),
                    ),
                    _buildQuantityButton(Icons.add, () => _updateQuantity(index, 1)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _CartScreenColors.backgroundWhite,
          shape: BoxShape.rectangle, // Changed to rectangle for a more common look
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _CartScreenColors.dividerColor, width: 1),
        ),
        child: Icon(icon, size: 20, color: _CartScreenColors.iconColorDark),
      ),
    );
  }

  Widget _buildTotalSection() {
    final double deliveryFee = _cartItems.isEmpty ? 0.0 : 5.00; // No delivery fee for empty cart
    final double finalTotal = _totalPrice + deliveryFee;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 25), // Adjusted padding
        decoration: BoxDecoration(
          color: _CartScreenColors.cardBackground, // White background for this section
          border: Border(top: BorderSide(color: _CartScreenColors.dividerColor, width: 1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', _totalPrice),
            if (!_cartItems.isEmpty) _buildPriceRow('Delivery Fee', deliveryFee),
            if (!_cartItems.isEmpty) const Divider(height: 24, thickness: 1, color: _CartScreenColors.dividerColor),
            _buildPriceRow('Total', finalTotal, isTotal: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToPayout(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _CartScreenColors.primaryRed, // Themed button
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _CartScreenColors.textPrimaryLight)
              ),
              child: const Text('Proceed to Checkout', style: TextStyle(color: _CartScreenColors.textPrimaryLight)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? _CartScreenColors.textPrimaryDark : _CartScreenColors.textSecondaryDark,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? _CartScreenColors.primaryRed : _CartScreenColors.textPrimaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNavigationBar() {
    return Container(
      height: 65, // Standard height
      decoration: BoxDecoration(
        color: _CartScreenColors.backgroundWhite, // White navbar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(top: BorderSide(color: _CartScreenColors.dividerColor.withOpacity(0.5), width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home_filled, 0, 'Home'),
          _buildNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart, 1, 'Cart'),
          _buildNavItem(Icons.search_outlined, Icons.search, 2, 'Search'),
          _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long, 3, 'Orders'), // Example for "Orders"
          _buildNavItem(Icons.person_outline, Icons.person, 4, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, int index, String label) {
    bool isSelected = _selectedIndex == index;
    final Color itemColor = isSelected ? _CartScreenColors.primaryRed : _CartScreenColors.textSecondaryDark;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(isSelected ? filledIcon : outlinedIcon, size: 24, color: itemColor),
                  if (index == 1 && _cartItems.isNotEmpty)
                    Positioned(
                      top: -4,
                      right: -7,
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                            color: _CartScreenColors.accentRed, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          _cartItems.length > 9 ? '9+' : _cartItems.length.toString(),
                          style: const TextStyle(color: _CartScreenColors.textPrimaryLight, fontSize: 9, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
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
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}