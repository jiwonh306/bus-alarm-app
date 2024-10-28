import 'package:bus_alarm_app/model/bus_station_info_model.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:bus_alarm_app/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:bus_alarm_app/widget/modal/bottom_sheet_modal.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/bus_info_model.dart';
import '../service/app_service.dart';
import '../service/weather_provider.dart';
import '../util/weather_change.dart';
import 'bookmark_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<BusStationInfo> favoriteStations = [];
  final BookmarkService bookmarkService = BookmarkService();

  @override
  void initState() {
    super.initState();
    print('api key: ' + dotenv.get("openWeatherApiKey"));
    _loadFavorites();

    // 날씨 정보를 가져옴
    Future.microtask(() {
      Provider.of<WeatherProvider>(context, listen: false).getWeather();
    });
  }

  Future<void> _loadFavorites() async {
    favoriteStations = await bookmarkService.loadBookmarks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('버스 알리미'),
        backgroundColor: Color(0xFF6b8e23),
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              top: 20,
              child: Container(
                width: 300,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                    _loadFavorites();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, color: Color(0xFF6b8e23)),
                      SizedBox(width: 10),
                      Text(
                        '정류소 찾기',
                        style: TextStyle(color: Color(0xFF444939)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 110,
              child: Container(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LikePage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, color: Color(0xFF6b8e23)),
                      SizedBox(width: 10),
                      Text(
                        '즐겨찾기',
                        style: TextStyle(color: Color(0xFF444939)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 날씨 정보 표시
            Positioned(
              left: 20,
              right: 20,
              top: 170, // 위치 조정
              child: Container(
                width: 300,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      weatherProvider.loadingStatus == LoadingStatus.searching
                          ? '날씨 정보를 가져오는 중...'
                          : weatherProvider.loadingStatus == LoadingStatus.empty
                          ? '날씨 정보를 찾을 수 없습니다.'
                          : '${weatherProvider.weather.temp}°C, ${getWeatherDescription(weatherProvider.weather.conditionId ?? 0)}',
                      style: TextStyle(fontSize: 18, color: Color(0xFF444939)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
