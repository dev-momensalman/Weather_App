import 'package:flutter/material.dart';

/// A utility class that maps weather condition codes to
/// weather types, gradients, and emoji icons.
class WeatherTheme {
  static WeatherType getType(int code, bool isDay) {
    if (code == 1000) return isDay ? WeatherType.sunny : WeatherType.clearNight;
    if (code <= 1003) return isDay ? WeatherType.partlyCloudy : WeatherType.cloudyNight;
    if (code <= 1009) return WeatherType.cloudy;
    if (code <= 1030) return WeatherType.mist;
    if (code <= 1067) return WeatherType.rain;
    if (code <= 1117) return WeatherType.snow;
    if (code <= 1135) return WeatherType.mist;
    if (code <= 1147) return WeatherType.snow;
    if (code <= 1201) return WeatherType.rain;
    if (code <= 1225) return WeatherType.snow;
    if (code <= 1282) return WeatherType.storm;
    return WeatherType.cloudy;
  }

  static List<Color> getGradient(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return [const Color(0xFF1a6fa8), const Color(0xFF2196F3), const Color(0xFF87CEEB)];
      case WeatherType.clearNight:
        return [const Color(0xFF0A0E27), const Color(0xFF1a1f4a), const Color(0xFF2d3561)];
      case WeatherType.partlyCloudy:
        return [const Color(0xFF1565C0), const Color(0xFF1976D2), const Color(0xFF64B5F6)];
      case WeatherType.cloudyNight:
        return [const Color(0xFF1a1a2e), const Color(0xFF16213e), const Color(0xFF0f3460)];
      case WeatherType.cloudy:
        return [const Color(0xFF37474F), const Color(0xFF546E7A), const Color(0xFF78909C)];
      case WeatherType.mist:
        return [const Color(0xFF455A64), const Color(0xFF607D8B), const Color(0xFF90A4AE)];
      case WeatherType.rain:
        return [const Color(0xFF1A237E), const Color(0xFF283593), const Color(0xFF3949AB)];
      case WeatherType.snow:
        return [const Color(0xFF37474F), const Color(0xFF4DB6AC), const Color(0xFFB2EBF2)];
      case WeatherType.storm:
        return [const Color(0xFF212121), const Color(0xFF37474F), const Color(0xFF455A64)];
    }
  }

  static String getEmoji(WeatherType type) {
    switch (type) {
      case WeatherType.sunny: return '☀️';
      case WeatherType.clearNight: return '🌙';
      case WeatherType.partlyCloudy: return '⛅';
      case WeatherType.cloudyNight: return '🌥️';
      case WeatherType.cloudy: return '☁️';
      case WeatherType.mist: return '🌫️';
      case WeatherType.rain: return '🌧️';
      case WeatherType.snow: return '❄️';
      case WeatherType.storm: return '⛈️';
    }
  }

  static Color getAccentColor(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
      case WeatherType.partlyCloudy:
        return const Color(0xFFFFB300);
      case WeatherType.clearNight:
      case WeatherType.cloudyNight:
        return const Color(0xFF7986CB);
      case WeatherType.rain:
      case WeatherType.storm:
        return const Color(0xFF64B5F6);
      case WeatherType.snow:
        return const Color(0xFFB2EBF2);
      case WeatherType.mist:
      case WeatherType.cloudy:
        return const Color(0xFFB0BEC5);
    }
  }
}

enum WeatherType {
  sunny,
  clearNight,
  partlyCloudy,
  cloudyNight,
  cloudy,
  mist,
  rain,
  snow,
  storm,
}
