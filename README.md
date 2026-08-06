# Taqsi Weather App

Taqsi is a Flutter weather app with Arabic and English support, location-based forecasts, city search, and a polished dark interface. It uses WeatherAPI data to display current conditions, hourly weather, and multi-day forecasts in a clear mobile experience.

## Overview

The project is structured around data providers, repositories, Cubits, and presentation widgets. It demonstrates practical Flutter architecture with API integration, geolocation permissions, localization, state management, and dynamic weather UI.

## Features

- Current weather by device location
- City search with remote suggestions
- Arabic and English language switching
- 7-day forecast from WeatherAPI
- Hourly forecast for the current day
- Weather details including humidity, wind speed, UV, visibility, cloud coverage, and feels-like temperature
- Location permission handling with Arabic and English error messages
- Fallback to last known location when direct GPS lookup times out
- Dynamic weather visuals and dark Material 3 styling
- Shimmer and polished loading states

## Tech Stack

- Flutter
- Dart
- Flutter Bloc / Cubit
- WeatherAPI forecast and search endpoints
- `geolocator` for device location
- `http` for API requests
- `google_fonts` with Cairo font
- `intl` and Flutter localization delegates
- `shimmer` for loading UI

## Project Structure

```text
lib/
├── main.dart                                  # App startup, providers, localization, theme
├── data/
│   ├── data_providers/
│   │   └── weather_provider.dart             # WeatherAPI HTTP requests
│   ├── models/
│   │   └── weather_model.dart                # Current, daily, and hourly weather models
│   └── repositories/
│       └── weather_repository.dart           # Location flow, parsing, and search handling
├── logic/
│   ├── language_cubit/                       # App language state
│   ├── search_cubit/                         # City search state
│   └── weather_cubit/                        # Weather loading state
└── presentation/
    ├── screens/
    │   └── home_screen.dart                  # Main weather dashboard
    └── widgets/                              # Cards, themes, states, and weather UI pieces
```

## Main Flow

1. `main.dart` registers the weather repository and Cubits using `MultiBlocProvider`.
2. `LanguageCubit` controls the current locale and switches the app between Arabic and English.
3. `WeatherCubit` requests weather data through `WeatherRepository`.
4. If no city is selected, the repository requests the current GPS position through `geolocator`.
5. `WeatherProvider` calls WeatherAPI and returns raw JSON.
6. `WeatherModel` converts the response into current, daily, and hourly forecast objects.
7. The presentation layer displays the result through reusable weather widgets and state-specific UI.

## Getting Started

### Requirements

- Flutter SDK 3.9.2 or newer
- Dart SDK included with Flutter
- Android Studio, VS Code, or another Flutter-compatible IDE
- WeatherAPI key
- Location permissions configured for Android/iOS

### Run Locally

```bash
git clone https://github.com/dev-momensalman/Weather_App.git
cd Weather_App
flutter pub get
flutter run
```

## API Configuration

The API request logic is currently inside:

```text
lib/data/data_providers/weather_provider.dart
```

For production or public releases, move the API key out of source code and load it from an environment/config file that is not committed to the repository.

## Notes for Reviewers

- The app title changes based on the selected language: Arabic uses `طقسي - تطبيق الطقس`, English uses `Taqsi - Weather App`.
- The repository layer contains the main location and error-handling logic.
- The model file shows exactly how WeatherAPI JSON is converted into app data.
- The UI is split between `home_screen.dart` and reusable widgets under `lib/presentation/widgets`.
- A real device gives the best review experience because GPS and location permissions are part of the main flow.

## Future Improvements

- Move the WeatherAPI key to a secure configuration layer
- Cache the latest successful forecast for offline display
- Add saved favorite cities
- Add unit tests for model parsing and repository errors
- Add widget tests for loading, success, and error states
