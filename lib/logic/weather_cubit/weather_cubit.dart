import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_state.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> getWeather({String? city, String lang = 'ar'}) async {
    emit(WeatherLoading());
    try {
      if (city != null && city.isNotEmpty) {
        final weather = await repository.fetchWeather(city, lang: lang);
        emit(WeatherSuccess(weather));
        return;
      }

      final positionWeather = await repository.fetchWeather(null, lang: lang);
      emit(WeatherSuccess(positionWeather));

    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}