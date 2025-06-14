import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDashboardScreen extends StatefulWidget {
  const OrderDashboardScreen({super.key});

  @override
  State<OrderDashboardScreen> createState() => _OrderDashboardScreenState();
}

class _OrderDashboardScreenState extends State<OrderDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _cardEntryAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color primaryRedLight = Color(0xFFFFCDD2);
  static const Color accentGreen = Color(0xFF388E3C);
  static const Color accentGreenLight = Color(0xFFC8E6C9);
  static const Color appBackgroundColor = Color(0xFFF4F6F8);
  static const Color cardBackgroundColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF2B2B2B);
  static const Color textSecondaryColor = Color(0xFF6E6E6E);
  static const Color orangeAccent = Colors.deepOrangeAccent;
  static const Color blueAccent = Colors.blueAccent;

  List<Map<String, dynamic>> pendingOrders = [
    {
      'id': '#1001',
      'customer': 'John Doe',
      'items': 3,
      'amount': 45.99,
      'time': '10:30 AM',
      'status': 'Preparing',
    },
    {
      'id': '#1002',
      'customer': 'Jane Smith',
      'items': 5,
      'amount': 78.50,
      'time': '11:15 AM',
      'status': 'Ready for Pickup',
    },
  ];

  List<Map<String, dynamic>> completedOrders = [
    {
      'id': '#0998',
      'customer': 'Sarah Williams',
      'items': 4,
      'amount': 65.25,
      'time': '9:15 AM',
      'completedTime': '10:00 AM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _cardEntryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _cardEntryAnimationController, curve: Curves.easeOutQuad),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _cardEntryAnimationController, curve: Curves.easeOutQuad),
        );

    _cardEntryAnimationController.forward();

    // Check for new order from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        setState(() {
          pendingOrders.insert(0, args);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardEntryAnimationController.dispose();
    super.dispose();
  }

  double get totalEarnings {
    return completedOrders.fold(
        0, (sum, order) => sum + (order['amount'] as num).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Order Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryRed,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.0,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.75),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          tabs: const [
            Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.hourglass_top_rounded), SizedBox(width: 8), Text('Pending')])),
            Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle_outline_rounded), SizedBox(width: 8), Text('Completed')])),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatsSummary(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(pendingOrders, isPending: true, listKey: const ValueKey("pending_orders")),
                _buildOrdersList(completedOrders, isPending: false, listKey: const ValueKey("completed_orders")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: cardBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
          ),
          child: Row(
            children: [
              _buildStatCard(
                title: 'Pending',
                count: pendingOrders.length,
                icon: Icons.access_time_filled_rounded,
                color: orangeAccent,
                iconBgColor: orangeAccent.withOpacity(0.15),
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                title: 'Completed',
                count: completedOrders.length,
                icon: Icons.check_circle_rounded,
                color: accentGreen,
                iconBgColor: accentGreen.withOpacity(0.15),
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                title: 'Earnings',
                count: totalEarnings,
                icon: Icons.insights_rounded,
                color: blueAccent,
                iconBgColor: blueAccent.withOpacity(0.15),
                isCurrency: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required dynamic count,
    required IconData icon,
    required Color color,
    required Color iconBgColor,
    bool isCurrency = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:12, vertical: 16),
        decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0,2)
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: iconBgColor,
                  radius: 20,
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                isCurrency
                    ? NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                    .format(count)
                    : count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, {required bool isPending, required ValueKey listKey}) {
    if (orders.isEmpty) {
      return _buildEmptyState(isPending);
    }
    return ListView.builder(
      key: listKey,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return AnimatedListItem(
          index: index,
          child: _buildOrderCard(orders[index], isPending: isPending),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isPending) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPending ? Icons.hourglass_empty_rounded : Icons.check_circle_outline_rounded,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            isPending ? 'No Pending Orders' : 'No Completed Orders Yet',
            style: TextStyle(
              fontSize: 18,
              color: textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPending ? 'New orders will appear here.' : 'Completed orders will be shown here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {required bool isPending}) {
    final statusColor = isPending ? orangeAccent : accentGreen;
    final statusBgColor = isPending ? orangeAccent.withOpacity(0.1) : accentGreen.withOpacity(0.1);

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order, isPending),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      order['id'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textPrimaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPending ? order['status'] : 'Completed',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Customer: ${order['customer']}',
                style: TextStyle(
                  fontSize: 15,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(Icons.shopping_bag_outlined, '${order['items']} items'),
                  _buildDetailItem(Icons.timer_outlined, order['time']),
                  Text(
                    NumberFormat.currency(symbol: '\$').format(order['amount']),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primaryRed,
                    ),
                  ),
                ],
              ),
              if (!isPending && order['completedTime'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.event_available_rounded, size: 18, color: accentGreen),
                    const SizedBox(width: 6),
                    Text(
                      'Completed: ${order['completedTime']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: accentGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 18),
              _buildActionButtons(order, isPending),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: textSecondaryColor),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: textSecondaryColor),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> order, bool isPending) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.visibility_outlined, size: 20),
            label: const Text('DETAILS'),
            onPressed: () => _showOrderDetails(order, isPending),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryRed, side: BorderSide(color: primaryRed.withOpacity(0.7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ),
        if (isPending) ...[
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline_rounded, size: 20, color: Colors.white),
              label: const Text('COMPLETE'),
              onPressed: () => _completeOrder(order),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                elevation: 2,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showOrderDetails(Map<String, dynamic> order, bool isPending) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        title: Row(
          children: [
            Icon(isPending ? Icons.hourglass_top_rounded : Icons.check_circle_rounded, color: isPending ? orangeAccent : accentGreen, size: 28),
            const SizedBox(width: 10),
            Text('Order ${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              _buildDetailRow('Customer:', order['customer']),
              _buildDetailRow('Items:', order['items'].toString()),
              _buildDetailRow('Amount:', NumberFormat.currency(symbol: '\$').format(order['amount'])),
              _buildDetailRow('Order Time:', order['time']),
              if (isPending)
                _buildDetailRow('Status:', order['status'], statusColor: orangeAccent)
              else
                _buildDetailRow('Completed At:', order['completedTime'], statusColor: accentGreen),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: primaryRed),
            child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: textSecondaryColor, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: statusColor ?? textPrimaryColor, fontWeight: statusColor != null ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  void _completeOrder(Map<String, dynamic> order) {
    final String orderId = order['id'];
    final double orderAmount = order['amount'];

    setState(() {
      pendingOrders.removeWhere((o) => o['id'] == orderId);
      completedOrders.insert(0, {
        ...order,
        'status': 'Completed',
        'completedTime': DateFormat('MMM d, h:mm a').format(DateTime.now()),
      });
      _cardEntryAnimationController.reset();
      _cardEntryAnimationController.forward();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order $orderId marked as completed!'),
          ],
        ),
        backgroundColor: accentGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}

class AnimatedListItem extends StatefulWidget {
  final int index;
  final Widget child;

  const AnimatedListItem({super.key, required this.index, required this.child});

  @override
  _AnimatedListItemState createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 50).clamp(0, 200)),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}