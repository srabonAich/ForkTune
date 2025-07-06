import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              // Mark all as read functionality
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            icon: Icons.restaurant,
            title: "New recipe suggestion",
            message: "Try our new Chicken Alfredo Pasta recipe based on your preferences",
            time: DateTime.now().subtract(const Duration(minutes: 15)),
            isUnread: true,
            color: const Color(0xFF7F56D9),
          ),
          _buildNotificationItem(
            icon: Icons.calendar_today,
            title: "Meal plan reminder",
            message: "Don't forget to plan your meals for tomorrow",
            time: DateTime.now().subtract(const Duration(hours: 2)),
            isUnread: true,
            color: Colors.orange,
          ),
          _buildNotificationItem(
            icon: Icons.star,
            title: "Weekly summary",
            message: "You've cooked 5 recipes this week! View your cooking stats",
            time: DateTime.now().subtract(const Duration(days: 1)),
            isUnread: false,
            color: Colors.amber,
          ),
          _buildNotificationItem(
            icon: Icons.shopping_cart,
            title: "Grocery list updated",
            message: "3 items on your list are on sale at your local store",
            time: DateTime.now().subtract(const Duration(days: 2)),
            isUnread: false,
            color: Colors.green,
          ),
          _buildNotificationItem(
            icon: Icons.account_circle,
            title: "New follower",
            message: "ChefMaster started following you",
            time: DateTime.now().subtract(const Duration(days: 3)),
            isUnread: false,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String message,
    required DateTime time,
    required bool isUnread,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isUnread ? color.withOpacity(0.05) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('MMM d, h:mm a').format(time),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
