import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:jh_flutter_demo/jh_common/jh_common.dart';

import 'pay_out_notification.dart';
import 'easypaise.dart';
import 'jazzcash.dart';
import 'banktransfer.dart';
import 'admin_order_panding.dart';

class Country {
  final String name;
  final String code;
  final String flag;

  Country({required this.name, required this.code, this.flag = "🇵🇰"});
}

enum PaymentMethod { cashOnDelivery, jazzcash, easypaisa, bankTransfer }

class PayoutWidget extends StatefulWidget {
  const PayoutWidget({super.key});

  @override
  _PayoutWidgetState createState() => _PayoutWidgetState();
}

class _PayoutWidgetState extends State<PayoutWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  String _name = 'John Doe';
  String _address = '123 Main Street, City, Country';
  String _phoneNumber = '1234567890';
  Country? _selectedCountry;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;

  final List<Country> _countries = [
    Country(name: "Pakistan", code: "+92", flag: "🇵🇰"),
    Country(name: "India", code: "+91", flag: "🇮🇳"),
    Country(name: "USA", code: "+1", flag: "🇺🇸"),
    Country(name: "UK", code: "+44", flag: "🇬🇧"),
    Country(name: "Canada", code: "+1", flag: "🇨🇦"),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _name);
    _addressController = TextEditingController(text: _address);
    _phoneController = TextEditingController(text: _phoneNumber);
    _selectedCountry = _countries.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendSms(String phoneNumber, String message) async {
    final uri = Uri.parse('sms:$phoneNumber?body=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open SMS app.')),
      );
    }
  }

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _printOrderDetails();

      String fullPhoneNumber = '${_selectedCountry?.code ?? ''}${_phoneController.text.trim()}';
      String smsMessage = 'Your order has been placed successfully! Thank you for your purchase.';

      _sendSms(fullPhoneNumber, smsMessage);

      // Create order data
      final orderData = {
        'id': '#${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        'customer': _nameController.text,
        'items': 3, // You should replace with actual item count
        'amount': 99.99, // You should replace with actual amount
        'time': DateFormat('h:mm a').format(DateTime.now()),
        'status': 'Pending',
      };

      // Navigate based on payment method
      switch (_selectedPaymentMethod) {
        case PaymentMethod.easypaisa:
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EasyPaisaPaymentScreen()));
          break;
        case PaymentMethod.jazzcash:
          Navigator.push(context, MaterialPageRoute(builder: (context) => const JazzCashPaymentScreen()));
          break;
        case PaymentMethod.bankTransfer:
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BankTransferPaymentScreen()));
          break;
        case PaymentMethod.cashOnDelivery:
        // For Cash on Delivery, go to notification then admin orders
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PayoutnotifiationWidget(
                onContinue: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDashboardScreen(),
                      settings: RouteSettings(arguments: 'pending'),
                    ),
                  );
                },
              ),
            ),
          );
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }

  void _printOrderDetails() {
    debugPrint('Order Details:');
    debugPrint('Name: $_name');
    debugPrint('Address: $_address');
    debugPrint('Phone: ${_selectedCountry?.code ?? ''} $_phoneNumber');
    debugPrint('Payment Method: $_selectedPaymentMethod');
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFD32F2F);
    const Color lightRed = Color(0xFFFFCDD2);
    const Color textColor = Color(0xFF212121);
    const Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: whiteColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Shipping Information", Icons.local_shipping_outlined, textColor),
              const SizedBox(height: 24),
              _NeumorphicTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? 'Name cannot be empty' : null,
                backgroundColor: lightRed,
                textColor: textColor,
                iconColor: textColor,
                labelColor: Colors.black54,
              ),
              const SizedBox(height: 20),
              _NeumorphicTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.home_outlined,
                validator: (v) => v!.isEmpty ? 'Address cannot be empty' : null,
                backgroundColor: lightRed,
                textColor: textColor,
                iconColor: textColor,
                labelColor: Colors.black54,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<Country>(
                      decoration: _neumorphicInputDecoration(
                        label: 'Country',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(_selectedCountry?.flag ?? '🌍', style: const TextStyle(fontSize: 22)),
                        ),
                        backgroundColor: lightRed,
                        labelColor: Colors.black54,
                      ),
                      dropdownColor: lightRed.withOpacity(0.9),
                      value: _selectedCountry,
                      items: _countries.map((Country country) {
                        return DropdownMenuItem<Country>(
                          value: country,
                          child: Text(
                            '${country.name} (${country.code})',
                            style: const TextStyle(color: textColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (Country? newValue) => setState(() => _selectedCountry = newValue),
                      validator: (v) => v == null ? 'Required' : null,
                      style: const TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: _NeumorphicTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.length < 7 ? 'Enter a valid number' : null,
                      backgroundColor: lightRed,
                      textColor: textColor,
                      iconColor: textColor,
                      labelColor: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle("Payment Method", Icons.payment_outlined, textColor),
              const SizedBox(height: 24),
              _NeumorphicPaymentOption(
                title: 'Cash on Delivery',
                assetImage: 'assets/images/Cashondelivery1.png',
                value: PaymentMethod.cashOnDelivery,
                groupValue: _selectedPaymentMethod,
                onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                accentColor: primaryRed,
                backgroundColor: lightRed,
                textColor: textColor,
              ),
              _NeumorphicPaymentOption(
                title: 'Jazzcash',
                assetImage: 'assets/images/jazzcash_logo.png',
                value: PaymentMethod.jazzcash,
                groupValue: _selectedPaymentMethod,
                onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                accentColor: primaryRed,
                backgroundColor: lightRed,
                textColor: textColor,
              ),
              _NeumorphicPaymentOption(
                title: 'Easypaisa',
                assetImage: 'assets/images/easypaisa_logo.png',
                value: PaymentMethod.easypaisa,
                groupValue: _selectedPaymentMethod,
                onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                accentColor: primaryRed,
                backgroundColor: lightRed,
                textColor: textColor,
              ),
              _NeumorphicPaymentOption(
                title: 'Bank Transfer',
                iconData: Icons.account_balance,
                value: PaymentMethod.bankTransfer,
                groupValue: _selectedPaymentMethod,
                onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                accentColor: primaryRed,
                backgroundColor: lightRed,
                textColor: textColor,
              ),
              const SizedBox(height: 40),
              _NeumorphicButton(
                onTap: _placeOrder,
                buttonColor: primaryRed,
                child: const Text(
                  'Place My Order',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  InputDecoration _neumorphicInputDecoration({
    String? label,
    Widget? prefixIcon,
    required Color backgroundColor,
    required Color labelColor,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: labelColor),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: backgroundColor,
      border: InputBorder.none,
    );
  }
}

class _NeumorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color labelColor;

  const _NeumorphicTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(4, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: labelColor),
          prefixIcon: Icon(icon, color: iconColor),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _NeumorphicPaymentOption extends StatelessWidget {
  final String title;
  final String? assetImage;
  final IconData? iconData;
  final PaymentMethod value;
  final PaymentMethod groupValue;
  final void Function(PaymentMethod?) onChanged;
  final Color accentColor;
  final Color backgroundColor;
  final Color textColor;

  const _NeumorphicPaymentOption({
    required this.title,
    this.assetImage,
    this.iconData,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.accentColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    Widget leadingWidget;
    if (assetImage != null) {
      leadingWidget = Image.asset(assetImage!, width: 40, height: 40, fit: BoxFit.contain);
    } else {
      leadingWidget = Icon(iconData, size: 30, color: isSelected ? accentColor : textColor);
    }

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(4, 4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(-4, -4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ]
              : [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(4, 4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? accentColor : textColor),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentColor : Colors.transparent,
                border: Border.all(color: isSelected ? accentColor : Colors.grey.shade400, width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            )
          ],
        ),
      ),
    );
  }
}

class _NeumorphicButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color buttonColor;

  const _NeumorphicButton({required this.onTap, required this.child, required this.buttonColor});

  @override
  __NeumorphicButtonState createState() => __NeumorphicButtonState();
}

class __NeumorphicButtonState extends State<_NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.buttonColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: widget.buttonColor.withOpacity(0.5),
              offset: const Offset(5, 5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}