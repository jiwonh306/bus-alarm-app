import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookmarkService {
  Future<void> saveBookmarks(List<BusStationInfo> busstationList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
    busstationList.map((bookmark) => json.encode(bookmark.toJson())).toList();
    await prefs.setStringList('bookmarks', jsonList);
  }

  Future<List<BusStationInfo>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('bookmarks');
    if (jsonList == null) return [];
    return jsonList.map((json) => BusStationInfo.fromJson(jsonDecode(json))).toList();
  }
}
