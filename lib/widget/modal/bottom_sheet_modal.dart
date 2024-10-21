import 'package:bus_alarm_app/model/bus_route_info_model.dart';
import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/model/route_info_model.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart';
import 'package:bus_alarm_app/util/bus_type_change.dart';
import 'package:flutter/material.dart';

import '../../model/bus_info_model.dart';
import '../../screen/route_screen.dart';
import '../../service/app_service.dart';

class BottomSheetModal extends StatefulWidget {
  final List<BusInfo> busList;
  late List<BusStationInfo> likeList = [];
  final List<BusStationInfo> initLikeList;
  final BusStationInfo busStation;
  BookmarkService bookmarkService = BookmarkService();

  BottomSheetModal({required this.busList, required this.busStation, required this.initLikeList});

  @override
  _BottomSheetModalState createState() => _BottomSheetModalState();
}

class _BottomSheetModalState extends State<BottomSheetModal> {
  late bool isLike = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      widget.likeList = widget.initLikeList;
      isLike = widget.likeList.any((item) => item.arsId == widget.busStation.arsId);
    });
  }

  void toggleLike() {
    setState(() {
      if (isLike) {
        widget.likeList.removeWhere((item) => item.arsId == widget.busStation.arsId);
      } else {
        widget.likeList.add(widget.busStation);
      }
      isLike = !isLike;
      widget.bookmarkService.saveBookmarks(widget.likeList);
    });
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
                  // 즐겨찾기 상태 변경 후에 context를 사용하여 Modal을 닫지 않음
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
                    title: Text(bus.rtNm),
                    subtitle: Text(bus.arrmsg1),
                    trailing: Chip(
                      label: Text(convertBusType(bus.routeType)),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(16.0),
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