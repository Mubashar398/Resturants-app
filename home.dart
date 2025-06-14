import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food_details_first.dart';
import 'search_screen.dart';
import 'cart.dart';
import 'models/food_item.dart';
import 'profile.dart';
import 'users_login.dart';
import 'order_history.dart';
import 'feedback.dart';
import 'delivery.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color accentRed = Color(0xFFE57373);
  static const Color textPrimaryDark = Color(0xFF212121);
  static const Color textSecondaryDark = Color(0xFF757575);
  static const Color textPrimaryLight = Colors.white;
  static const Color textSecondaryLight = Colors.white70;
  static const Color backgroundWhite = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primaryRed,
        scaffoldBackgroundColor: AppColors.backgroundWhite,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: AppColors.accentRed,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primaryRed,
          secondary: AppColors.accentRed,
          background: AppColors.backgroundWhite,
          surface: AppColors.cardBackground,
          onPrimary: AppColors.textPrimaryLight,
          onSecondary: AppColors.textPrimaryLight,
          onBackground: AppColors.textPrimaryDark,
          onSurface: AppColors.textPrimaryDark,
          error: Colors.red.shade700,
          onError: AppColors.textPrimaryLight,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryRed)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.textPrimaryLight,
            )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryRed,
              side: const BorderSide(color: AppColors.primaryRed),
            )),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<FoodItem> _cartItems = [
    FoodItem(
      name: 'Dummy Item 1',
      restaurant: 'Dummy Resto',
      price: '\$10',
      imageUrl: 'assets/herbal_pancake.png',
    ),
    FoodItem(
      name: 'Dummy Item 2',
      restaurant: 'Dummy Resto',
      price: '\$15',
      imageUrl: 'assets/fruit_salad.png',
    ),
  ];
  final double _totalPrice = 25.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? _currentUser;

  final List<FoodItem> _popularFoodItems = [
    FoodItem(
        name: 'Herbal Pancake',
        restaurant: 'Warung Herbal',
        price: '\$7',
        imageUrl: 'assets/herbal_pancake.png'),
    FoodItem(
        name: 'Fruit Salad',
        restaurant: 'Wiljie Resto',
        price: '\$5',
        imageUrl: 'assets/fruit_salad.png'),
    FoodItem(
        name: 'Green Noodle',
        restaurant: 'Noodle Home',
        price: '\$15',
        imageUrl: 'assets/green_noodle.png'),
    FoodItem(
        name: 'Spicy Chicken Ramen',
        restaurant: 'Ramen House',
        price: '\$12',
        imageUrl: 'assets/chicken_ramen.png'),
    FoodItem(
        name: 'Vegetable Biryani',
        restaurant: 'Indian Flavors',
        price: '\$10',
        imageUrl: 'assets/veg_biryani.png'),
    FoodItem(
        name: 'Margherita Pizza',
        restaurant: 'Pizza Central',
        price: '\$18',
        imageUrl: 'assets/margherita_pizza.png'),
    FoodItem(
        name: 'Beef Burger',
        restaurant: 'Burger Joint',
        price: '\$9',
        imageUrl: 'assets/beef_burger.png'),
    FoodItem(
        name: 'Chocolate Lava Cake',
        restaurant: 'Sweet Treats',
        price: '\$6',
        imageUrl: 'assets/lava_cake.png'),
    FoodItem(
        name: 'Sushi Platter',
        restaurant: 'Sakura Sushi',
        price: '\$22',
        imageUrl: 'assets/sushi_platter.png'),
    FoodItem(
        name: 'Caesar Salad',
        restaurant: 'Healthy Bites',
        price: '\$8',
        imageUrl: 'assets/caesar_salad.png'),
    FoodItem(
        name: 'Paneer Tikka Masala',
        restaurant: 'Curry House',
        price: '\$14',
        imageUrl: 'assets/paneer_tikka.png'),
    FoodItem(
        name: 'French Fries',
        restaurant: 'Quick Bites',
        price: '\$4',
        imageUrl: 'assets/french_fries.png'),
    FoodItem(
        name: 'Mango Lassi',
        restaurant: 'Cool Drinks',
        price: '\$5',
        imageUrl: 'assets/mango_lassi.png'),
    FoodItem(
        name: 'Tacos Al Pastor',
        restaurant: 'Mexican Fiesta',
        price: '\$11',
        imageUrl: 'assets/tacos_pastor.png'),
    FoodItem(
        name: 'Strawberry Cheesecake',
        restaurant: 'Dessert Cafe',
        price: '\$7',
        imageUrl: 'assets/strawberry_cheesecake.png'),
  ];

  late AnimationController _headerAnimationController;
  late Animation<Offset> _headerOffsetAnimation;
  late AnimationController _searchBarAnimationController;
  late Animation<double> _searchBarFadeAnimation;
  late AnimationController _promoBannerAnimationController;
  late Animation<Offset> _promoBannerOffsetAnimation;
  late AnimationController _popularSectionAnimationController;
  late Animation<double> _popularSectionFadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });

    _headerAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _headerOffsetAnimation = Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOut));

    _searchBarAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _searchBarFadeAnimation = CurvedAnimation(parent: _searchBarAnimationController, curve: Curves.easeIn);

    _promoBannerAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _promoBannerOffsetAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _promoBannerAnimationController, curve: Curves.easeOutCubic));

    _popularSectionAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _popularSectionFadeAnimation = CurvedAnimation(parent: _popularSectionAnimationController, curve: Curves.easeIn);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _headerAnimationController.forward();
        _searchBarAnimationController.forward();
        _promoBannerAnimationController.forward();
        _popularSectionAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _searchBarAnimationController.dispose();
    _promoBannerAnimationController.dispose();
    _popularSectionAnimationController.dispose();
    super.dispose();
  }

  void _navigateToSearchScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
  }

  void _navigateToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartWidget(cartItems: _cartItems, totalPrice: _totalPrice)),
    );
  }

  void _navigateToProfileScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileWidget()));
  }

  void _navigateToDeliveryScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationWidget()));
  }

  void _navigateToOrderHistoryScreenFromDrawer() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryScreen()))
        .then((_) {
      if (mounted) setState(() => _selectedIndex = 0);
    });
  }

  void _navigateToFeedbackScreen() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen()))
        .then((_) {
      if (mounted) setState(() => _selectedIndex = 0);
    });
  }

  void _navigateToScreenFromDrawer(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen)).then((_) {
      if (mounted) setState(() => _selectedIndex = 0);
    });
  }

  void _logoutUser() async {
    debugPrint('Logging out user...');
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  void _onItemTapped(int index) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) Navigator.pop(context);

    if (_selectedIndex == index && index == 0) {
      _headerAnimationController.reset();
      _searchBarAnimationController.reset();
      _promoBannerAnimationController.reset();
      _popularSectionAnimationController.reset();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _headerAnimationController.forward();
          _searchBarAnimationController.forward();
          _promoBannerAnimationController.forward();
          _popularSectionAnimationController.forward();
        }
      });
      return;
    }

    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        _headerAnimationController.reset();
        _searchBarAnimationController.reset();
        _promoBannerAnimationController.reset();
        _popularSectionAnimationController.reset();
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _headerAnimationController.forward();
            _searchBarAnimationController.forward();
            _promoBannerAnimationController.forward();
            _popularSectionAnimationController.forward();
          }
        });
        break;
      case 1:
        _navigateToCartScreen();
        break;
      case 2:
        _navigateToSearchScreen();
        break;
      case 3:
        _navigateToDeliveryScreen();
        break;
      case 4:
        _navigateToProfileScreen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: _navigateToDeliveryScreen,
          ),
        ],
      ),
      drawer: _buildAppDrawer(),
      body: Container(
        color: AppColors.backgroundWhite,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _headerOffsetAnimation,
                  child: const Text(
                    'Explore Your\nFavorite Food',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimaryDark,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                FadeTransition(
                  opacity: _searchBarFadeAnimation,
                  child: GestureDetector(
                    onTap: _navigateToSearchScreen,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.dividerColor.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: AppColors.textSecondaryDark, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AbsorbPointer(
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  hintText: 'What do you want to order?',
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      color:
                                      AppColors.textSecondaryDark.withOpacity(0.7),
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SlideTransition(
                  position: _promoBannerOffsetAnimation,
                  child: SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        String imagePath = 'assets/promo_banner_${index + 1}.png';
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                debugPrint(
                                    'Error loading banner image: $imagePath. Displaying placeholder.');
                              },
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AssetImage(imagePath) == null
                              ? Center(
                              child: Text('Promo ${index + 1}',
                                  style:
                                  TextStyle(color: AppColors.primaryRed)))
                              : null,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                FadeTransition(
                  opacity: _popularSectionFadeAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Choices',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FoodDetailScreen()),
                          );
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _popularFoodItems.length > 15
                      ? 15
                      : _popularFoodItems.length,
                  itemBuilder: (context, index) {
                    final item = _popularFoodItems[index];
                    return AnimatedBuilder(
                      animation: _popularSectionAnimationController,
                      builder: (context, child) {
                        final animationProgress =
                            _popularSectionAnimationController.value;
                        final itemDelay = index * 0.05;
                        final fadeValue = (animationProgress - itemDelay).clamp(0.0, 1.0);
                        final slideValue = (1 - fadeValue) * 30.0;

                        return Opacity(
                          opacity: fadeValue,
                          child: Transform.translate(
                            offset: Offset(0, slideValue),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: FoodItemCard(
                                imagePath: item.imageUrl,
                                foodName: item.name,
                                restaurantName: item.restaurant,
                                price: item.price,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCartScreen,
        backgroundColor: AppColors.primaryRed,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child:
        const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimaryLight, size: 28),
      ),
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  Widget _buildAppDrawer() {
    String? firstName;
    if (_currentUser?.displayName != null) {
      firstName = _currentUser!.displayName!.split(' ').first;
    }

    return Drawer(
      backgroundColor: AppColors.backgroundWhite,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _currentUser?.photoURL != null
                      ? NetworkImage(_currentUser!.photoURL!)
                      : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                  backgroundColor: AppColors.backgroundWhite,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome, ${firstName ?? 'User'}!',
                  style: const TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _currentUser?.email ?? 'user@example.com',
                  style: const TextStyle(
                    color: AppColors.textSecondaryLight,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
            isSelected: _selectedIndex == 0,
          ),
          _buildDrawerItem(
            icon: Icons.search_outlined,
            title: 'Search',
            onTap: () => _navigateToScreenFromDrawer(const SearchScreen()),
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart_outlined,
            title: 'My Cart',
            onTap: () => _navigateToScreenFromDrawer(
                CartWidget(cartItems: _cartItems, totalPrice: _totalPrice)),
          ),
          _buildDrawerItem(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery Status',
            onTap: () => _navigateToScreenFromDrawer(const NotificationWidget()),
          ),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () => _navigateToScreenFromDrawer(const ProfileWidget()),
          ),
          _buildDrawerItem(
            icon: Icons.history_outlined,
            title: 'Order History',
            onTap: _navigateToOrderHistoryScreenFromDrawer,
          ),
          _buildDrawerItem(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: _navigateToFeedbackScreen,
          ),
          const Divider(
              color: AppColors.dividerColor, indent: 20, endIndent: 20, height: 30),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'App Settings',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings Tapped!')));
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout_outlined,
            title: 'Logout',
            onTap: _logoutUser,
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isLogout = false,
  }) {
    final Color itemColor = isLogout
        ? AppColors.primaryRed
        : (isSelected ? AppColors.primaryRed : AppColors.textPrimaryDark.withOpacity(0.8));
    final Color? tileColor = isSelected ? AppColors.primaryRed.withOpacity(0.08) : null;

    return ListTile(
      tileColor: tileColor,
      leading: Icon(icon, color: itemColor, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontSize: 16,
          fontWeight: isSelected || isLogout ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildCustomNavigationBar() {
    return Container(
      height: 65.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
              icon: _selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
              label: 'Home',
              index: 0),
          _buildNavItem(
              icon: _selectedIndex == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined,
              label: 'Cart',
              index: 1,
              showBadge: _cartItems.isNotEmpty,
              badgeCount: _cartItems.length),
          _buildNavItem(
              icon: _selectedIndex == 2 ? Icons.search : Icons.search_outlined,
              label: 'Search',
              index: 2),
          _buildNavItem(
              icon: _selectedIndex == 3 ? Icons.delivery_dining : Icons.delivery_dining_outlined,
              label: 'Delivery',
              index: 3),
          _buildNavItem(
              icon: _selectedIndex == 4 ? Icons.person : Icons.person_outline,
              label: 'Profile',
              index: 4),
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
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color itemColor = isSelected ? AppColors.primaryRed : AppColors.textSecondaryDark;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, color: itemColor, size: 24),
                  if (showBadge && badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -7,
                      child: Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          badgeCount > 9 ? '9+' : badgeCount.toString(),
                          style: const TextStyle(
                              color: AppColors.textPrimaryLight,
                              fontSize: 9,
                              fontWeight: FontWeight.bold),
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

class FoodItemCard extends StatelessWidget {
  final String imagePath;
  final String foodName;
  final String restaurantName;
  final String price;

  const FoodItemCard({
    super.key,
    required this.imagePath,
    required this.foodName,
    required this.restaurantName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerColor.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 0,
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
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.fastfood_outlined,
                      color: AppColors.textSecondaryDark.withOpacity(0.4), size: 35),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  restaurantName,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark.withOpacity(0.9),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }
}