class RouteInfo {
  final String routeid; //
  final String routeno; //
  final String routetp; //
  final String endnodenm;  // 종점
  final String startnodenm;      // 기점
  final String endvehicletime;
  final String startvehicletime;
  final String intervaltime;
  final String intervalsattime;
  final String intervalsuntime;
  RouteInfo({
    required this.routeid,
    required this.routeno,
    required this.routetp,
    required this.endnodenm,
    required this.startnodenm,
    required this.endvehicletime,
    required this.startvehicletime,
    required this.intervaltime,
    required this.intervalsattime,
    required this.intervalsuntime
  });
}