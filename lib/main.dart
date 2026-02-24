import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/data_providers/weather_provider.dart';
import 'data/repositories/weather_repository.dart';
import 'logic/language_cubit/language_cubit.dart';
import 'logic/language_cubit/language_state.dart';
import 'logic/weather_cubit/weather_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WeatherRepository(WeatherProvider()),
        ),
        BlocProvider(
          create: (context) => WeatherCubit(context.read<WeatherRepository>()),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, langState) {
          final isArabic = langState.lang == 'ar';
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: isArabic ? 'طقسي - تطبيق الطقس' : 'Taqsi - Weather App',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'EG'),
              Locale('en', 'US'),
            ],
            locale: isArabic ? const Locale('ar', 'EG') : const Locale('en', 'US'),
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: GoogleFonts.cairo().fontFamily,
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF4FC3F7),
                secondary: const Color(0xFF81D4FA),
                surface: const Color(0xFF0A0E27),
              ),
              scaffoldBackgroundColor: const Color(0xFF0A0E27),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}