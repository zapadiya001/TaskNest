//services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initializes the notification service, permissions, and timezone.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Initialize timezone support
      tz.initializeTimeZones();

      // Android-specific initialization
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS-specific initialization
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        // Request permissions and update initialized state
        final hasPermissions = await _requestPermissions();
        _isInitialized = hasPermissions;
        return hasPermissions;
      }

      return false;
    } catch (e) {
      print('Error initializing notifications: $e');
      return false;
    }
  }

  /// Handles what happens when the user taps a notification.
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
  }

  /// Requests permissions for notifications and exact alarms.
  Future<bool> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final notificationStatus = await Permission.notification.request();

      // Check and request exact alarm permission if needed
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final canScheduleExactAlarms = await androidImplementation.canScheduleExactNotifications();
        if (canScheduleExactAlarms == false) {
          await androidImplementation.requestExactAlarmsPermission();
        }
      }

      return notificationStatus == PermissionStatus.granted;
    }

    // On iOS, permissions are handled during initialization
    return true;
  }

  /// Schedules a task reminder notification at a specific date and time.
  Future<bool> scheduleTaskReminder({
    required int id,
    required String title,
    required DateTime scheduledDate,
    String? body,
  }) async {
    if (!_isInitialized || scheduledDate.isBefore(DateTime.now())) return false;

    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final canScheduleExactAlarms = await androidImplementation.canScheduleExactNotifications();
      if (canScheduleExactAlarms == false) {
        await androidImplementation.requestExactAlarmsPermission();
        final canScheduleAfterRequest = await androidImplementation.canScheduleExactNotifications();
        if (canScheduleAfterRequest == false) return false;
      }
    }

    const androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Notifications for task due dates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
      autoCancel: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tz.TZDateTime scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);

    try {
      // Attempt exact scheduling
      await _notifications.zonedSchedule(
        id,
        '📋 Task Reminder',
        body ?? 'Don\'t forget: $title',
        scheduledTZ,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      return true;
    } catch (_) {
      // Fallback to inexact scheduling
      try {
        await _notifications.zonedSchedule(
          id,
          '📋 Task Reminder',
          body ?? 'Don\'t forget: $title',
          scheduledTZ,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
        return true;
      } catch (_) {
        return false;
      }
    }
  }

  /// Cancels a scheduled notification by ID.
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancels all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Returns a list of all pending (scheduled) notifications.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
