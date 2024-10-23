import 'package:bus_alarm_app/model/bus_route_info_model.dart';
import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart';
import 'package:bus_alarm_app/util/bus_color_change.dart';
import 'package:flutter/material.dart';

import '../../model/bus_info_model.dart';
import '../../screen/route_screen.dart';
import '../../service/alarm_service.dart';
import '../../service/app_service.dart';
import '../../util/bus_type_change.dart';
import '../popup/alarm_dialog.dart';

class BottomSheetModal extends StatefulWidget {
  final List<BusInfo> busList;
  final List<BusStationInfo> initLikeList;
  final BusStationInfo busStation;
  final Function onFavoritesChanged; // 즐겨찾기 변경 콜백
  BookmarkService bookmarkService = BookmarkService();

  BottomSheetModal({
    required this.busList,
    required this.busStation,
    required this.initLikeList,
    required this.onFavoritesChanged, // 콜백 초기화
  });

  @override
  _BottomSheetModalState createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  late bool isLike = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLike = widget.initLikeList.any((item) => item.arsId == widget.busStation.arsId);
    });
  }

  void toggleLike() {
    setState(() {
      if (isLike) {
        widget.initLikeList.removeWhere((item) => item.arsId == widget.busStation.arsId);
      } else {
        widget.initLikeList.add(widget.busStation);
      }
      isLike = !isLike;
      widget.bookmarkService.saveBookmarks(widget.initLikeList);
      widget.onFavoritesChanged(); // MainScreen에 알리기 위해 콜백 호출
    });
  }

  void _showAlarmDialog(String arrmsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlarmDialog(
          arrmsg: arrmsg,
          onSetAlarm: (minutes) {
            scheduleAlarm(minutes); // 알람 설정
            print('알람이 $minutes 분 후에 설정되었습니다.');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          AppBar(
            title: Text(
              widget.busStation.stationNm,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: isLike ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border, color: Colors.grey),
                onPressed: () {
                  toggleLike();
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.busList.length,
              itemBuilder: (context, index) {
                BusInfo bus = widget.busList[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          bus.rtNm,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          convertBusType(bus.routeType),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: convertBusTypeColor(convertBusType(bus.routeType)),
                          ),
                        ),
                        SizedBox(width: 8.0),
                      ],
                    ),
                    subtitle: Text(bus.arrmsg1),
                    trailing: InkWell(
                      onTap: () {
                        _showAlarmDialog(bus.arrmsg1);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.alarm,
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onTap: () async {
                      final busRouteInfo = await getRouteInfo(bus.busRouteId);
                      final routeInfo = await getStaionByRoute(bus.busRouteId);
                      final busPosList = await getBusPosByRouteSt(bus.busRouteId, routeInfo.length.toString());
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RouteScreen(
                          busRouteInfo: busRouteInfo[0],
                          routeInfo: routeInfo,
                          busPosList: busPosList,
                        ),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
