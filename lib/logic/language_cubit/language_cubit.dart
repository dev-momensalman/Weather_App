import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageArabic());

  void setArabic() => emit(const LanguageArabic());
  void setEnglish() => emit(const LanguageEnglish());

  void toggle() {
    if (state is LanguageArabic) {
      emit(const LanguageEnglish());
    } else {
      emit(const LanguageArabic());
    }
  }
}
