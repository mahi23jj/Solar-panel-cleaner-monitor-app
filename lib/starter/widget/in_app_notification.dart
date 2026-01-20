// widgets/in_app_notification_overlay.dart
import 'package:flutter/material.dart';
import 'package:ietp_project/starter/model/notification_model.dart';
import 'package:provider/provider.dart';
import '../providers/arduino_provider.dart';

class InAppNotificationOverlay extends StatefulWidget {
  const InAppNotificationOverlay({super.key});

  @override
  State<InAppNotificationOverlay> createState() => _InAppNotificationOverlayState();
}

class _InAppNotificationOverlayState extends State<InAppNotificationOverlay> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArduinoProvider>(context, listen: false);
    
    return StreamBuilder<List<InAppNotification>>(
      stream: provider.notifier.inAppNotificationsStream,
      builder: (context, snapshot) {
        final notifications = snapshot.data ?? [];
        
        if (notifications.isEmpty) return const SizedBox.shrink();

        return Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10,
          right: 10,
          child: Column(
            children: notifications.map((notification) {
              return _buildNotificationCard(notification, provider);
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(InAppNotification notification, ArduinoProvider provider) {
    Color getStatusColor(String status) {
      switch (status) {
        case 'error':
          return Colors.red.shade700;
        case 'warning':
          return Colors.orange.shade700;
        case 'dust_alert':
          return Colors.deepOrange.shade600;
        case 'started':
          return Colors.blue.shade700;
        case 'completed':
          return Colors.green.shade700;
        default:
          return Colors.grey.shade700;
      }
    }

    Color getBackgroundColor(String status) {
      switch (status) {
        case 'error':
          return Colors.red.shade50;
        case 'warning':
          return Colors.orange.shade50;
        case 'dust_alert':
          return Colors.deepOrange.shade50;
        case 'started':
          return Colors.blue.shade50;
        case 'completed':
          return Colors.green.shade50;
        default:
          return Colors.grey.shade50;
      }
    }

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red, size: 30),
      ),
      onDismissed: (_) {
        provider.dismissInAppNotification(notification.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: getBackgroundColor(notification.status),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: getStatusColor(notification.status).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: getStatusColor(notification.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getStatusIcon(notification.status),
                        color: getStatusColor(notification.status),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(notification.status),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(notification.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
              onPressed: () {
                provider.dismissInAppNotification(notification.id);
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}