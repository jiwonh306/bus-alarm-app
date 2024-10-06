class BusInfo {
  final String nodeId;  // 정류소ID
  final String nodeNm;      // 정류소명
  final String routeNo; // 노선번호
  final String routeTp;// 노선유형
  final String arrPrevStationCnt;  // 남은 정류장 수
  final String vehicleTp; // 차량유형
  final String arrTime; // 도착예상시간
  final String cityCode;
  final String routeId;
  BusInfo({
    required this.nodeId,
    required this.nodeNm,
    required this.routeNo,
    required this.routeTp,
    required this.arrPrevStationCnt,
    required this.vehicleTp,
    required this.arrTime,
    required this.cityCode,
    required this.routeId
  });
}