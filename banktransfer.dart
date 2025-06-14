import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class BankTransferPaymentScreen extends StatefulWidget {
  const BankTransferPaymentScreen({super.key});

  @override
  State<BankTransferPaymentScreen> createState() => _BankTransferPaymentScreenState();
}

class _BankTransferPaymentScreenState extends State<BankTransferPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Dummy Bank Details (In a real app, these might come from an API or configuration)
  static const String _bankName = 'Food Bank International';
  static const String _iban = 'PKXX FOOD XXXX XXXX XXXX XXXX XXXX';
  static const String _swiftCode = 'FOODPKKA';

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountHolderNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _processTransfer() {
    if (_formKey.currentState!.validate()) {
      final String accountNumber = _accountNumberController.text;
      final String accountHolderName = _accountHolderNameController.text;
      final String amount = _amountController.text;

      debugPrint('Processing Bank Transfer...');
      debugPrint('Account Number: $accountNumber');
      debugPrint('Account Holder Name: $accountHolderName');
      debugPrint('Amount: $amount');

      // --- Dummy Payment Logic ---
      // In a real application, you would send this data to your backend
      // which would then interact with your payment gateway/bank API.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Initiating bank transfer...'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          // Simulate success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bank Transfer initiated! Please complete transfer from your bank app.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
          // You might navigate to a success screen or clear fields
          _accountNumberController.clear();
          _accountHolderNameController.clear();
          _amountController.clear();
          // Optionally pop back to previous screen after a delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      });
      // --- End Dummy Payment Logic ---
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set Scaffold background to transparent to show the Container's gradient
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Bank Transfer',
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
                  // Bank Icon
                  Icon(
                    Icons.account_balance,
                    size: 100,
                    color: Colors.blueGrey[700], // A suitable color for bank
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Complete Bank Transfer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black, // Dark text for readability
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Bank Details to Copy
                  _buildInfoCard(
                    title: 'Our Bank Details',
                    children: [
                      _buildInfoRow('Bank Name:', _bankName),
                      _buildInfoRow('IBAN:', _iban, isCopyable: true),
                      _buildInfoRow('SWIFT Code:', _swiftCode, isCopyable: true),
                    ],
                  ),
                  const SizedBox(height: 30.0),

                  // User Input Fields
                  TextFormField(
                    controller: _accountNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Your Bank Account Number',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., 1234567890',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.credit_card, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueGrey.shade700!, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your bank account number';
                      }
                      // Basic validation: at least 5 digits
                      if (value.length < 5 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Enter a valid account number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _accountHolderNameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Your Account Holder Name',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., Jane Doe',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.person, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueGrey.shade700!, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your account holder name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount Transferred',
                      labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'e.g., 500.00',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.4)),
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.blueGrey.shade700!, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the amount transferred';
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
                      backgroundColor: Colors.red, // Use red for consistency with app theme
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _processTransfer,
                    child: const Text(
                      'Confirm Transfer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'You will receive a confirmation once the transfer is verified.',
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

  // Helper widget to build information cards
  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      color: Colors.white.withOpacity(0.9), // Slightly transparent white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  // Helper widget to build a row for information display with copy option
  Widget _buildInfoRow(String label, String value, {bool isCopyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isCopyable)
            IconButton(
              icon: const Icon(Icons.copy, size: 18, color: Colors.blueGrey),
              onPressed: () {
                // Implement copy to clipboard functionality
                // For Flutter, you'd typically use:
                // Clipboard.setData(ClipboardData(text: value));
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('$label copied!')),
                // );
                debugPrint('Copied: $value');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$label copied to clipboard! (Dummy)')),
                );
              },
            ),
        ],
      ),
    );
  }
}
