import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:bus_alarm_app/widget/modal/bottom_sheet_modal.dart';

import '../model/bus_info_model.dart';
import '../service/app_service.dart';

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
        backgroundColor: Color(0xFF6b8e23),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              // 로그인 버튼 클릭 시 동작할 코드 작성
              // 예: 로그인 화면으로 이동
            },
          ),
        ],
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
                    backgroundColor: Colors.white, // 올리브색으로 변경
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
                      Icon(Icons.map, color: Color(0xFF6b8e23)), // 아이콘 색상 변경
                      SizedBox(width: 10),
                      Text(
                        '정류소 찾기',
                        style: TextStyle(color: Color(0xFF444939)), // 텍스트 색상 변경
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
                height: MediaQuery.of(context).size.height - 220,
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
                        onTap: () {
                          // BottomSheetModal을 열도록 설정
                          _showBottomSheetModal(station);
                        },
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

  void _showBottomSheetModal(BusStationInfo station) async {
    List<BusInfo> busList = await getStationByUid(station.arsId); // ARS ID를 사용하여 버스 목록 가져오기

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetModal(
          busList: busList, // 가져온 버스 목록 전달
          busStation: station,
          initLikeList: favoriteStations,
          onFavoritesChanged: _loadFavorites, // 콜백 전달
        );
      },
    );
  }
}