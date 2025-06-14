import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DiscountType { percentage, fixed }

class Order {
  final String id;
  final int itemCount;
  final double subtotal;
  final String customerName;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.itemCount,
    required this.subtotal,
    required this.customerName,
    required this.orderDate,
  });
}

class AdminMoneyHoldScreen extends StatefulWidget {
  const AdminMoneyHoldScreen({super.key});

  @override
  State<AdminMoneyHoldScreen> createState() => _AdminMoneyHoldScreenState();
}

class _AdminMoneyHoldScreenState extends State<AdminMoneyHoldScreen> {
  final _formKey = GlobalKey<FormState>();
  double? _receivedAmount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the amount from the arguments when the screen is pushed
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is double) {
      _receivedAmount = args;
    }
  }

  // Dummy order data
  final List<Order> _dummyOrders = [
    Order(id: '12345', itemCount: 3, subtotal: 125.75, customerName: 'John Doe', orderDate: DateTime(2025, 6, 1)),
    Order(id: '12346', itemCount: 5, subtotal: 200.00, customerName: 'Jane Smith', orderDate: DateTime(2025, 6, 2)),
    Order(id: '12347', itemCount: 2, subtotal: 75.50, customerName: 'Alice Johnson', orderDate: DateTime(2025, 6, 3)),
  ];

  late Order _selectedOrder;

  double _taxRate = 8.5;
  double _discount = 0.0;
  DiscountType _discountType = DiscountType.percentage;
  double _tip = 0.0;
  bool _splitBill = false;
  int _splitCount = 2;

  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();

  double get _taxAmount => _selectedOrder.subtotal * (_taxRate / 100);
  double get _discountAmount {
    if (_discountType == DiscountType.percentage) {
      return _selectedOrder.subtotal * (_discount / 100);
    } else {
      return _discount;
    }
  }
  double get _total => _selectedOrder.subtotal + _taxAmount - _discountAmount + _tip;
  double get _perPerson => _splitBill ? _total / _splitCount : _total;

  @override
  void initState() {
    super.initState();
    _selectedOrder = _dummyOrders.first;
    _discountController.text = _discount.toStringAsFixed(2);
    _tipController.text = _tip.toStringAsFixed(2);

    // If we received an amount from the dashboard, create a new order with it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_receivedAmount != null) {
        final newOrder = Order(
          id: 'NEW-${DateTime.now().millisecondsSinceEpoch}',
          itemCount: 1,
          subtotal: _receivedAmount!,
          customerName: 'New Order',
          orderDate: DateTime.now(),
        );

        setState(() {
          _dummyOrders.insert(0, newOrder);
          _selectedOrder = newOrder;
        });
      }
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Payment Confirmation", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID: ${_selectedOrder.id}"),
              Text("Customer: ${_selectedOrder.customerName}"),
              Text("Total Amount: ${_formatCurrency(_total)}"),
              if (_splitBill) Text("Split across $_splitCount people: ${_formatCurrency(_perPerson)} each"),
              const SizedBox(height: 10),
              const Text("Are you sure you want to confirm this payment?", style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPaymentSuccessDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
              ),
              child: const Text("CONFIRM", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Successful!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            const SizedBox(height: 15),
            Text("Amount: ${_formatCurrency(_total)} has been processed."),
            const SizedBox(height: 10),
            Text("Order ID: ${_selectedOrder.id}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: "\$", decimalDigits: 2).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Money On Hold",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Selection/Summary
              _buildOrderSelection(),
              const SizedBox(height: 24),

              // Discount Section
              _buildSectionTitle('Discount'),
              const SizedBox(height: 8),
              _buildDiscountSection(),
              const SizedBox(height: 20),

              // Tax Section
              _buildSectionTitle('Tax Rate'),
              const SizedBox(height: 8),
              _buildTaxSection(),
              const SizedBox(height: 20),

              // Tip Section
              _buildSectionTitle('Add Tip'),
              const SizedBox(height: 8),
              _buildTipSection(),
              const SizedBox(height: 20),

              // Bill Splitting
              _buildSectionTitle('Bill Splitting'),
              const SizedBox(height: 8),
              _buildSplitSection(),
              const SizedBox(height: 30),

              // Total Section
              _buildTotalSection(),
              const SizedBox(height: 30),

              // Payment Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFFF5252)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _processPayment,
                  child: const Text(
                    "CONFIRM PAYMENT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildOrderSelection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Order",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Order>(
              value: _selectedOrder,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              items: _dummyOrders.map((order) {
                return DropdownMenuItem(
                  value: order,
                  child: Text("Order #${order.id} - ${order.customerName}"),
                );
              }).toList(),
              onChanged: (order) {
                if (order != null) {
                  setState(() {
                    _selectedOrder = order;
                    _discount = 0.0;
                    _tip = 0.0;
                    _discountController.text = _discount.toStringAsFixed(2);
                    _tipController.text = _tip.toStringAsFixed(2);
                  });
                }
              },
            ),
            const SizedBox(height: 15),
            _buildPaymentDetailRow(
              "Subtotal",
              _formatCurrency(_selectedOrder.subtotal),
              Icons.attach_money,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildPaymentDetailRow(
              "Items (${_selectedOrder.itemCount})",
              DateFormat('MMM d, yyyy').format(_selectedOrder.orderDate),
              Icons.shopping_bag_outlined,
              Colors.blue,
              showViewDetails: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetailRow(String label, String value, IconData icon, Color iconColor, {bool showViewDetails = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const Spacer(),
        if (showViewDetails)
          TextButton(
            onPressed: () { /* Show order items dialog */ },
            child: const Text(
              "View Details",
              style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w600),
            ),
          )
        else
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Discount Amount',
                      prefixText: _discountType == DiscountType.percentage ? "" : "\$",
                      suffixText: _discountType == DiscountType.percentage ? "%" : "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _discount = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<DiscountType>(
                    value: _discountType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                    items: DiscountType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type == DiscountType.percentage ? "Percentage" : "Fixed Amount"),
                      );
                    }).toList(),
                    onChanged: (type) {
                      if (type != null) {
                        setState(() {
                          _discountType = type;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Applied Discount: ${_formatCurrency(_discountAmount)}",
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _taxRate,
                    min: 0,
                    max: 20,
                    divisions: 40,
                    label: "${_taxRate.toStringAsFixed(1)}%",
                    onChanged: (value) => setState(() => _taxRate = value),
                    activeColor: const Color(0xFFE53935),
                    inactiveColor: Colors.red.shade100,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${_taxRate.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Tax Amount: ${_formatCurrency(_taxAmount)}",
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [5.0, 10.0, 15.0, 20.0].map((amount) {
                return ChoiceChip(
                  label: Text(_formatCurrency(amount)),
                  selected: _tip == amount,
                  selectedColor: const Color(0xFFE53935).withOpacity(0.7),
                  labelStyle: TextStyle(
                    color: _tip == amount ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _tip = selected ? amount : 0.0;
                      _tipController.text = _tip.toStringAsFixed(2);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _tipController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Custom Tip Amount",
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE53935), width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _tip = double.tryParse(value) ?? 0.0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Split Bill",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: _splitBill,
                  onChanged: (value) => setState(() => _splitBill = value),
                  activeColor: const Color(0xFFE53935),
                ),
              ],
            ),
            if (_splitBill) ...[
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFE53935)),
                    onPressed: () {
                      if (_splitCount > 1) {
                        setState(() => _splitCount--);
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      "$_splitCount People",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE53935)),
                    onPressed: () => setState(() => _splitCount++),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Each person pays: ${_formatCurrency(_perPerson)}",
                style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade100.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTotalRow("Subtotal", _selectedOrder.subtotal, Colors.black87),
          _buildTotalRow("Discount", -_discountAmount, Colors.red),
          _buildTotalRow("Tax", _taxAmount, Colors.blue),
          if (_tip > 0) _buildTotalRow("Tip", _tip, Colors.purple),
          const Divider(height: 30, thickness: 1.5, color: Colors.grey),
          _buildTotalRow("GRAND TOTAL", _total, const Color(0xFFE53935), isGrandTotal: true),
          if (_splitBill) ...[
            const SizedBox(height: 10),
            Text(
              "($_splitCount × ${_formatCurrency(_perPerson)} each)",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
            )
          ],
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, Color valueColor, {bool isGrandTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isGrandTotal ? 19 : 16,
              fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.normal,
              color: isGrandTotal ? Colors.black87 : Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            (amount < 0 ? "-" : "") + _formatCurrency(amount.abs()),
            style: TextStyle(
              fontSize: isGrandTotal ? 22 : 17,
              fontWeight: isGrandTotal ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}