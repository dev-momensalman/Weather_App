import '../../data/models/weather_model.dart';
abstract class WeatherState {}
class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherSuccess extends WeatherState {
  final WeatherModel weather;
  WeatherSuccess(this.weather);
}
class WeatherFailure extends WeatherState {
  final String error;
  WeatherFailure(this.error);
}