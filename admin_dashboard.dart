import 'package:flutter/material.dart';
import 'add_menu.dart';
import 'all_men_uitems.dart';
import 'out_for_delivery.dart';
import 'admin_feedback.dart';
import 'admin_profile.dart';
import 'create_new_user_admin.dart';
import 'admin_login.dart';
import 'admin_money_hold.dart';
import 'admin_order_panding.dart'; // Import the orders screen

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Widget _buildDashboardItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFFE53935),
    Color backgroundColor = const Color(0xFFFCE4EC),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardItem({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
    required BuildContext context,
    required String tab,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderDashboardScreen(),
            settings: RouteSettings(arguments: tab),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 16,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryRed = Color(0xFFE53935);
    const Color lightPinkButtonBg = Color(0xFFFDECEA);
    const double targetAspectRatio = 150 / 100;

    final List<Map<String, dynamic>> dashboardItemsData = [
    {
      'icon': Icons.add_circle_outline,
    'label': 'Add Menu',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AddItemScreen()),
    )},
    {
    'icon': Icons.menu_book_outlined,
    'label': 'All Item Menu',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AllItemScreen()),
    ),
    },
    {
    'icon': Icons.delivery_dining_outlined,
    'label': 'Out For Delivery',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const OutForDeliveryScreen()),
    ),
    },
    {
    'icon': Icons.feedback_outlined,
    'label': 'Feedback',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AdminFeedbackScreen()),
    ),
    },
    {
    'icon': Icons.person_outline,
    'label': 'Profile',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
    ),
    },
    {
    'icon': Icons.account_balance_wallet_outlined,
    'label': 'Money On Hold',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AdminMoneyHoldScreen()),
    ),
    },
    {
    'icon': Icons.person_add_alt_1_outlined,
    'label': 'Create New User',
    'onTap': () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CreateNewUserAdminScreen()),
    ),
    },
    {
    'icon': Icons.logout_outlined,
    'label': 'Log Out',
    'onTap': () => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const AdminLogin()),
    (Route<dynamic> route) => false,
    ),
    },
    ];

    return Scaffold(
    backgroundColor: Colors.grey.shade100,
    body: SafeArea(
    child: SingleChildScrollView(
    padding: const EdgeInsets.all(12.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    const SizedBox(height: 16),
    Row(
    children: [
    CircleAvatar(
    backgroundColor: primaryRed.withOpacity(0.1),
    radius: 18,
    child: const Icon(
    Icons.restaurant_menu,
    color: primaryRed,
    size: 20,
    ),
    ),
    const SizedBox(width: 8),
    const Text(
    'Waves Of Food',
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryRed,
    fontFamily: 'Montserrat',
    ),
    ),
    ],
    ),
    const SizedBox(height: 16),
    Card(
    elevation: 1.0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
    child: IntrinsicHeight(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
    Expanded(
    child: _buildSummaryCardItem(
    icon: Icons.info_outline,
    count: '30',
    label: 'Pending Order',
    color: Colors.orange.shade700,
    context: context,
    tab: 'pending',
    ),
    ),
    const VerticalDivider(thickness: 0.8, indent: 8, endIndent: 8),
    Expanded(
    child: _buildSummaryCardItem(
    icon: Icons.check_circle_outline,
    count: '10',
    label: 'Completed order',
    color: Colors.green.shade600,
    context: context,
    tab: 'completed',
    ),
    ),
    const VerticalDivider(thickness: 0.8, indent: 8, endIndent: 8),
    Expanded(
    child: _buildSummaryCardItem(
    icon: Icons.monetization_on_outlined,
    count: '100\$',
    label: 'Total Earning',
    color: Colors.blue.shade600,
    context: context,
    tab: 'earnings',
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    const SizedBox(height: 16),
    GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: targetAspectRatio,
    children: dashboardItemsData.map((data) {
    return _buildDashboardItem(
    icon: data['icon'] as IconData,
    label: data['label'] as String,
    onTap: data['onTap'] as VoidCallback,
    backgroundColor: lightPinkButtonBg,
    iconColor: primaryRed,
    );
    }).toList(),
    ),
    const SizedBox(height: 20),
    Center(
    child: Column(
    children: [
    const Text(
    'Design By',
    style: TextStyle(
    fontSize: 12,
    color: Colors.grey,
    ),
    ),
    const Text(
    'NeatRoots',
    style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: primaryRed,
    fontFamily: 'Montserrat',
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 12),
    ],
    ),
    ),
    ),
    );
    }
}