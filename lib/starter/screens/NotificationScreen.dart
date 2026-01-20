// screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:ietp_project/starter/model/hive_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/arduino_provider.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirmed = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Notifications'),
                  content: const Text('Are you sure you want to clear all notifications?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                await Provider.of<ArduinoProvider>(context, listen: false)
                    .clearNotifications();
              }
            },
          ),
        ],
      ),
      body: Consumer<ArduinoProvider>(
        builder: (context, provider, child) {
          final notifications = provider.getNotifications();
          
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification, provider, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    HiveCleaningNotification notification,
    ArduinoProvider provider,
    BuildContext context,
  ) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'error':
          return Colors.red.shade700;
        case 'warning':
        case 'dust_alert':
          return Colors.orange.shade700;
        case 'started':
          return Colors.blue.shade700;
        case 'completed':
          return Colors.green.shade700;
        case 'connected':
          return Colors.teal.shade700;
        case 'disconnected':
          return Colors.red.shade700;
        default:
          return Colors.grey.shade700;
      }
    }

    IconData getStatusIcon(String status) {
      switch (status) {
        case 'error':
          return Icons.error_outline;
        case 'warning':
          return Icons.warning_amber_outlined;
        case 'dust_alert':
          return Icons.wind_power;
        case 'started':
          return Icons.play_arrow;
        case 'completed':
          return Icons.check_circle_outline;
        case 'connected':
          return Icons.link;
        case 'disconnected':
          return Icons.link_off;
        default:
          return Icons.notifications_none;
      }
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade100,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red, size: 30),
      ),
      onDismissed: (_) {
        // Implement delete from Hive
        // provider.deleteNotification(notification.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: getStatusColor(notification.status).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getStatusIcon(notification.status),
              color: getStatusColor(notification.status),
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getStatusColor(notification.status),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                _formatDateTime(notification.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          trailing: notification.isAuto
              ? Chip(
                  label: const Text('Auto'),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                )
              : null,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (notificationDate == today) {
      return 'Today ${DateFormat('hh:mm a').format(dateTime)}';
    } else if (notificationDate == yesterday) {
      return 'Yesterday ${DateFormat('hh:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM d, yyyy hh:mm a').format(dateTime);
    }
  }
}