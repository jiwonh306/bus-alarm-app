import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              top: 20,
              child: Container(
                width: 300,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  },
                  child: Text(
                    '정류소 찾기',
                    style: TextStyle(color: Colors.black), // 텍스트 색상 설정
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}