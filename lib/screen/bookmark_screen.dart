import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:flutter/material.dart';
import '../service/local_storage_service.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<BusStationInfo> items; // late로 선언, 초기값 없음
  final BookmarkService service = BookmarkService();

  @override
  void initState() {
    super.initState();
    items = []; // 초기값을 빈 리스트로 설정
    service.loadBookmarks().then((value) {
      setState(() {
        items = value; // 비동기 작업 완료 후 items 업데이트
      });
    });
  }

  void deleteLike(int index) {
    // 삭제할 정류소의 이름을 저장
    String deletedStationName = items[index].stationNm;

    setState(() {
      items.removeAt(index);
      service.saveBookmarks(items);
    });

    // 삭제된 정류소 이름을 사용하여 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedStationName 정류장이 삭제되었습니다!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요 페이지'),
      ),
      body: items.isEmpty // items가 비어있는지 확인
          ? Center(child: Text('정류소가 없습니다')) // 비어있을 경우 메시지 표시
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(items[index].stationNm),
              trailing: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  deleteLike(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}