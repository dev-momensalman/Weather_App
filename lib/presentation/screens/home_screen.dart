import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../logic/language_cubit/language_cubit.dart';
import '../../logic/language_cubit/language_state.dart';
import '../../logic/weather_cubit/weather_cubit.dart';
import '../../logic/weather_cubit/weather_state.dart';
import '../widgets/weather_theme.dart';
import '../widgets/weather_widgets.dart';
import '../widgets/weather_states_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, langState) {
        final lang = langState.lang;
        final isAr = lang == 'ar';

        return BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state is WeatherSuccess) {
              _fadeController.reset();
              _fadeController.forward();
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return WeatherWelcomeWidget(
                lang: lang,
                searchController: _searchController,
                onUseLocation: () {
                  context.read<WeatherCubit>().getWeather(lang: lang);
                },
                onSearch: () {
                  final city = _searchController.text.trim();
                  if (city.isNotEmpty) {
                    context.read<WeatherCubit>().getWeather(city: city, lang: lang);
                    _searchController.clear();
                  }
                },
              );
            }

            if (state is WeatherLoading) {
              return const WeatherLoadingShimmer();
            }

            if (state is WeatherFailure) {
              final isPermissionError = state.error.contains('إعدادات') || state.error.toLowerCase().contains('settings');
              return WeatherErrorWidget(
                message: state.error,
                lang: lang,
                onRetry: () => context.read<WeatherCubit>().getWeather(lang: lang),
                onOpenSettings: isPermissionError ? () => Geolocator.openAppSettings() : null,
              );
            }


            if (state is WeatherSuccess) {
              final w = state.weather;
              final weatherType = WeatherTheme.getType(w.conditionCode, w.isDay);
              final gradient = WeatherTheme.getGradient(weatherType);
              final emoji = WeatherTheme.getEmoji(weatherType);
              final accent = WeatherTheme.getAccentColor(weatherType);

              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
                child: Scaffold(
                  backgroundColor: gradient.first,
                  body: AnimatedContainer(
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradient,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: RefreshIndicator(
                      color: accent,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      onRefresh: () async {
                        context.read<WeatherCubit>().getWeather(lang: lang);
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: SafeArea(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 16),

                                      // ─── Search Bar + Lang Toggle ──────
                                      _buildSearchBar(context, accent, lang),

                                      const SizedBox(height: 36),

                                      // ─── City + Country ───────────────
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.location_on_rounded,
                                              color: accent, size: 18),
                                          const SizedBox(width: 6),
                                          Text(
                                            _getLocalizedLocation(w.cityName, w.country, isAr),
                                            style: GoogleFonts.cairo(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8),

                                      // ─── Date ─────────────────────────
                                      Text(
                                        DateFormat('EEEE، d MMMM y', isAr ? 'ar' : 'en')
                                            .format(DateTime.now()),
                                        style: GoogleFonts.cairo(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      // ─── Weather Emoji ─────────────────
                                      AnimatedBuilder(
                                        animation: _pulseAnimation,
                                        builder: (context, child) =>
                                            Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: child,
                                        ),
                                        child: Text(
                                          emoji,
                                          style: const TextStyle(fontSize: 90),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      // ─── Temperature ──────────────────
                                      Text(
                                        '${w.temp.round()}°',
                                        style: GoogleFonts.cairo(
                                          color: Colors.white,
                                          fontSize: 96,
                                          fontWeight: FontWeight.w200,
                                          height: 1.0,
                                        ),
                                      ),

                                      // ─── Condition ────────────────────
                                      Text(
                                        w.condition,
                                        style: GoogleFonts.cairo(
                                          color: Colors.white70,
                                          fontSize: 20,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // ─── Feels Like ───────────────────
                                      Text(
                                        isAr
                                            ? 'الإحساس بـ ${w.feelsLike.round()}°'
                                            : 'Feels like ${w.feelsLike.round()}°',
                                        style: GoogleFonts.cairo(
                                          color: Colors.white38,
                                          fontSize: 14,
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // ─── Hi / Lo strip ────────────────
                                      if (w.forecast.isNotEmpty)
                                        _buildHiLoBadge(
                                            w.forecast.first.maxTemp,
                                            w.forecast.first.minTemp,
                                            accent,
                                            isAr),

                                      const SizedBox(height: 28),

                                      // ─── Stats Grid ───────────────────
                                      WeatherStatsGrid(
                                        humidity: w.humidity,
                                        windKph: w.windKph,
                                        uv: w.uv,
                                        visibilityKm: w.visibilityKm,
                                        feelsLike: w.feelsLike,
                                        cloud: w.cloud,
                                        weatherType: weatherType,
                                        lang: lang,
                                      ),

                                      const SizedBox(height: 20),

                                      // ─── Hourly Forecast ──────────────
                                      if (w.hourly.isNotEmpty)
                                        HourlyForecastStrip(
                                          hours: w.hourly,
                                          weatherType: weatherType,
                                          lang: lang,
                                        ),

                                      const SizedBox(height: 20),

                                      // ─── 7-Day Forecast Card ──────────
                                      _buildDailyForecastCard(
                                          w.forecast, weatherType, accent, lang),

                                      const SizedBox(height: 32),

                                      // ─── Footer ───────────────────────
                                      Text(
                                        isAr
                                            ? 'آخر تحديث: ${DateFormat('h:mm a', 'ar').format(DateTime.now())}'
                                            : 'Last updated: ${DateFormat('h:mm a', 'en').format(DateTime.now())}',
                                        style: GoogleFonts.cairo(
                                          color: Colors.white24,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, Color accent, String lang) {
    final isAr = lang == 'ar';
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: _isSearching ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _isSearching
                    ? accent.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.12),
                width: 1.5,
              ),
              boxShadow: _isSearching
                  ? [BoxShadow(color: accent.withValues(alpha: 0.2), blurRadius: 20)]
                  : [],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              style: GoogleFonts.cairo(color: Colors.white, fontSize: 16),
              textInputAction: TextInputAction.search,
              textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              decoration: InputDecoration(
                hintText: isAr ? 'ابحث عن مدينة...' : 'Search a city...',
                hintStyle: GoogleFonts.cairo(
                  color: Colors.white38,
                  fontSize: 15,
                ),
                prefixIcon: Icon(Icons.search_rounded,
                    color: _isSearching ? accent : Colors.white38),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white38),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocus.unfocus();
                          setState(() => _isSearching = false);
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.my_location_rounded,
                            color: Colors.white38),
                        onPressed: () {
                          context.read<WeatherCubit>().getWeather(lang: lang);
                        },
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
              ),
              onTap: () => setState(() => _isSearching = true),
              onSubmitted: (city) {
                if (city.trim().isNotEmpty) {
                  context
                      .read<WeatherCubit>()
                      .getWeather(city: city.trim(), lang: lang);
                }
                setState(() => _isSearching = false);
                _searchFocus.unfocus();
                _searchController.clear();
              },
            ),
          ),
        ),

        // ─── Language Toggle ───────────────────────────────────────────
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            final cubit = context.read<LanguageCubit>();
            cubit.toggle();
            // Re-fetch weather in new language
            final weatherState = context.read<WeatherCubit>().state;
            if (weatherState is WeatherSuccess) {
              context.read<WeatherCubit>().getWeather(
                    lang: cubit.state.lang,
                  );
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            alignment: Alignment.center,
            child: Text(
              isAr ? 'EN' : 'ع',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: isAr ? 12 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHiLoBadge(double max, double min, Color accent, bool isAr) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.keyboard_arrow_up_rounded, color: accent, size: 20),
                Text(
                  '${max.round()}°',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 1,
                  height: 16,
                  color: Colors.white24,
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white38, size: 20),
                Text(
                  '${min.round()}°',
                  style: GoogleFonts.cairo(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyForecastCard(
      List forecast, WeatherType weatherType, Color accent, String lang) {
    final isAr = lang == 'ar';
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: accent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      isAr
                          ? 'التوقعات لـ ${forecast.length} أيام'
                          : '${forecast.length}-Day Forecast',
                      style: GoogleFonts.cairo(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white12, height: 24),
                ...forecast.asMap().entries.map((entry) => DailyForecastRow(
                      day: entry.value,
                      isToday: entry.key == 0,
                      weatherType: weatherType,
                      lang: lang,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}