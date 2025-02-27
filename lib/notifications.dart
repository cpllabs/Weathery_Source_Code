import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManger {
  static final _notifer = FlutterLocalNotificationsPlugin();
  NotificationManger() {
    init();
  }

  static Future init() async {
    await _notifer.initialize(const InitializationSettings(
        android: AndroidInitializationSettings("weathery_icon_bw")));
  }

  @pragma('vm:entry-point')
  Future showMorningNotification(
      String heading, String message, String icon) async {
    _notifer.show(
        0,
        heading,
        message,
        NotificationDetails(
            android: AndroidNotificationDetails("0", "Morning Update Channel",
                priority: Priority.max,
                importance: Importance.max,
                styleInformation:
                    BigTextStyleInformation(message, contentTitle: heading))));
  }

  @pragma('vm:entry-point')
  Future showNoonNotification(
      String heading, String message, String icon) async {
    _notifer.show(
        0,
        heading,
        message,
        NotificationDetails(
            android: AndroidNotificationDetails("1", "Afternoon Update Channel",
                priority: Priority.max,
                importance: Importance.max,
                styleInformation:
                    BigTextStyleInformation(message, contentTitle: heading))));
  }

  @pragma('vm:entry-point')
  Future showNightNotification(
      String heading, String message, String icon) async {
    _notifer.show(
        0,
        heading,
        message,
        NotificationDetails(
            android: AndroidNotificationDetails("2", "Night Update Channel",
                priority: Priority.max,
                importance: Importance.max,
                styleInformation:
                    BigTextStyleInformation(message, contentTitle: heading))));
  }
}
