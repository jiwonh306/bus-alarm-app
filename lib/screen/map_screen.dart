import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../model/bus_info_model.dart';
import '../service/app_service.dart';
import '../widget/modal/bottom_sheet_modal.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(37.49011964712499, 126.9546344219442);
  final Set<Marker> _markers = {};
  final BookmarkService bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void addMarker(BusStationInfo busStation) {
    LatLng position = LatLng(double.parse(busStation.gpsY), double.parse(busStation.gpsX));
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(busStation.arsId),
          position: position,
          infoWindow: InfoWindow(title: busStation.stationNm),
          onTap: () => _onMarkerTapped(busStation),
        ),
      );
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
      getStationByPos(_currentPosition, addMarker); // 현재 위치를 기반으로 마커 추가
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _onMarkerTapped(BusStationInfo busStation) async {
    List<BusInfo> busList = await getStationByUid(busStation.arsId);
    List<BusStationInfo> likeList = await bookmarkService.loadBookmarks();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetModal(
          busList: busList,
          busStation: busStation,
          initLikeList: likeList,
          onFavoritesChanged: () {
            setState(() {
              _markers.clear();
              getStationByPos(_currentPosition, addMarker);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정류장 찾기'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
      ),
    );
  }
}
