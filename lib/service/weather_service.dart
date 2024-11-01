import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bus_alarm_app/util/network_helper.dart';
import 'package:geolocator/geolocator.dart';

class OpenWeatherService {
  final String _apiKey;
  
  OpenWeatherService({required String apiKey}) : _apiKey = apiKey;

  Future getWeather() async {
    Position myLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final weatherData = await NetworkHelper().getData(
        'https://api.openweathermap.org/data/2.5/weather?lat=${myLocation.latitude}&lon=${myLocation.longitude}&appid=$_apiKey&units=metric');

    return weatherData;
  }
}
