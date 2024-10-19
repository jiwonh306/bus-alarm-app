import 'package:bus_alarm_app/model/bus_info_model.dart';
import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/model/route_info_model.dart';
import 'package:bus_alarm_app/util/second_to_minute_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps Flutter 패키지
import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'dart:io'; // HTTP 요청을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청 라이브러리
import 'package:xml2json/xml2json.dart';

import '../model/bus_route_info_model.dart';
import '../util/bus_type_change.dart'; // XML을 JSON으로 변환하기 위한 패키지

Future<void> getArrInfoByRouteAll() async { // 특정 버스 노선의 도착 정보 가져오기
  try {
    final url = Uri.parse('http://ws.bus.go.kr/api/rest/arrive/getArrInfoByRouteAll'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&busRouteId=100100016'); // API URL 생성
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json', // 요청 헤더 설정
    });
    if (response.statusCode >= 200 && response.statusCode <= 300) { // 요청 성공 여부 확인
      final Xml2Json xml2json = Xml2Json(); // XML을 JSON으로 변환하기 위한 객체 생성
      xml2json.parse(response.body); // XML 파싱
      String jsonString = xml2json.toParker(); // JSON 문자열로 변환
      var jsonData = jsonDecode(jsonString); // JSON 디코딩
      print('BUS_API_TEST: ${jsonData}'); // 결과 출력
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}'); // 오류 처리
    }
  } catch (e) {
    print('Exception: $e'); // 예외 처리
  }
}

Future<void> getStationByPos(LatLng _currentPosition, Function callback) async { // 주변 버스 정류장 정보 가져오기
  List<BusStationInfo> busstationList = [];
  try {
    final url = Uri.parse('http://ws.bus.go.kr/api/rest/stationinfo/getStationByPos'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&tmX=${_currentPosition.longitude}' // 현재 위치의 경도
        '&tmY=${_currentPosition.latitude}' // 현재 위치의 위도
        '&radius=200'
        '&resultType=json');
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json', // 요청 헤더 설정
    });
    if (response.statusCode >= 200 && response.statusCode <= 300) { // 요청 성공 여부 확인
      final decodedBody = utf8.decode(response.bodyBytes); // 응답 본문 디코딩

      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody); // JSON 디코딩
      List<dynamic> items = jsonResponse['msgBody']['itemList']; // 정류장 정보 목록

      items.forEach((item) async {
        String arsId = item['arsId'].toString(); //정류소 번호
        String posX = item['posX'].toString(); //정류소 좌표X (GRS80)
        String posY = item['posY'].toString(); //정류소 좌표Y (GRS80)
        String dist = item['dist'].toString(); //거리
        String gpsX = item['gpsX'].toString(); //정류소 좌표X (WGS84)
        String gpsY = item['gpsY'].toString(); //정류소 좌표Y (WGS84)
        String stationTp = item['stationTp'].toString(); //정류소타입
        String stationNm = item['stationNm'].toString(); //정류소명
        String stationId = item['stationId'].toString(); //정류소 고유 ID
        busstationList.add(BusStationInfo(
            arsId: arsId,
            posX: posX,
            posY: posY,
            dist: dist,
            gpsX: gpsX,
            gpsY: gpsY,
            stationTp: stationTp,
            stationNm: stationNm,
            stationId: stationId
        ));
        List<BusInfo> busList = await getStationByUid(arsId);
        callback(LatLng(double.parse(gpsY), double.parse(gpsX)), stationNm, busList);
      });

    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}'); // 오류 처리
    }
  } catch (e) {
    print('Exception: $e'); // 예외 처리
  }
}

Future<List<BusInfo>> getStationByUid(String arsId) async {
  List<BusInfo> busList = [];
  try {
    final url = Uri.parse('http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&arsId=$arsId'
        '&resultType=json'
    );

    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
      List<dynamic> items = jsonResponse['msgBody']['itemList'];;

      items.forEach((item) {
        String adirection = item['adirection'].toString();
        String arrmsg1 = item['arrmsg1'].toString();
        String arrmsg2 = item['arrmsg2'].toString();
        String arrmsgSec1 = item['arrmsgSec1'].toString();
        String arrmsgSec2 = item['arrmsgSec2'].toString();
        String busRouteId = item['busRouteId'].toString();
        String busType1 = item['busType1'].toString();
        String busType2 = item['busType2'].toString();
        String firstTm = item['firstTm'].toString();
        String isArrive1 = item['isArrive1'].toString();
        String isArrive2 = item['isArrive2'].toString();
        String isFullFlag1 = item['isFullFlag1'].toString();
        String isFullFlag2 = item['isFullFlag2'].toString();
        String isLast1 = item['isLast1'].toString();
        String isLast2 = item['isLast2'].toString();
        String lastTm = item['lastTm'].toString();
        String nextBus = item['nextBus'].toString();
        String nxtStn = item['nxtStn'].toString();
        String posX = item['posX'].toString();
        String posY = item['posY'].toString();
        String repTm1 = item['repTm1'].toString();
        String repTm2 = item['repTm2'].toString();
        String rerdieDiv1 = item['rerdieDiv1'].toString();
        String rerdieDiv2 = item['rerdieDiv2'].toString();
        String rerideNum1 = item['rerideNum1'].toString();
        String rerideNum2 = item['rerideNum2'].toString();
        String routeType = item['routeType'].toString();
        String rtNm = item['rtNm'].toString();
        String sectNm = item['sectNm'].toString();
        String sectOrd1 = item['sectOrd1'].toString();
        String sectOrd2 = item['sectOrd2'].toString();
        String gpsX = item['gpsX'].toString();
        String gpsY = item['gpsY'].toString();
        String stationTp = item['stationTp'].toString();
        String arsId = item['arsId'].toString();
        String staOrd = item['staOrd'].toString();
        String stationNm1 = item['stationNm1'].toString();
        String stationNm2 = item['stationNm2'].toString();
        String stId = item['stId'].toString();
        String stNm = item['stNm'].toString();
        String term = item['term'].toString();
        String traSpd1 = item['traSpd1'].toString();
        String traSpd2 = item['traSpd2'].toString();
        String traTime1 = item['traTime1'].toString();
        String traTime2 = item['traTime2'].toString();
        String vehId1 = item['vehId1'].toString();
        String vehId2 = item['vehId2'].toString();
        String deTourAt = item['deTourAt'].toString();
        busList.add(BusInfo(
            adirection: adirection,
            arrmsg1: arrmsg1,
            arrmsg2: arrmsg2,
            arrmsgSec1: arrmsgSec1,
            arrmsgSec2: arrmsgSec2,
            busRouteId: busRouteId,
            busType1: busType1,
            busType2: busType2,
            firstTm: firstTm,
            isArrive1: isArrive1,
            isArrive2: isArrive2,
            isFullFlag1: isFullFlag1,
            isFullFlag2: isFullFlag2,
            isLast1: isLast1,
            isLast2: isLast2,
            lastTm: lastTm,
            nextBus: nextBus,
            nxtStn: nxtStn,
            posX: posX,
            posY: posY,
            repTm1: repTm1,
            repTm2: repTm2,
            rerdieDiv1: rerdieDiv1,
            rerdieDiv2: rerdieDiv2,
            rerideNum1: rerideNum1,
            rerideNum2: rerideNum2,
            routeType: routeType,
            rtNm: rtNm,
            sectNm: sectNm,
            sectOrd1: sectOrd1,
            sectOrd2: sectOrd2,
            gpsX: gpsX,
            gpsY: gpsY,
            stationTp: stationTp,
            arsId: arsId,
            staOrd: staOrd,
            stationNm1: stationNm1,
            stationNm2: stationNm2,
            stId: stId,
            stNm: stNm,
            term: term,
            traSpd1: traSpd1,
            traSpd2: traSpd2,
            traTime1: traTime1,
            traTime2: traTime2,
            vehId1: vehId1,
            vehId2: vehId2,
            deTourAt: deTourAt));
        print(busRouteId);
      });
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }
  return busList;
}


Future<List<BusRouteInfo>> getRouteInfo(String busRouteId) async {
  List<BusRouteInfo> busrouteList = [];
  try {
    final url = Uri.parse('http://ws.bus.go.kr/api/rest/busRouteInfo/getRouteInfo'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&busRouteId=$busRouteId'
        '&resultType=json'
    );

    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
      List<dynamic> items = jsonResponse['msgBody']['itemList'];

      items.forEach((item) {
        String busRouteNm = item['busRouteNm'].toString();
        String length = item['length'].toString();
        String routeType = item['routeType'].toString();
        String stStationNm = item['stStationNm'].toString();
        String edStationNm = item['edStationNm'].toString();
        String term = item['term'].toString();
        String lastBusYn = item['lastBusYn'].toString();
        String lastBusTm = item['lastBusTm'].toString();
        String firstBusTm = item['firstBusTm'].toString();
        String lastLowTm = item['lastLowTm'].toString();
        String firstLowTm = item['firstLowTm'].toString();
        String busRouteId = item['busRouteId'].toString();
        String corpNm = item['corpNm'].toString();
        busrouteList.add(BusRouteInfo(
            busRouteNm: busRouteNm,
            length: length,
            routeType: routeType,
            stStationNm: stStationNm,
            edStationNm: edStationNm,
            term: term,
            lastBusYn: lastBusYn,
            lastBusTm: lastBusTm,
            firstBusTm: firstBusTm,
            lastLowTm: lastLowTm,
            firstLowTm: firstLowTm,
            busRouteId: busRouteId,
            corpNm: corpNm
            ));
      });
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }
  return busrouteList;
}

Future<List<RouteInfo>> getStaionByRoute(String busRouteId) async {
  List<RouteInfo> routeList = [];
  try {
    final url = Uri.parse('http://ws.bus.go.kr/api/rest/busRouteInfo/getStaionByRoute'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&busRouteId=$busRouteId'
        '&resultType=json'
    );

    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
      List<dynamic> items = jsonResponse['msgBody']['itemList'];;

      items.forEach((item) {
        String busRouteId = item['busRouteId'].toString();
        String busRouteNm = item['busRouteNm'].toString();
        String seq = item['seq'].toString();
        String section = item['section'].toString();
        String station = item['station'].toString();
        String stationNm = item['stationNm'].toString();
        String gpsX = item['gpsX'].toString();
        String gpsY = item['gpsY'].toString();
        String direction = item['direction'].toString();
        String stationNo = item['stationNo'].toString();
        String routeType = item['routeType'].toString();
        String beginTm = item['beginTm'].toString();
        String lastTm = item['lastTm'].toString();
        String posX = item['posX'].toString();
        String posY = item['posY'].toString();
        String arsId = item['arsId'].toString();
        String transYn = item['transYn'].toString();
        String trnstnid = item['trnstnid'].toString();
        String sectSpd = item['sectSpd'].toString();
        String fullSectDist = item['fullSectDist'].toString();
        routeList.add(RouteInfo(
            busRouteId: busRouteId,
            busRouteNm: busRouteNm,
            seq: seq,
            section: section,
            station: station,
            stationNm: stationNm,
            gpsX: gpsX,
            gpsY: gpsY,
            direction: direction,
            stationNo: stationNo,
            routeType: routeType,
            beginTm: beginTm,
            lastTm: lastTm,
            posX: posX,
            posY: posY,
            arsId: arsId,
            transYn: transYn,
            trnstnid: trnstnid,
            sectSpd: sectSpd,
            fullSectDist: fullSectDist
        ));
      });
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }
  return routeList;
}

Future<List<String>> getBusPosByRouteSt(String busRouteId, String endOrd) async {
  List<String> busPosList = [];
  try {
    final url = Uri.parse('http://ws.bus.go.kr/api/rest/buspos/getBusPosByRouteSt'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&busRouteId=$busRouteId'
        '&startOrd=1'
        '&endOrd=$endOrd'
        '&resultType=json'
    );

    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
      List<dynamic> items = jsonResponse['msgBody']['itemList'];

      items.forEach((item) {
        String sectOrd = item['sectOrd'].toString();
        busPosList.add(
          sectOrd
        );
      });
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }
  return busPosList;
}