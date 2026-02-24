class WeatherModel {
  final String cityName;
  final String country;
  final double temp;
  final double feelsLike;
  final String condition;
  final int conditionCode;
  final String iconUrl;
  final int humidity;
  final double windKph;
  final double uv;
  final double visibilityKm;
  final int cloud;
  final bool isDay;
  final List<ForecastDay> forecast;
  final List<HourlyForecast> hourly;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.condition,
    required this.conditionCode,
    required this.iconUrl,
    required this.humidity,
    required this.windKph,
    required this.uv,
    required this.visibilityKm,
    required this.cloud,
    required this.isDay,
    required this.forecast,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final forecastList = json['forecast']['forecastday'] as List;

    // جلب بيانات الساعات من اليوم الحالي
    final todayHours = forecastList.isNotEmpty
        ? (forecastList[0]['hour'] as List)
            .map((h) => HourlyForecast.fromJson(h))
            .toList()
        : <HourlyForecast>[];

    return WeatherModel(
      cityName: json['location']['name'],
      country: json['location']['country'],
      temp: (json['current']['temp_c'] as num).toDouble(),
      feelsLike: (json['current']['feelslike_c'] as num).toDouble(),
      condition: json['current']['condition']['text'],
      conditionCode: json['current']['condition']['code'] as int,
      iconUrl: 'https:${json['current']['condition']['icon']}',
      humidity: json['current']['humidity'] as int,
      windKph: (json['current']['wind_kph'] as num).toDouble(),
      uv: (json['current']['uv'] as num).toDouble(),
      visibilityKm: (json['current']['vis_km'] as num).toDouble(),
      cloud: json['current']['cloud'] as int,
      isDay: (json['current']['is_day'] as int) == 1,
      forecast: forecastList.map((i) => ForecastDay.fromJson(i)).toList(),
      hourly: todayHours,
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final String iconUrl;
  final int conditionCode;
  final String condition;
  final int chanceOfRain;
  final double uv;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    required this.iconUrl,
    required this.conditionCode,
    required this.condition,
    required this.chanceOfRain,
    required this.uv,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      avgTemp: (json['day']['avgtemp_c'] as num).toDouble(),
      iconUrl: 'https:${json['day']['condition']['icon']}',
      conditionCode: json['day']['condition']['code'] as int,
      condition: json['day']['condition']['text'],
      chanceOfRain: json['day']['daily_chance_of_rain'] as int,
      uv: (json['day']['uv'] as num).toDouble(),
    );
  }
}

class HourlyForecast {
  final String time;
  final double temp;
  final String iconUrl;
  final int conditionCode;
  final bool isDay;
  final int chanceOfRain;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.iconUrl,
    required this.conditionCode,
    required this.isDay,
    required this.chanceOfRain,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      temp: (json['temp_c'] as num).toDouble(),
      iconUrl: 'https:${json['condition']['icon']}',
      conditionCode: json['condition']['code'] as int,
      isDay: (json['is_day'] as int) == 1,
      chanceOfRain: json['chance_of_rain'] as int,
    );
  }
}