import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showDailyNotification(
      int hour,
      int minute,
      String title,
      String body, {
        bool silent = false,
      }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Günlük Bildirim Kanalı',
      channelDescription: 'Günlük olumlama veya hatırlatma bildirimi',
      importance: Importance.max,
      priority: Priority.high,
      playSound: !silent,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.showDailyAtTime(
      0,
      title,
      body,
      Time(hour, minute, 0),
      details,
    );
  }

  static Future<void> showTestNotification(
      String title,
      String body, {
        bool silent = false,
      }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Bildirim Kanalı',
      channelDescription: 'Test bildirimi göndermek için kullanılır',
      importance: Importance.max,
      priority: Priority.high,
      playSound: !silent,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      999,
      title,
      body,
      details,
    );
  }
}
