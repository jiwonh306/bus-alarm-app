class BusStationInfo {
  final String arsId; //정류소 번호
  final String posX;  //정류소 좌표X (GRS80)
  final String posY; //정류소 좌표Y (GRS80)
  final String dist; //거리
  final String gpsX; //정류소 좌표X (WGS84)
  final String gpsY; //정류소 좌표Y (WGS84)
  final String stationTp; //정류소타입
  final String stationNm; //정류소명
  final String stationId; //정류소 고유 ID
  BusStationInfo({
    required this.arsId,
    required this.posX,
    required this.posY,
    required this.dist,
    required this.gpsX,
    required this.gpsY,
    required this.stationTp,
    required this.stationNm,
    required this.stationId
  });
}