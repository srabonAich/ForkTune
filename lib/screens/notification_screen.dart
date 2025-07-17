import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _secureStorage = const FlutterSecureStorage();
  List<RecipeNotification> _notifications = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://localhost:8080/recipes/notification'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // print("Notification Data: $data");
        setState(() {
          _notifications = data.map((item) => RecipeNotification.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Notifications'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.check_circle_outline),
        //     onPressed: _markAllAsRead,
        //     tooltip: 'Mark all as read',
        //   ),
        // ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load notifications'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchNotifications,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No recipe notifications yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _RecipeNotificationCard(
            notification: notification,
            onTap: () => _handleNotificationTap(notification),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(RecipeNotification notification) {
    // Mark as read if unread
    if (notification.isUnread) {
      setState(() {
        _notifications = _notifications.map((n) =>
        n.id == notification.id ? n.copyWith(isUnread: false) : n
        ).toList();
      });
    }
    // Navigate to recipe detail
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (_) => RecipeDetailScreen(recipeId: notification.recipeId),
    // ));
  }
}

class _RecipeNotificationCard extends StatelessWidget {
  final RecipeNotification notification;
  final VoidCallback onTap;

  const _RecipeNotificationCard({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isUnread
              ? const Color(0xFF7F56D9).withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: notification.isUnread
              ? Border.all(color: const Color(0xFF7F56D9).withOpacity(0.1))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF7F56D9).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant,
                color: Color(0xFF7F56D9),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notification.isUnread
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (notification.isUnread)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF7F56D9),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                      DateFormat('MMM d, h:mm a').format(notification.time.toLocal()),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      // Text(
                      //   'View Recipe',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: const Color(0xFF7F56D9),
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                    ],
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

class RecipeNotification {
  final int id;
  final String message;
  final DateTime time;
  final bool isUnread;
  final int recipeId;

  RecipeNotification({
    required this.id,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.recipeId,
  });

  factory RecipeNotification.fromJson(Map<String, dynamic> json) {
    return RecipeNotification(
      id: json['id'],
      message: json['message'],
      time: DateTime.parse(json['time']),
      isUnread: json['unread'],
      recipeId: int.parse(json['recipeId'].toString()),  // Fix for type mismatch
    );
  }

  RecipeNotification copyWith({
    int? id,
    String? message,
    DateTime? time,
    bool? isUnread,
    int? recipeId,
  }) {
    return RecipeNotification(
      id: id ?? this.id,
      message: message ?? this.message,
      time: time ?? this.time,
      isUnread: isUnread ?? this.isUnread,
      recipeId: recipeId ?? this.recipeId,
    );
  }
}
