import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/local_storage_service.dart';

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  late List<BusStationInfo> items;
  final BookmarkService service = BookmarkService();

  @override
  void initState() {
    super.initState();
    service.loadBookmarks().then((value) {
      items = value;
    });
  }

  void deleteLike(int index) {
    setState(() {
      items.removeAt(index);
      service.saveBookmarks(items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요 페이지'),
      ),
      body: ListView.builder(
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${items[index].stationNm} 정류장이 삭제되었습니다!')
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
