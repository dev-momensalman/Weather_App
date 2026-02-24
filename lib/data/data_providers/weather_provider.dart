import 'package:http/http.dart' as http;

class WeatherProvider {
  final String apiKey = 'a1dfc69368a34c8293b10719262302';

  Future<String> getRawWeatherData(String query) async {
    final String url = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$query&days=7&aqi=no&lang=ar';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.body;
    throw 'خطأ في الاتصال بالسيرفر';
  }
}