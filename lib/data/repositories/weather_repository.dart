import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../data_providers/weather_provider.dart';

class WeatherRepository {
  final WeatherProvider weatherProvider;
  WeatherRepository(this.weatherProvider);

  Future<WeatherModel> fetchWeather(String? city, {String lang = 'ar'}) async {
    String query;

    if (city == null || city.isEmpty) {
      final position = await _getCurrentLocation(lang);
      query = '${position.latitude},${position.longitude}';
    } else {
      query = city;
    }

    final rawData = await weatherProvider.getRawWeatherData(query, languageCode: lang);
    return WeatherModel.fromJson(jsonDecode(rawData));
  }

  Future<Position> _getCurrentLocation(String lang) async {
    final isAr = lang == 'ar';
    
    // 1. Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw isAr 
        ? 'خدمة الموقع معطلة. يرجى تفعيل GPS من إعدادات الجهاز.'
        : 'Location services are disabled. Please enable GPS in your device settings.';
    }

    // 2. Check and request permissions
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw isAr 
          ? 'إذن الموقع مرفوض. يرجى السماح للتطبيق بالوصول إلى موقعك.'
          : 'Location permission denied. Please allow access to fetch local weather.';
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw isAr 
        ? 'إذن الموقع محظور نهائياً. يرجى تفعيله من إعدادات التطبيق.'
        : 'Location permission is permanently denied. Please enable it from the app settings.';
    }

    // 3. Fetch fresh position (High accuracy)
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // If direct fetch fails (e.g. timeout), try last known as a backup
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;
      
      throw isAr 
        ? 'فشل الاتصال بالأقمار الصناعية. يرجى التأكد من أنك في مكان مفتوح.'
        : 'Failed to acquire location. Please ensure you have a clear sky view.';
    }
  }
}