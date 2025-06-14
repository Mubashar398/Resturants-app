import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class EasyPaisaPaymentScreen extends StatefulWidget {
  const EasyPaisaPaymentScreen({super.key});

  @override
  State<EasyPaisaPaymentScreen> createState() => _EasyPaisaPaymentScreenState();
}

class _EasyPaisaPaymentScreenState extends State<EasyPaisaPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _easyPaisaNumberController = TextEditingController();
  final TextEditingController _accountPersonNameController = TextEditingController(); // New controller for account person name

  @override
  void dispose() {
    _amountController.dispose();
    _easyPaisaNumberController.dispose();
    _accountPersonNameController.dispose(); // Dispose the new controller
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      final String amount = _amountController.text;
      final String easyPaisaNumber = _easyPaisaNumberController.text;
      final String accountPersonName = _accountPersonNameController.text; // Get the new field's value

      debugPrint('Processing EasyPaisa payment...');
      debugPrint('Amount: $amount');
      debugPrint('EasyPaisa Number: $easyPaisaNumber');
      debugPrint('Account Person Name: $accountPersonName'); // Log the new field

      // --- Dummy Payment Logic ---
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing payment...'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment Successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Clear all fields after successful payment
          _amountController.clear();
          _easyPaisaNumberController.clear();
          _accountPersonNameController.clear();
        }
      });
      // --- End Dummy Payment Logic ---
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'EasyPaisa Payment',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFCCBC),
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
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 100,
                    color: Colors.green[700],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pay with EasyPaisa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: _easyPaisaNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'EasyPaisa Account Number',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., 03XX-XXXXXXX',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.phone, color: Colors.green),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your EasyPaisa account number';
                      }
                      if (!RegExp(r'^(03\d{9}|[0-9]{11})$').hasMatch(value)) {
                        return 'Enter a valid 11-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // New TextFormField for Account Person Name
                  TextFormField(
                    controller: _accountPersonNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words, // Capitalize words
                    decoration: InputDecoration(
                      labelText: 'Account Person Name',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., Ali Khan',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.person, color: Colors.green),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the account person\'s name';
                      }
                      // You can add more complex name validation if needed
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
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.green),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green, width: 2.0),
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
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
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
                    'Powered by EasyPaisa',
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
