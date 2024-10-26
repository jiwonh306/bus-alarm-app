import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'dart:convert';

class BookmarkService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> saveBookmarks(List<BusStationInfo> busstationList) async {
    List<String> jsonList = busstationList.map((bookmark) => json.encode(bookmark.toJson())).toList();
    await _secureStorage.write(key: 'bookmarks', value: json.encode(jsonList));
  }

  Future<List<BusStationInfo>> loadBookmarks() async {
    String? jsonString = await _secureStorage.read(key: 'bookmarks');
    if (jsonString == null) return [];

    List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((jsonString) {
      return BusStationInfo.fromJson(json.decode(jsonString));
    }).toList();
  }
}
