import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleAlarm(int minutes) async {
  print(1111112111);
  final DateTime scheduledNotificationDateTime =
  DateTime.now().add(Duration(minutes: minutes));
  print('알람 설정 시간: $scheduledNotificationDateTime');
  final tz.TZDateTime scheduledTZDateTime = tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '1',
    '버스 알람',
    channelDescription: '버스 도착 알림을 위한 채널입니다.',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '버스 알림',
    '버스가 곧 도착합니다!',
    scheduledTZDateTime,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}