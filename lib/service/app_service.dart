import 'package:bus_alarm_app/model/bus_info_model.dart';
import 'package:bus_alarm_app/model/route_info_model.dart';
import 'package:bus_alarm_app/util/second_to_minute_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps Flutter 패키지
import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'dart:io'; // HTTP 요청을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청 라이브러리
import 'package:xml2json/xml2json.dart'; // XML을 JSON으로 변환하기 위한 패키지

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

Future<void> fetchBusInfo(LatLng _currentPosition, Function callback) async { // 주변 버스 정류장 정보 가져오기
  try {
    final url = Uri.parse('http://apis.data.go.kr/1613000/BusSttnInfoInqireService/getCrdntPrxmtSttnList'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&pageNo=1'
        '&numOfRows=10'
        '&_type=json'
        '&gpsLati=${_currentPosition.latitude}' // 현재 위치의 위도
        '&gpsLong=${_currentPosition.longitude}'); // 현재 위치의 경도
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json', // 요청 헤더 설정
    });
    if (response.statusCode >= 200 && response.statusCode <= 300) { // 요청 성공 여부 확인
      final decodedBody = utf8.decode(response.bodyBytes); // 응답 본문 디코딩

      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody); // JSON 디코딩
      List<dynamic> items = jsonResponse['response']['body']['items']['item']; // 정류장 정보 목록
      items.forEach((item) async { // 각 정류장에 대해
        String gpslati = item['gpslati'].toString(); // 위도
        String gpslong = item['gpslong'].toString(); // 경도
        String nodenm = item['nodenm'].toString(); // 정류장 이름
        String citycode = item['citycode'].toString(); // 도시코드
        String nodeid = item['nodeid'].toString();

        List<BusInfo> busList = await route(citycode, nodeid);



        callback(LatLng(double.parse(gpslati), double.parse(gpslong)), nodenm, busList); // 마커 추가
      });
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}'); // 오류 처리
    }
  } catch (e) {
    print('Exception: $e'); // 예외 처리
  }
}

Future<List<BusInfo>> route(String cityCode, String nodeID) async {
  List<BusInfo> busList = [];
  try {
    final url = Uri.parse('http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&pageNo=1'
        '&numOfRows=10'
        '&_type=json'
        '&cityCode=$cityCode'
        '&nodeId=$nodeID'
    );

    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
      List<dynamic> items = jsonResponse['response']['body']['items']['item'];

      items.forEach((item) {
        String nodeId = item['nodeid'].toString(); // 정류소ID
        String nodeNm = item['nodenm'].toString(); // 정류소명
        String routeNo = item['routeno'].toString(); // 노선번호
        String routeTp = item['routetp'].toString(); // 노선유형
        String arrPrevStationCnt = item['arrprevstationcnt'].toString(); // 남은 정류장 수
        String vehicleTp = item['vehicletp'].toString(); // 차량유형
        String arrTime = convertSecondsToMinutes(item['arrtime'].toInt()); // 도착예상시간
        String routeId = item['routeid'].toString();
        busList.add(BusInfo(
            nodeId: nodeId,
            nodeNm: nodeNm,
            routeNo: routeNo,
            routeTp: routeTp,
            arrPrevStationCnt: arrPrevStationCnt,
            vehicleTp: vehicleTp,
            arrTime: arrTime,
            cityCode: cityCode,
            routeId: routeId));
      });
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }
  return busList;
}

Future<List<RouteInfo>> getnodenm(String cityCode, String routeID) async { // 주변 버스 정류장 정보 가져오기
  List<RouteInfo> routeList = [];
  try {
    final url = Uri.parse('http://apis.data.go.kr/1613000/BusRouteInfoInqireService/getRouteInfoIem'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&_type=json'
        '&cityCode=$cityCode'
        '&routeId=$routeID'
    );
    final response = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json', // 요청 헤더 설정
    });
    if (response.statusCode >= 200 && response.statusCode <= 300) { // 요청 성공 여부 확인


     final decodedBody = utf8.decode(response.bodyBytes); // 응답 본문 디코딩

      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody); // JSON 디코딩
      List<dynamic> items = jsonResponse['response']['body']['items']['item']; // 정류장 정보 목록
      print(items);
      /*items.forEach((item) async {
        String routeId = item['routeid'].toString(); // 정류소ID
        String routeNo = item['routeno'].toString(); // 정류소명
        String routeTp = item['routetp'].toString(); // 노선번호
        String endnodeNm = item['endnodenm'].toString(); // 노선유형
        String startnodeNm = item['startnodenm'].toString(); // 남은 정류장 수
        String endvehicleTime = item['endvehicletime,'].toString(); // 차량유형
        String startvehicleTime = item['startvehicletime'].toString(); // 도착예상시간
        String intervalTime = item['intervaltime'].toString();
        String intervalsatTime = item['intervalsattime'].toString();
        String intervalsunTime = item['intervalsuntime'].toString();
        routeList.add(
          RouteInfo(
              routeid: routeId,
              routeno: routeNo,
              routetp: routeTp,
              endnodenm: endnodeNm,
              startnodenm: startnodeNm,
              endvehicletime: endvehicleTime,
              startvehicletime: startvehicleTime,
              intervaltime: intervalTime,
              intervalsattime: intervalsatTime,
              intervalsuntime: intervalsunTime
          )
        );
      });*/
    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}'); // 오류 처리
    }
  } catch (e) {
    print('Exception: $e');
  }
  return routeList;
}