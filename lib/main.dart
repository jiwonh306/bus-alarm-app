import 'package:bus_alarm_app/screen/bookmark_screen.dart';
import 'package:bus_alarm_app/screen/main_screen.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
