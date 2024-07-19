import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherRepository {
  final String apiKey = '88a213909c90e19505be42f17dadc963';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
