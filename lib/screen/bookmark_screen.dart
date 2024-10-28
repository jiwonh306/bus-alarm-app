import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:flutter/material.dart';
import '../service/local_storage_service.dart';
import '../model/bus_info_model.dart'; // BusInfo 모델 추가
import '../service/app_service.dart';
import '../widget/modal/bottom_sheet_modal.dart'; // getStationByUid 메서드 추가

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<BusStationInfo> items = [];
  final BookmarkService service = BookmarkService();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    items = await service.loadBookmarks();
    setState(() {}); // 로드 후 UI 갱신
  }

  void deleteLike(int index) {
    setState(() {
      items.removeAt(index);
    });
    service.saveBookmarks(items);
  }

  void _showBottomSheetModal(BusStationInfo station) async {
    List<BusInfo> busList = await getStationByUid(station.arsId); // ARS ID로 버스 정보 가져오기

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetModal(
          busList: busList,
          busStation: station,
          initLikeList: items,
          onFavoritesChanged: _loadBookmarks,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요 페이지'),
        backgroundColor: Color(0xFF6b8e23),
      ),
      body: items.isEmpty
          ? Center(
        child: Text(
          '즐겨찾기된 정류소가 없습니다.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      )
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(items[index].stationNm),
              onTap: () {
                _showBottomSheetModal(items[index]); // BottomSheetModal 호출
              },
              trailing: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  deleteLike(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${items[index].stationNm} 정류장이 삭제되었습니다!'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
