import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ─── Welcome Screen ────────────────────────────────────────────────────────

class WeatherWelcomeWidget extends StatelessWidget {
  final VoidCallback onUseLocation;
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onLanguageToggle;
  final String lang;

  const WeatherWelcomeWidget({
    super.key,
    required this.onUseLocation,
    required this.searchController,
    required this.onSearch,
    required this.onLanguageToggle,
    this.lang = 'ar',
  });

  @override
  Widget build(BuildContext context) {
    final isAr = lang == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1E3A), Color(0xFF0D1F3C)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Language Toggle (Top Right)
              Positioned(
                top: 10,
                right: isAr ? null : 20,
                left: isAr ? 20 : null,
                child: GestureDetector(
                  onTap: onLanguageToggle,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language_rounded, color: Colors.white70, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              isAr ? 'English' : 'العربية',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const Spacer(flex: 2),

                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4FC3F7).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.cloud_queue_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  isAr ? 'مرحباً بك في طقسي' : 'Welcome to Taqsi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  isAr
                      ? 'احصل على طقس دقيق لموقعك أو أي مدينة في العالم'
                      : 'Get accurate weather for your location or any city worldwide',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 15,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 2),

                // Use Location Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onUseLocation,
                    icon: const Icon(Icons.my_location_rounded),
                      label: Text(
                        isAr ? 'استخدام موقعي الحالي' : 'Use My Location',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white12)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        isAr ? 'أو' : 'or',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white12)),
                  ],
                ),

                const SizedBox(height: 20),

                // City Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    textInputAction: TextInputAction.search,
                    textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                    onSubmitted: (_) => onSearch(),
                    decoration: InputDecoration(
                      hintText: isAr ? 'اكتب اسم المدينة...' : 'Enter city name...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: Colors.white38),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            color: Color(0xFF4FC3F7), size: 18),
                        onPressed: onSearch,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),

                ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Loading Shimmer ────────────────────────────────────────────────────────

class WeatherLoadingShimmer extends StatelessWidget {
  const WeatherLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Shimmer.fromColors(
        baseColor: Colors.white.withValues(alpha: 0.07),
        highlightColor: Colors.white.withValues(alpha: 0.18),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                _shimmerBox(height: 50, radius: 30),
                const SizedBox(height: 40),
                _shimmerBox(height: 20, width: 200, radius: 10),
                const SizedBox(height: 12),
                _shimmerBox(height: 14, width: 140, radius: 8),
                const SizedBox(height: 32),
                _shimmerBox(height: 90, width: 90, radius: 45),
                const SizedBox(height: 16),
                _shimmerBox(height: 80, width: 180, radius: 10),
                const SizedBox(height: 8),
                _shimmerBox(height: 20, width: 120, radius: 8),
                const SizedBox(height: 32),
                _shimmerBox(height: 120, radius: 24),
                const SizedBox(height: 16),
                _shimmerBox(height: 100, radius: 24),
                const SizedBox(height: 16),
                Expanded(child: _shimmerBox(radius: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({double? height, double? width, double radius = 12}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Error Widget ───────────────────────────────────────────────────────────

class WeatherErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback? onOpenSettings;
  final String lang;

  const WeatherErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.onOpenSettings,
    this.lang = 'ar',
  });


  @override
  Widget build(BuildContext context) {
    final isAr = lang == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off_rounded,
                    color: Colors.redAccent, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                isAr ? 'حدث خطأ' : 'Something went wrong',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  isAr ? 'إعادة المحاولة' : 'Try Again',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              if (onOpenSettings != null) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings_rounded, color: Colors.white70),
                  label: Text(
                    isAr ? 'افتح الإعدادات' : 'Open Settings',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],

            ],
          ),
        ),
      ),
    );
  }
}
