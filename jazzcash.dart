import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class JazzCashPaymentScreen extends StatefulWidget {
  const JazzCashPaymentScreen({super.key});

  @override
  State<JazzCashPaymentScreen> createState() => _JazzCashPaymentScreenState();
}

class _JazzCashPaymentScreenState extends State<JazzCashPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _jazzCashNumberController = TextEditingController();
  final TextEditingController _accountPersonNameController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _jazzCashNumberController.dispose();
    _accountPersonNameController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      final String amount = _amountController.text;
      final String jazzCashNumber = _jazzCashNumberController.text;
      final String accountPersonName = _accountPersonNameController.text;

      debugPrint('Processing JazzCash payment...');
      debugPrint('Amount: $amount');
      debugPrint('JazzCash Number: $jazzCashNumber');
      debugPrint('Account Person Name: $accountPersonName');

      // --- Dummy Payment Logic ---
      // In a real application, you would send this data to your backend
      // which would then interact with the JazzCash API.

      // Simulate a successful payment after a delay
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing payment...'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          // Simulate success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment Successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Clear all fields after successful payment
          _amountController.clear();
          _jazzCashNumberController.clear();
          _accountPersonNameController.clear();
        }
      });
      // --- End Dummy Payment Logic ---
    }
  }

  @override
  Widget build(BuildContext context) {
    // JazzCash often uses a dark green/teal color
    final Color jazzCashGreen = Colors.green.shade800; // A darker, richer green
    final Color jazzCashLightGreen = Colors.green.shade600; // A slightly lighter green for accents

    return Scaffold(
      // Set Scaffold background to transparent to show the Container's gradient
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'JazzCash Payment',
          style: TextStyle(color: Colors.black87), // Darker text for contrast
        ),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // No shadow
        iconTheme: const IconThemeData(color: Colors.black87), // Darker icon for contrast
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        // The Container now holds the gradient background for the entire body
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Start with a very light, warm orange (consistent with other screens)
              Color(0xFFFFF3E0), // Equivalent to a very light orange/cream
              // End with a soft peach color (consistent with other screens)
              Color(0xFFFFCCBC), // Equivalent to a light peach
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // JazzCash Logo/Icon (Placeholder)
                  Icon(
                    Icons.account_balance_wallet_outlined, // Or a custom JazzCash icon if you have one
                    size: 100,
                    color: jazzCashGreen, // JazzCash green
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pay with JazzCash',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black, // Dark text for readability
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _jazzCashNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'JazzCash Account Number',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., 03XX-XXXXXXX',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: Icon(Icons.phone, color: jazzCashLightGreen), // JazzCash accent color
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8), // Slightly transparent white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: jazzCashGreen, width: 2.0), // JazzCash accent color
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your JazzCash account number';
                      }
                      if (!RegExp(r'^(03\d{9}|[0-9]{11})$').hasMatch(value)) {
                        return 'Enter a valid 11-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _accountPersonNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words, // Capitalize words
                    decoration: InputDecoration(
                      labelText: 'Account Person Name',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., Ali Khan',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: Icon(Icons.person, color: jazzCashLightGreen), // JazzCash accent color
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: jazzCashGreen, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the account person\'s name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., 500.00',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: Icon(Icons.attach_money, color: jazzCashLightGreen), // JazzCash accent color
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: jazzCashGreen, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the amount';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jazzCashGreen, // JazzCash green for button
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5, // Add a subtle shadow
                    ),
                    onPressed: _processPayment,
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'Powered by JazzCash',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
