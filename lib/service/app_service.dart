import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps Flutter 패키지
import 'dart:convert'; // JSON 인코딩 및 디코딩을 위한 패키지
import 'dart:io'; // HTTP 요청을 위한 패키지
import 'package:http/http.dart' as http; // HTTP 요청 라이브러리
import 'package:xml2json/xml2json.dart';

import '../model/bus_info_model.dart'; // XML을 JSON으로 변환하기 위한 패키지

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
        String nodenm = item['nodenm']; // 정류장 이름
        String citycode = item['citycode'].toString(); // 도시코드
        String nodeid = item['nodeid'].toString();

        List<BusInfo> busInfoList = await route(citycode, nodeid);
        List<String> busList = busInfoList.map((bus) => bus.routeNo).toList(); // 노선번호만 리스트로 변환

        print(nodenm);
        print(nodeid);

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
  List<BusInfo> busInfoList = [];

  try {
    final url = Uri.parse('http://apis.data.go.kr/1613000/ArvlInfoInqireService/getSttnAcctoArvlPrearngeInfoList'
        '?ServiceKey=C1xlYgGuqhzV%2ByBIrUZqZRpEVWsAcp36U%2Fp8W71wN18sSy%2FA3ooEhyrMm0SJu9uR56w0Tl4WQLK7df%2FsPvqenA%3D%3D'
        '&pageNo=1'
        '&numOfRows=10'
        '&_type=json'
        '&cityCode=$cityCode'
        '&nodeId=$nodeID');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = jsonDecode(decodedBody);
      List<dynamic> items = jsonResponse['response']['body']['items']['item'];

      for (var item in items) {
        BusInfo busInfo = BusInfo(
          nodeId: item['nodeid'].toString(),
          nodeNm: item['nodenm'].toString(),
          routeNo: item['routeno'].toString(),
          routeTp: item['routetp'].toString(),
          arrPrevStationCnt: item['arrprevstationcnt'].toString(),
          vehicleTp: item['vehicletp'].toString(),
          arrTime: item['arrtime'].toString(),
        );
        busInfoList.add(busInfo);

      }

      // arrtime이 가장 작은 버스 정보만 남기기
      var grouped = <String, List<BusInfo>>{};
      for (var bus in busInfoList) {
        if (!grouped.containsKey(bus.routeNo)) {
          grouped[bus.routeNo] = [];
        }
        grouped[bus.routeNo]!.add(bus);
      }

      busInfoList = grouped.values.map((list) {
        return list.reduce((a, b) => a.arrTime.compareTo(b.arrTime) < 0 ? a : b);
      }).toList();

    } else {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Exception: $e');
  }

  return busInfoList;
}
