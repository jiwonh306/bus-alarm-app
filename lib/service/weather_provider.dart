import 'package:bus_alarm_app/service/weather_service.dart';
import 'package:flutter/cupertino.dart';
import '../model/weather.dart';

enum LoadingStatus { completed, searching, empty }

class WeatherProvider with ChangeNotifier {
  final Weather _weather =
  Weather(temp: 20, condition: "Clouds", conditionId: 200, humidity: 50);
  Weather get weather => _weather;

  LoadingStatus _loadingStatus = LoadingStatus.empty;
  LoadingStatus get loadingStatus => _loadingStatus;

  String _message = "Loading...";
  String get message => _message;

  final OpenWeatherService _openWeatherService;

  // 생성자에 apiKey를 추가
  WeatherProvider({required String apiKey})
      : _openWeatherService = OpenWeatherService(apiKey: apiKey);

  Future<void> getWeather() async {
    _loadingStatus = LoadingStatus.searching;

    final weatherData = await _openWeatherService.getWeather();
    if (weatherData == null) {
      _loadingStatus = LoadingStatus.empty;
      _message = 'Could not find weather. Please try again.';
    } else {
      _loadingStatus = LoadingStatus.completed;
      _weather.condition = weatherData['weather'][0]['main'];
      _weather.conditionId = weatherData['weather'][0]['id'];
      _weather.humidity = weatherData['main']['humidity'];
      _weather.temp = weatherData['main']['temp'];
      _weather.temp = (_weather.temp! * 10).roundToDouble() / 10;
    }
    notifyListeners();
  }
}
