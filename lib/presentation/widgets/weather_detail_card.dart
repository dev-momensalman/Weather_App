import 'dart:ui';
import 'package:flutter/material.dart';

class WeatherDetailCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const WeatherDetailCard({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.white.withValues(alpha: 0.1),

          child: Column(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 28),
              SizedBox(height: 8),
              Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}