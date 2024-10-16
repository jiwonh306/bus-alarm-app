class RouteInfo {
  final String busRouteId; //
  final String busRouteNm; //
  final String seq; //
  final String section;  // 종점
  final String station;      // 기점
  final String stationNm;
  final String gpsX;
  final String gpsY;
  final String direction;
  final String stationNo;
  final String routeType;
  final String beginTm;
  final String lastTm;
  final String posX;
  final String posY;
  final String arsId;
  final String transYn;
  final String trnstnid;
  final String sectSpd;
  final String fullSectDist;
  RouteInfo({
    required this.busRouteId,
    required this.busRouteNm,
    required this.seq,
    required this.section,
    required this.station,
    required this.stationNm,
    required this.gpsX,
    required this.gpsY,
    required this.direction,
    required this.stationNo,
    required this.routeType,
    required this.beginTm,
    required this.lastTm,
    required this.posX,
    required this.posY,
    required this.arsId,
    required this.transYn,
    required this.trnstnid,
    required this.sectSpd,
    required this.fullSectDist
  });
}