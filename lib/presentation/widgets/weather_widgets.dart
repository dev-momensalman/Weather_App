import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/weather_model.dart';
import 'weather_theme.dart';

class HourlyForecastStrip extends StatelessWidget {
  final List<HourlyForecast> hours;
  final WeatherType weatherType;
  final String lang;

  const HourlyForecastStrip({
    super.key,
    required this.hours,
    required this.weatherType,
    this.lang = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final accent = WeatherTheme.getAccentColor(weatherType);
    final isAr = lang == 'ar';
    final now = DateTime.now();
    final filteredHours = hours
        .where((h) {
          final hTime = DateTime.parse(h.time);
          return hTime.isAfter(now.subtract(const Duration(minutes: 30)));
        })
        .take(12)
        .toList();

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded, color: accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'التوقعات الساعية' : 'Hourly Forecast',
                        style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredHours.isEmpty
                        ? hours.length
                        : filteredHours.length,
                    itemBuilder: (context, i) {
                      final h = filteredHours.isEmpty ? hours[i] : filteredHours[i];
                      final hTime = DateTime.parse(h.time);
                      final isNow = i == 0 && filteredHours.isNotEmpty;
                      return _HourCard(
                        hour: h,
                        hTime: hTime,
                        isNow: isNow,
                        accent: accent,
                        lang: lang,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HourCard extends StatelessWidget {
  final HourlyForecast hour;
  final DateTime hTime;
  final bool isNow;
  final Color accent;
  final String lang;

  const _HourCard({
    required this.hour,
    required this.hTime,
    required this.isNow,
    required this.accent,
    this.lang = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final isAr = lang == 'ar';
    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isNow
            ? accent.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: isNow
            ? Border.all(color: accent.withValues(alpha: 0.5), width: 1.5)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isNow
                ? (isAr ? 'الآن' : 'Now')
                : DateFormat('h a', isAr ? 'ar' : 'en').format(hTime),
            style: GoogleFonts.cairo(
              color: isNow ? accent : Colors.white60,
              fontSize: 11,
              fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          Image.network(
            hour.iconUrl,
            width: 32,
            height: 32,
            errorBuilder: (_, __, ___) =>
                const Text('🌡️', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),
          Text(
            '${hour.temp.round()}°',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DailyForecastRow extends StatelessWidget {
  final ForecastDay day;
  final bool isToday;
  final WeatherType weatherType;
  final String lang;

  const DailyForecastRow({
    super.key,
    required this.day,
    required this.isToday,
    required this.weatherType,
    this.lang = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final accent = WeatherTheme.getAccentColor(weatherType);
    final isAr = lang == 'ar';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isToday ? accent.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          // Day name — fills remaining space
          Expanded(
            child: Text(
              isToday
                  ? (isAr ? 'اليوم' : 'Today')
                  : DateFormat('EEEE', isAr ? 'ar' : 'en')
                      .format(DateTime.parse(day.date)),
              style: GoogleFonts.cairo(
                color: isToday ? accent : Colors.white,
                fontSize: 12,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Chance of rain (optional, compact)
          if (day.chanceOfRain > 0) ...[
            const SizedBox(width: 4),
            const Icon(Icons.water_drop_rounded,
                color: Color(0xFF64B5F6), size: 11),
            Text(
              '${day.chanceOfRain}%',
              style: GoogleFonts.cairo(
                color: const Color(0xFF64B5F6),
                fontSize: 10,
              ),
            ),
          ],
          const SizedBox(width: 8),
          // Weather icon
          Image.network(
            day.iconUrl,
            width: 26,
            height: 26,
            errorBuilder: (_, __, ___) =>
                const Text('🌤️', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 26,
            child: Text(
              '${day.minTemp.round()}°',
              style: GoogleFonts.cairo(
                color: Colors.white38,
                fontSize: 12,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 4),
          _TempBar(
            minTemp: day.minTemp,
            maxTemp: day.maxTemp,
            accent: accent,
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 26,
            child: Text(
              '${day.maxTemp.round()}°',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TempBar extends StatelessWidget {
  final double minTemp;
  final double maxTemp;
  final Color accent;

  const _TempBar(
      {required this.minTemp, required this.maxTemp, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [const Color(0xFF64B5F6), accent],
        ),
      ),
    );
  }
}

class WeatherStatsGrid extends StatelessWidget {
  final int humidity;
  final double windKph;
  final double uv;
  final double visibilityKm;
  final double feelsLike;
  final int cloud;
  final WeatherType weatherType;
  final String lang;

  const WeatherStatsGrid({
    super.key,
    required this.humidity,
    required this.windKph,
    required this.uv,
    required this.visibilityKm,
    required this.feelsLike,
    required this.cloud,
    required this.weatherType,
    this.lang = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final accent = WeatherTheme.getAccentColor(weatherType);
    final isAr = lang == 'ar';
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _StatTile(
          icon: Icons.water_drop_rounded,
          label: isAr ? 'الرطوبة' : 'Humidity',
          value: '$humidity%',
          accent: accent,
        ),
        _StatTile(
          icon: Icons.air_rounded,
          label: isAr ? 'الرياح' : 'Wind',
          value: isAr ? '${windKph.round()} كم/س' : '${windKph.round()} km/h',
          accent: accent,
        ),
        _StatTile(
          icon: Icons.wb_sunny_rounded,
          label: isAr ? 'الأشعة ف.ب' : 'UV Index',
          value: uv.toStringAsFixed(1),
          accent: accent,
        ),
        _StatTile(
          icon: Icons.visibility_rounded,
          label: isAr ? 'الرؤية' : 'Visibility',
          value: isAr ? '${visibilityKm.round()} كم' : '${visibilityKm.round()} km',
          accent: accent,
        ),
        _StatTile(
          icon: Icons.thermostat_rounded,
          label: isAr ? 'الإحساس' : 'Feels Like',
          value: '${feelsLike.round()}°',
          accent: accent,
        ),
        _StatTile(
          icon: Icons.cloud_rounded,
          label: isAr ? 'الغيوم' : 'Cloud',
          value: '$cloud%',
          accent: accent,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accent, size: 18),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.cairo(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
