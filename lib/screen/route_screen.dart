import 'package:bus_alarm_app/util/date_format_util.dart';
import 'package:flutter/material.dart';
import '../model/bus_info_model.dart';
import '../model/bus_route_info_model.dart';
import '../model/bus_station_info_model.dart';
import '../model/route_info_model.dart';
import '../widget/modal/bottom_sheet_modal.dart';

class BusRoute {
  final String routeName;
  final String startPoint;
  final String endPoint;
  final List<RouteInfo> stops;
  final String term;
  final String lastBusYn;
  final String lastBusTm;
  final String firstBusTm;
  final String lastLowTm;
  final String firstLowTm;

  BusRoute({
    required this.routeName,
    required this.startPoint,
    required this.endPoint,
    required this.stops,
    required this.term,
    required this.lastBusYn,
    required this.lastBusTm,
    required this.firstBusTm,
    required this.lastLowTm,
    required this.firstLowTm,
  });
}

class RouteScreen extends StatelessWidget {
  final BusRouteInfo busRouteInfo;
  final List<RouteInfo> routeInfo;
  late List<BusRoute> busRoutes;
  final List<String> busPosList;


  RouteScreen({super.key, required this.busRouteInfo, required this.routeInfo, required this.busPosList}) {
    busRoutes = [
      BusRoute(
        routeName: busRouteInfo.busRouteNm,
        startPoint: busRouteInfo.stStationNm,
        endPoint: busRouteInfo.edStationNm,
        stops: routeInfo,
        term: busRouteInfo.term,
        lastBusYn: busRouteInfo.lastBusYn,
        lastBusTm: busRouteInfo.lastBusTm,
        firstBusTm: busRouteInfo.firstBusTm,
        lastLowTm: busRouteInfo.lastLowTm,
        firstLowTm: busRouteInfo.firstLowTm,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('버스 정보')),
      body: ListView.builder(
        itemCount: busRoutes.length,
        itemBuilder: (context, index) {
          BusRoute route = busRoutes[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 노선 이름과 기점 -> 종점
                    Text(
                      route.routeName, // 버스 이름
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${route.startPoint} → ${route.endPoint}\n배차간격: ${route.term}분\n첫차시간: ${formatDateTime(route.firstBusTm)}, 막차시간: ${formatDateTime(route.lastBusTm)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // 정류장 리스트
              Column(
                children: route.stops.map((stop) {
                  int stopIndex = route.stops.indexOf(stop);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BusStopTile(
                      stopName: stop.stationNm,
                      isLastStop: stopIndex == route.stops.length - 1,
                      isBusHere: busPosList.contains(stop.seq),
                      onTap: () {

                      },
                    ),
                  );
                }).toList(),
              ),
              Divider(), // 각 노선 간 구분선 추가
            ],
          );
        },
      ),
    );
  }
}

class BusStopTile extends StatelessWidget {
  final String stopName;
  final bool isLastStop;
  final VoidCallback onTap; // 클릭 이벤트 처리
  final bool isBusHere;

  const BusStopTile({
    Key? key,
    required this.stopName,
    required this.isLastStop,
    required this.isBusHere,
    required this.onTap, // 클릭 이벤트 받기
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 클릭 시 호출
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Color(0xFF6b8e23),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (isBusHere)
                    const Icon(Icons.directions_bus, color: Colors.white, size: 12),
                ],
              ),
              // 정류장 사이의 선 (마지막 정류장에는 표시하지 않음)
              if (!isLastStop)
                Container(
                  width: 2,
                  height: 50,
                  color: Color(0xFF6b8e23),
                ),
            ],
          ),
          SizedBox(width: 16),
          // 정류장 이름
          Text(stopName, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}