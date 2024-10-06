import 'dart:developer'; // 로깅을 위한 패키지

import 'package:bus_alarm_app/service/app_service.dart';
import 'package:bus_alarm_app/widget/popup/node_detail_popup.dart';
import 'package:flutter/material.dart'; // Flutter UI 구성 요소
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps Flutter 패키지
import 'package:geolocator/geolocator.dart'; // 위치 정보 접근 패키지


class MapScreen extends StatefulWidget { // 상태가 있는 MapScreen 클래스 정의
  @override
  State<MapScreen> createState() => MapScreenState(); // 상태 관리 클래스 반환
}

class MapScreenState extends State<MapScreen> { // MapScreen의 상태 관리 클래스
  late GoogleMapController mapController; // Google Map 컨트롤러
  LatLng _currentPosition = const LatLng(37.34173241575176, 126.83166740085191); // 초기 서울 좌표
  final Set<Marker> _markers = {}; // 지도에 표시할 마커 세트

  @override
  void initState() { // 위젯 초기화 메서드
    super.initState();
    _getCurrentLocation(); // 현재 위치를 가져옴
  }

  void addMarker(LatLng _position, String _title, List<String> _busList) {// 마커 추가 메서드
    setState(() { // 상태 변경
      _markers.add( // 마커 추가
        Marker(
            markerId: MarkerId(_position.toString()), // 마커 ID 설정
            position: _position, // 마커 위치
            infoWindow: InfoWindow( // 마커 정보창
              title: _title,
            ),
            icon: BitmapDescriptor.defaultMarker, // 기본 마커 아이콘
            onTap: (){
              _onMarkerTapped(_title, _busList);
            }
        ),
      );
      mapController.animateCamera( // 카메라 위치 이동
        CameraUpdate.newLatLng(_currentPosition), // 현재 위치로 이동
      );
    });
  }

  Future<void> _getCurrentLocation() async { // 현재 위치 가져오기 메서드
    bool serviceEnabled; // 위치 서비스 활성화 여부
    LocationPermission permission; // 위치 권한

    serviceEnabled = await Geolocator.isLocationServiceEnabled(); // 위치 서비스 활성화 확인
    if (!serviceEnabled) { // 비활성화된 경우
      return Future.error('Location services are disabled.'); // 오류 처리
    }

    permission = await Geolocator.checkPermission(); // 권한 확인
    if (permission == LocationPermission.denied) { // 권한이 거부된 경우
      permission = await Geolocator.requestPermission(); // 권한 요청
      if (permission == LocationPermission.denied) { // 여전히 거부된 경우
        return Future.error('Location permissions are denied'); // 오류 처리
      }
    }
    if (permission == LocationPermission.deniedForever) { // 권한이 영구적으로 거부된 경우
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'); // 오류 처리
    }

    // 현재 위치를 가져옴
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // 높은 정확도로 위치 가져오기
    setState(() { // 상태 변경
      //_currentPosition = LatLng(position.latitude, position.longitude);
      fetchBusInfo(_currentPosition, addMarker);
      // 현재 위치 업데이트
      // 지도 카메라를 현재 위치로 이동
      mapController.animateCamera(
        CameraUpdate.newLatLng(_currentPosition), // 카메라 이동
      );
    });

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        fetchBusInfo(LatLng(position.latitude, position.longitude), addMarker);
      });
    });

  }

  void _onMapCreated(GoogleMapController controller) { // 지도 생성 시 호출되는 메서드
    mapController = controller; // Google Map 컨트롤러 설정
  }

  void _onMarkerTapped(String markerTitle, List<String> busList) {
    showDialog(
      context: context,
      builder: (context) {
        return NodeDetailPopup(busList: busList, nodenm: markerTitle);
      },
    );
  }

  @override
  Widget build(BuildContext context) { // UI 빌드 메서드
    return Scaffold( // 기본 구조
      appBar: AppBar( // 앱바
        title: Text('현재 위치 가져오기'), // 앱 제목
      ),
      body: GoogleMap( // Google Map 위젯
        onMapCreated: _onMapCreated, // 지도 생성 시 호출
        initialCameraPosition: CameraPosition( // 초기 카메라 위치
          target: _currentPosition, // 현재 위치
          zoom: 14.0, // 줌 레벨
        ),
        markers: _markers, // 표시할 마커
        myLocationEnabled: true, // 내 위치 버튼 활성화
      ),
    );
  }
}