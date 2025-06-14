// out_for_delivery.dart
import 'package:flutter/material.dart';

// Enum to define payment status for clarity
enum PaymentStatus {
  received,
  notReceived,
}

// Data model for a delivery order
class DeliveryOrder {
  final String customerName;
  final PaymentStatus paymentStatus;
  final bool isDelivered; // true for Delivered, false for not yet delivered

  DeliveryOrder({
    required this.customerName,
    required this.paymentStatus,
    this.isDelivered = true, // Defaulting as per your comment
  });
}

class OutForDeliveryScreen extends StatefulWidget {
  const OutForDeliveryScreen({super.key});

  @override
  State<OutForDeliveryScreen> createState() => _OutForDeliveryScreenState();
}

class _OutForDeliveryScreenState extends State<OutForDeliveryScreen> {
  // Sample data for delivery orders
  final List<DeliveryOrder> _deliveryOrders = [
    DeliveryOrder(
      customerName: 'Customer Name 1', // Made names unique for clarity
      paymentStatus: PaymentStatus.notReceived,
    ),
    DeliveryOrder(
      customerName: 'Customer Name 2',
      paymentStatus: PaymentStatus.received,
    ),
    DeliveryOrder(
      customerName: 'Customer Name 3',
      paymentStatus: PaymentStatus.notReceived,
    ),
    // Add more sample orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);
    const Color deliveredGreen = Color(0xFF8BC34A);
    const Color notReceivedRed = Color(0xFFE53935);
    const Color receivedGreen = Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Out For Delivery',
          style: TextStyle(
            fontFamily: 'RobotoSlab', // Ensure this font is in pubspec.yaml and assets
            color: primaryRed,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _deliveryOrders.isEmpty
          ? const Center(
        child: Text(
          'No orders currently out for delivery!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _deliveryOrders.length,
        itemBuilder: (context, index) {
          final order = _deliveryOrders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Payment',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order.paymentStatus == PaymentStatus.received
                                ? 'Received'
                                : 'Not Received',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: order.paymentStatus ==
                                  PaymentStatus.received
                                  ? receivedGreen
                                  : notReceivedRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          order.isDelivered ? 'Delivered' : 'Pending',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: order.isDelivered
                                ? deliveredGreen
                                : Colors.orange, // Orange for pending
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
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