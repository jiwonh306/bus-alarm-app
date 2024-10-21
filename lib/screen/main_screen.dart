import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart';
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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                    _loadFavorites(); // 돌아올 때 즐겨찾기 목록 갱신
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, color: Colors.black),
                      SizedBox(width: 10),
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
              top: 120,
              child: Container(
                height: MediaQuery.of(context).size.height - 220, // 버튼 높이와 여백 제외
                child: favoriteStations.isEmpty
                    ? Center(
                  child: Text(
                    '즐겨찾기된 정류소가 없습니다.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
                    : ListView.builder(
                  itemCount: favoriteStations.length,
                  itemBuilder: (context, index) {
                    final station = favoriteStations[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(station.stationNm),
                        subtitle: Text('ARS ID: ${station.arsId}'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
