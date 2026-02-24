abstract class LanguageState {
  final String lang;
  const LanguageState(this.lang);
}

class LanguageArabic extends LanguageState {
  const LanguageArabic() : super('ar');
}

class LanguageEnglish extends LanguageState {
  const LanguageEnglish() : super('en');
}
