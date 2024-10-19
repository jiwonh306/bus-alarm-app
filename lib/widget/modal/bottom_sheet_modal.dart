import 'package:bus_alarm_app/model/bus_route_info_model.dart';
import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/model/route_info_model.dart';
import 'package:bus_alarm_app/util/bus_type_change.dart';
import 'package:flutter/material.dart';

import '../../model/bus_info_model.dart';
import '../../screen/route_screen.dart';
import '../../service/app_service.dart';

class BottomSheetModal extends StatelessWidget {

  final List<BusInfo> busList;
  late Future<List<BusRouteInfo>> busrouteList;
  late Future<List<RouteInfo>> routeList;
  late Future<List<String>> busPosList;
  final String stationNm;

  BottomSheetModal({required this.busList, required this.stationNm});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              stationNm,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: busList.length,
              itemBuilder: (context, index) {
                BusInfo bus = busList[index];

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
                      busrouteList = getRouteInfo(bus.busRouteId);
                      busrouteList.then((busroute){
                        final BusRouteInfo busrouteinfo = busroute[0];
                        routeList = getStaionByRoute(bus.busRouteId);
                        routeList.then((route){

                          final List<RouteInfo> routeinfo = route;
                          busPosList = getBusPosByRouteSt(bus.busRouteId, route.length.toString());
                          busPosList.then((buspos){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RouteScreen(busRouteInfo: busrouteinfo, routeInfo: routeinfo, busPosList: buspos,),
                            ),);
                          });
                        });
                      });
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