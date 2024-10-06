import 'dart:developer'; // 로깅을 위한 패키지
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:flutter/material.dart'; // Flutter UI 구성 요소

void main() { // 앱의 시작점
  runApp(MyApp()); // MyApp 위젯 실행
}

class MyApp extends StatelessWidget { // MyApp 클래스 정의
  @override
  Widget build(BuildContext context) { // UI 빌드 메서드
    return MaterialApp( // 머티리얼 디자인 앱
      home: MapScreen(), // MapScreen 위젯을 홈으로 설정
    );
  }
}
