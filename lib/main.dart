import 'package:bus_alarm_app/screen/bookmark_screen.dart';
import 'package:bus_alarm_app/screen/main_screen.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_alarm_app/service/alarm_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalNotifications(); // 알람 초기화
  tz.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
