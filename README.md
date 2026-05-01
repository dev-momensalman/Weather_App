# <p align="center"> 🌤️ Weatherly | Premium Weather Experience </p>

<p align="center">
  <img src="https://github.com/dev-momensalman/Weather_App/blob/main/assets/pngtree-rainy-cloud-icon-with-blue-raindrops-for-weather-forecasts-and-illustrations-png-image_20128308.png" width="350" style="border-radius: 20px;" alt="Weatherly Main Banner">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white">
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/Clean%20Architecture-Solid-%234CAF50?style=for-the-badge">
  <img src="https://img.shields.io/badge/BLoC-State%20Management-%23546E7A?style=for-the-badge">
</p>

---

## 📖 Overview
**Weatherly** is a premium weather tracking application built with **Flutter**. It combines high-accuracy meteorological data with a modern **Glassmorphism** UI. The project is engineered with scalability in mind, using industry-standard design patterns to provide a seamless user experience.

> **Core Focus:** Clean Architecture, Predictable State Management, and High-Fidelity UI.

---

## 📱 User Interface (User Journey)

<p align="center">
  <img src="https://github.com/dev-momensalman/Weather_App/blob/main/assets/Screenshot_20260224_062957.png?raw=true" width="160" alt="Welcome Screen" />
  <img src="https://github.com/dev-momensalman/Weather_App/blob/main/assets/Screenshot_20260224_063041.png?raw=true" width="160" alt="Permission Request" />
  <img src="https://github.com/dev-momensalman/Weather_App/blob/main/assets/Screenshot_20260224_063203.png?raw=true" width="160" alt="Main Weather Dashboard" />
  <img src="https://github.com/dev-momensalman/Weather_App/blob/main/assets/Screenshot_20260224_063211.png?raw=true" width="160" alt="Detailed Forecast" />
</p>

<p align="center">
  <i>1. Welcome Screen &nbsp;&nbsp;&nbsp; 2. Location Permission &nbsp;&nbsp;&nbsp; 3. Current Weather &nbsp;&nbsp;&nbsp; 4. Weather Details</i>
</p>

---

## 🚀 Key Features
* 📍 **Smart Geolocation:** Instant local weather detection using `geolocator`.
* 🔍 **Global Search:** Check weather for any city worldwide.
* 📊 **Detailed Forecasts:** Comprehensive hourly and 3-day breakdowns.
* 🌐 **Localization:** Full support for **Arabic** and **English**.
* 💎 **Glassmorphic UI:** Premium blur effects and smooth `shimmer` animations.

---

## 🛠️ Tech Stack & Architecture
* **State Management:** `flutter_bloc` for predictable state.
* **Architecture:** Clean Architecture (Data, Domain, Presentation).
* **Networking:** `http` for REST API communication.
* **Visuals:** `google_fonts` (Outfit) & dynamic weather-based themes.

---

## ⚙️ Setup & Installation

### 1. Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* OpenWeatherMap [API Key](https://openweathermap.org/api)

### 2. Installation
```bash
# Clone the repository
git clone [https://github.com/dev-momensalman/Weather_App.git](https://github.com/dev-momensalman/Weather_App.git)

# Install dependencies
flutter pub get

# Run the app
flutter run
