import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // "Hello, lorem ipsum" section
            const Text(
              'Hello, lorem ipsum',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Yeon Sung', // Ensure this font is available in your pubspec.yaml
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
            const SizedBox(height: 30), // Space after greeting

            // "Your order has been Canceled Successfully" notification
            NotificationCard(
              icon: Icons.sentiment_dissatisfied_outlined, // Sad emoji
              iconColor: const Color.fromRGBO(187, 12, 36, 1), // Red-ish color
              message: 'Your order has been Canceled Successfully',
              messageColor: const Color.fromRGBO(187, 12, 36, 1),
              // No time for this one based on your image
            ),
            const SizedBox(height: 20), // Space between notifications

            // "Order has been taken by the driver" notification with location icon
            NotificationCard(
              icon: Icons.local_shipping, // Location icon (using shipping as it fits "driver")
              iconColor: const Color.fromRGBO(187, 12, 36, 1),
              message: 'Order has been taken by the driver',
              messageColor: const Color.fromRGBO(187, 12, 36, 1),
            ),
            const SizedBox(height: 20), // Space between notifications

            // "Congrats Your Order Placed" notification with checkmark/smile emoji
            NotificationCard(
              icon: Icons.sentiment_satisfied_alt, // Smile emoji
              iconColor: const Color.fromRGBO(20, 190, 119, 1), // Green color
              message: 'Congrats Your Order Placed',
              messageColor: const Color.fromRGBO(187, 12, 36, 1), // Message text color
            ),
            const SizedBox(height: 20), // Space after last notification
            // You can add more NotificationCard widgets here for other notifications
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for a single notification item
class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;
  final Color messageColor;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.message,
    required this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Consistent horizontal padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28, // Adjusted icon size for better visibility
          ),
          const SizedBox(width: 15), // Space between icon and text
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: messageColor,
                fontFamily: 'Lato', // Ensure this font is available in your pubspec.yaml
                fontSize: 15,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}