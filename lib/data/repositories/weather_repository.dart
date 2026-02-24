import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../data_providers/weather_provider.dart';

class WeatherRepository {
  final WeatherProvider weatherProvider;
  WeatherRepository(this.weatherProvider);

  /// جلب بيانات الطقس بناءً على اسم المدينة أو الموقع الجغرافي
  Future<WeatherModel> fetchWeather(String? city) async {
    String query;

    // إذا لم يتم تمرير اسم مدينة، نحاول جلب الموقع الحالي
    if (city == null || city.isEmpty) {
      try {
        // محاولة جلب الموقع في وقت قياسي
        Position position = await _getCurrentLocation();
        query = '${position.latitude},${position.longitude}';
      } catch (e) {
        // في حالة فشل أو تأخر الـ GPS، نستخدم مدينة افتراضية فوراً لضمان سرعة الاستجابة
        query = "Cairo";
      }
    } else {
      query = city;
    }

    // طلب البيانات الخام من الـ Provider
    final rawData = await weatherProvider.getRawWeatherData(query);

    // تحويل البيانات من JSON إلى Model
    return WeatherModel.fromJson(jsonDecode(rawData));
  }

  /// دالة جلب الموقع الجغرافي بأسرع وسيلة ممكنة
  Future<Position> _getCurrentLocation() async {
    // 1. محاولة جلب آخر موقع مسجل على الجهاز (عملية لحظية لا تستغرق وقتاً)
    Position? lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) return lastKnown;

    // 2. التحقق من تفعيل خدمة الموقع والأذونات
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'إذن الموقع مرفوض';
      }
    }

    // 3. طلب الموقع الحالي بدقة منخفضة جداً (Lowest) لتقليل وقت البحث
    // وضع مهلة زمنية (3 ثوانٍ) لمنع تعليق التطبيق في حالة ضعف إشارة الـ GPS
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.lowest,
      timeLimit: const Duration(seconds: 3),
    );
  }
}