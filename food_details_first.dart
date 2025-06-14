import 'package:flutter/material.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange), // Orange back arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Multi-VendorFood Ordering System',
          style: TextStyle(
            color: Colors.red, // Red text color for the title
            fontSize: 20,
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
            // Restaurant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners for the image
              child: Image.asset(
                'assets/restaurant_interior.jpg', // Replace with your actual image path
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),

            // Short Description Title
            const Text(
              'Short description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),

            // Short Description Content
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5, // Line spacing
              ),
            ),
            const SizedBox(height: 20.0),

            // Menu Title
            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10.0),

            // Menu Items
            _buildMenuItem('Noddle'),
            _buildMenuItem('Salad'),
            _buildMenuItem('Burger'),
            _buildMenuItem('Herbal Pan Cake'),
            _buildMenuItem('Momos'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String itemName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.black54), // Bullet point
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            'See Details',
            style: TextStyle(
              color: Colors.red[700], // Red color for "See Details"
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8.0),
          Icon(Icons.check_box, color: Colors.red[700]), // Red checkbox
        ],
      ),
    );
  }
}