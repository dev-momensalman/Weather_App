import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/weather_repository.dart';

abstract class SearchState {}
class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSuccess extends SearchState {
  final List<String> suggestions;
  SearchSuccess(this.suggestions);
}
class SearchError extends SearchState {}

class SearchCubit extends Cubit<SearchState> {
  final WeatherRepository repository;
  SearchCubit(this.repository) : super(SearchInitial());

  void getSuggestions(String query) async {
    if (query.length < 2) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final suggestions = await repository.searchCities(query);
      emit(SearchSuccess(suggestions));
    } catch (_) {
      emit(SearchError());
    }
  }

  void clearSuggestions() {
    emit(SearchInitial());
  }
}
