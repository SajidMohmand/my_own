//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const DarwinInitializationSettings initializationSettingsIOS =
//   DarwinInitializationSettings();
//
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );
//
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//   );
// }
//
// Future<void> showNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails(
//     'rate_alert_channel',
//     'Rate Alerts',
//     channelDescription: 'Notifications for rate alerts',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//
//   const NotificationDetails platformChannelSpecifics =
//   NotificationDetails(android: androidPlatformChannelSpecifics);
//
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     platformChannelSpecifics,
//   );
// }
