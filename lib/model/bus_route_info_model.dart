class BusRouteInfo {
  final String busRouteNm; //
  final String length; //
  final String routeType; //
  final String stStationNm;  // 종점
  final String edStationNm;      // 기점
  final String term;
  final String lastBusYn;
  final String lastBusTm;
  final String firstBusTm;
  final String lastLowTm;
  final String firstLowTm;
  final String busRouteId;
  final String corpNm;
  BusRouteInfo({
    required this.busRouteNm,
    required this.length,
    required this.routeType,
    required this.stStationNm,
    required this.edStationNm,
    required this.term,
    required this.lastBusYn,
    required this.lastBusTm,
    required this.firstBusTm,
    required this.lastLowTm,
    required this.firstLowTm,
    required this.busRouteId,
    required this.corpNm
  });
}
