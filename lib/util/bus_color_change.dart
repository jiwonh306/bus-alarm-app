import 'package:flutter/material.dart';

Color convertBusTypeColor(String busType) {
  switch (busType) {
    case '공항':
      return Colors.blue;      // 공항
    case '마을':
      return Colors.green;     // 마을
    case '간선':
      return Colors.red;       // 간선
    case '지선':
      return Colors.orange;    // 지선
    case '순환':
      return Colors.yellow;     // 순환
    case '광역':
      return Colors.purple;    // 광역
    case '인천':
      return Colors.cyan;      // 인천
    case '경기':
      return Colors.grey;      // 경기
    case '폐지':
      return Colors.black;     // 폐지
    case '공용':
      return Colors.pink;      // 공용
    default:
      return Colors.transparent; // 알 수 없음
  }
}
