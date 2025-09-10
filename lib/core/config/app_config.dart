import 'dart:convert';
import 'package:flutter/services.dart';

/// Configuration constants for the application
class AppConfig {
  static String? _googleMapsApiKey;

  /// Initialize configuration from config.json
  static Future<void> initialize() async {
    try {
      final configString = await rootBundle.loadString('config.json');
      final config = json.decode(configString);
      _googleMapsApiKey = config['GOOGLE_MAPS_API_KEY'];
    } catch (e) {
      print('Failed to load config.json: $e');
      _googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY_HERE";
    }
  }

  // API Keys
  static String get googleMapsApiKey =>
      _googleMapsApiKey ?? "YOUR_GOOGLE_MAPS_API_KEY_HERE";

  // API URLs
  static const String googleMapsBaseUrl =
      "https://maps.googleapis.com/maps/api";
  static const String directionsApiUrl = "$googleMapsBaseUrl/directions/json";
  static const String geocodingApiUrl = "$googleMapsBaseUrl/geocode/json";

  // Default map settings
  static const double defaultZoom = 12.0;
  static const double defaultLatitude = 23.8103; // Dhaka, Bangladesh
  static const double defaultLongitude = 90.4125;

  // Route settings
  static const int routeWidth = 5;
  static const String routeMode = "driving";
}
