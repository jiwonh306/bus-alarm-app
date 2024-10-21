import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart'; // BookmarkService 추가
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<BusStationInfo> favoriteStations = [];
  final BookmarkService bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    favoriteStations = await bookmarkService.loadBookmarks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버스 알람 앱'),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                    children: [
                      Icon(Icons.map, color: Colors.black), // 아이콘 추가
                      SizedBox(width: 10), // 아이콘과 텍스트 간격
                      Text(
                        '정류소 찾기',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 120, // Adjust the top position for the new button
              child: Container(
                child: favoriteStations.isEmpty
                    ? Text(
                  '즐겨찾기된 정류소가 없습니다.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                )
                    : Column(
                  children: favoriteStations.map((station) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(station.stationNm),
                        subtitle: Text('ARS ID: ${station.arsId}'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}