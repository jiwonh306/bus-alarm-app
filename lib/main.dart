import 'package:bus_alarm_app/screen/bookmark_screen.dart';
import 'package:bus_alarm_app/screen/main_screen.dart';
import 'package:bus_alarm_app/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:bus_alarm_app/service/alarm_service.dart';
import 'package:bus_alarm_app/service/weather_provider.dart'; // WeatherProvider 임포트
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart'; // Provider 임포트
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 임포트

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initLocalNotifications(); // 알람 초기화
  tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // WeatherProvider에 필요한 값을 dotenv로부터 가져오기
    String apiKey = dotenv.env['openWeatherApiKey'] ?? ''; // 환경 변수에서 API_KEY 가져오기

    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(apiKey: apiKey), // WeatherProvider 인스턴스 생성
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
