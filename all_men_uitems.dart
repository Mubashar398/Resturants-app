import 'package:flutter/material.dart';
import 'dart:io'; // Required for File object

// Renamed FoodItem.imageUrl to FoodItem.imagePathOrUrl for clarity
class FoodItem {
  final String imagePathOrUrl; // Can be an asset path OR a file path from image_picker
  final String name;
  final String description;
  final double price;
  int quantity;
  final bool isAsset; // True if imagePathOrUrl is an asset, false if it's a file path

  FoodItem({
    required this.imagePathOrUrl,
    required this.name,
    required this.description,
    required this.price,
    this.quantity = 1,
    required this.isAsset,
  });
}

class AllItemScreen extends StatefulWidget {
  final FoodItem? newItem; // Optional new item to be added

  const AllItemScreen({super.key, this.newItem});

  @override
  State<AllItemScreen> createState() => _AllItemScreenState();
}

class _AllItemScreenState extends State<AllItemScreen> {
  // MODIFIED: _foodItems is no longer final
  // Initial sample data
  List<FoodItem> _foodItems = [
    FoodItem(
      imagePathOrUrl: 'assets/crab_soup.png', // Ensure this asset exists
      name: 'Spacy fresh crab (Sample)',
      description: 'Waroenk kita',
      price: 35.0,
      quantity: 10,
      isAsset: true,
    ),
    FoodItem(
      imagePathOrUrl: 'assets/fried_chicken.png', // Ensure this asset exists
      name: 'Fried Chicken (Sample)',
      description: 'Waroenk kita',
      price: 35.0,
      quantity: 15,
      isAsset: true,
    ),
    FoodItem(
      imagePathOrUrl: 'assets/spring_rolls.png', // Ensure this asset exists
      name: 'Spring Rolls (Sample)',
      description: 'Waroenk kita',
      price: 35.0,
      quantity: 10,
      isAsset: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add the new item if it's passed via the constructor
    if (widget.newItem != null) {
      // Use a post-frame callback to ensure setState is called after the first build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) { // Check if the widget is still in the tree
          setState(() {
            _foodItems.add(widget.newItem!);
          });
        }
      });
    }
  }

  void _incrementQuantity(int index) {
    if (mounted) {
      setState(() {
        _foodItems[index].quantity++;
      });
    }
  }

  void _decrementQuantity(int index) {
    if (mounted) {
      setState(() {
        if (_foodItems[index].quantity > 1) {
          _foodItems[index].quantity--;
        }
      });
    }
  }

  void _deleteItem(int index) {
    if (mounted) {
      setState(() {
        _foodItems.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // You could pass back the updated list if needed
          },
        ),
        title: const Text(
          'All Item',
          style: TextStyle(
            fontFamily: 'RobotoSlab', // Ensure this font is in pubspec.yaml
            color: primaryRed,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _foodItems.isEmpty
          ? const Center(
        child: Text(
          'No items added yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final item = _foodItems[index];
          ImageProvider imageProvider;

          if (item.isAsset) {
            imageProvider = AssetImage(item.imagePathOrUrl);
          } else {
            // For images from file path
            if (item.imagePathOrUrl.isNotEmpty) {
              final file = File(item.imagePathOrUrl);
              if (file.existsSync()) {
                imageProvider = FileImage(file);
              } else {
                print("File not found: ${item.imagePathOrUrl}");
                // Fallback to a placeholder if the file doesn't exist
                imageProvider = const AssetImage('assets/placeholder_image.png'); // IMPORTANT: ADD THIS ASSET
              }
            } else {
              print("Empty imagePathOrUrl for non-asset item: ${item.name}");
              imageProvider = const AssetImage('assets/placeholder_image.png'); // Fallback for empty path
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // This onError is for the DecorationImage.
                            // The primary file existence check handles the main issue.
                            print("Error loading image in DecorationImage for ${item.name}: $exception");
                          },
                        ),
                      ),
                      // Optional: Add a child to show text if image fails to load in DecorationImage
                      child: imageProvider is FileImage && !(File(item.imagePathOrUrl).existsSync())
                          ? const Center(child: Icon(Icons.broken_image, color: Colors.grey))
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$ ${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Quantity Controls
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _decrementQuantity(index),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Icon(Icons.remove, size: 18, color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _incrementQuantity(index),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: primaryRed,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Icon(Icons.add, size: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.black54, size: 24),
                      onPressed: () => _deleteItem(index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}