import 'package:bus_alarm_app/model/bus_route_info_model.dart';
import 'package:bus_alarm_app/model/route_info_model.dart';
import 'package:flutter/material.dart';

import '../../model/bus_info_model.dart';
import '../../screen/route_screen.dart';
import '../../service/app_service.dart';

class BottomSheetModal extends StatelessWidget {

  final List<BusInfo> busList;
  final String nodenm;

  BottomSheetModal({required this.busList, required this.nodenm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              nodenm,
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
                    title: Text(bus.routeNo + '번 버스'),
                    subtitle: Text(bus.arrTime + '\n(' + bus.arrPrevStationCnt + '번째전)'),
                    trailing: Chip(
                      label: Text(bus.routeTp),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: bus.routeTp.length == 4 ? Colors.green : Colors.red),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => RouteScreen(),
                      ),);
                      /*RouteInfo? route = await getnodenm(bus.cityCode, bus.routeId);
                      Future<List<BusRouteInfo>> broute = busroute(bus.cityCode, bus.routeId);
                      print(broute.toString());*/
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