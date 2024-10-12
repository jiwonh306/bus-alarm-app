import 'dart:developer'; // 로깅을 위한 패키지

import 'package:bus_alarm_app/service/app_service.dart';
import 'package:bus_alarm_app/widget/popup/node_detail_popup.dart';
import 'package:flutter/material.dart'; // Flutter UI 구성 요소
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps Flutter 패키지
import 'package:geolocator/geolocator.dart';

import '../model/bus_info_model.dart';
import '../widget/modal/bottom_sheet_modal.dart'; // 위치 정보 접근 패키지

class RouteScreen extends StatelessWidget {
  final List<BusStop> busStops = [
    BusStop(name: "정류장 A", position: Offset(100, 200)),
    BusStop(name: "정류장 B", position: Offset(100, 300)),
    BusStop(name: "정류장 C", position: Offset(100, 400)),
    BusStop(name: "정류장 D", position: Offset(100, 500)),
    BusStop(name: "정류장 E", position: Offset(100, 600)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버스 노선도'),
      ),
      body: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: BusRoutePainter(busStops),
        child: Stack(
          children: busStops.map((busStop) {
            return Positioned(
              left: busStop.position.dx - 15,
              top: busStop.position.dy - 15,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(busStop.name),
                      content: Text("위치: ${busStop.position}"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('닫기'),
                        ),
                      ],
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Text(busStop.name[0], style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BusRoutePainter extends CustomPainter {
  final List<BusStop> busStops;

  BusRoutePainter(this.busStops);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (int i = 0; i < busStops.length - 1; i++) {
      canvas.drawLine(busStops[i].position, busStops[i + 1].position, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BusStop {
  final String name;
  final Offset position;

  BusStop({required this.name, required this.position});
}