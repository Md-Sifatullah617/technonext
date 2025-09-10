# TechnoNext - Car Route Application

> **Flutter Clean Architecture Assessment Project**  
> A professional car routing application demonstrating Clean Architecture principles with real Google Maps integration.

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5.4-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Project Overview

This Flutter application allows users to select two points on an interactive map and displays the **optimal car route** between them using **Google Directions API**. Built with **Clean Architecture** principles and **Provider** state management for a production-ready codebase.

### 📱 Demo & APK Download

- **Live Demo**: [Download APK](./dist/app-release.apk)
- **GitHub Repository**: [technonext](https://github.com/Md-Sifatullah617/technonext)

## ✅ Assessment Requirements Fulfilled

### Core Features

- ✅ **Interactive Map Interface**: Pan, zoom, and tap to select points
- ✅ **Point-and-Select Functionality**: Mark origin and destination locations
- ✅ **Real-time Route Display**: Instant route rendering with Google Maps polylines
- ✅ **Optimal Route Calculation**: Uses Google Directions API for real shortest routes
- ✅ **Route Information**: Display distance and estimated travel time

### Bonus Features

- ✅ **Clean Architecture**: Domain, Data, and Presentation layers
- ✅ **State Management**: Provider pattern with dependency injection
- ✅ **Production-Level Code**: Error handling, configuration management
- ✅ **Real Google Maps Integration**: Actual route paths, not straight lines
- ✅ **Responsive Design**: Adaptive UI for different screen sizes

## 🏗️ Architecture

This project follows **Clean Architecture** principles with simplified dependency injection:

```
lib/
├── core/
│   ├── config/                 # Configuration management
│   ├── di/                     # Centralized dependency injection
│   └── utils/                  # Shared utilities
├── features/
│   ├── route/                  # Main routing feature
│   │   ├── data/              # API integration & repositories
│   │   ├── domain/            # Business logic & entities
│   │   └── presentation/      # UI components & state management
│   └── splash/                # App initialization
└── config.json               # API keys configuration
```

### Key Architectural Decisions

- **Centralized DI**: Single service locator for maintainability
- **Feature-based Organization**: Clear separation of concerns
- **Repository Pattern**: Abstracted data access
- **Use Case Pattern**: Isolated business logic

## 🚀 Getting Started

### Prerequisites

- Flutter 3.24.5 or higher
- Dart 3.5.4 or higher
- Android Studio / VS Code
- Google Maps API key

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Md-Sifatullah617/technonext.git
   cd technonext
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure API key:**

   ```json
   // config.json (already configured)
   {
     "GOOGLE_MAPS_API_KEY": "YOUR_API_KEY_HERE"
   }
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

### Building APK

```bash
# Debug APK
flutter build apk

# Release APK (Recommended)
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

## 📱 How to Use

1. **Launch the app** → Grant location permissions when prompted
2. **Tap on map** → Select origin point (green "START" marker)
3. **Tap again** → Select destination point (red "END" marker)
4. **View route** → Real Google route appears automatically with distance/time
5. **Map controls** → Use bottom sheet to change map type (Normal, Satellite, Hybrid, Terrain)
6. **Reset** → Tap anywhere to clear and start over

## 🔧 Technical Stack

| Technology      | Purpose              | Version |
| --------------- | -------------------- | ------- |
| **Flutter**     | Mobile framework     | 3.24.5  |
| **Provider**    | State management     | ^6.1.2  |
| **Google Maps** | Map integration      | ^2.9.0  |
| **GetIt**       | Dependency injection | ^8.0.2  |
| **Geolocator**  | Location services    | ^13.0.1 |
| **HTTP**        | API communication    | ^1.2.2  |

### API Integrations

- **Google Maps SDK**: Interactive map display
- **Google Directions API**: Real route calculation
- **Google Geocoding API**: Address resolution

## 🎨 Features Showcase

### Map Interactions

- **Custom Markers**: Branded START/END markers with custom designs
- **Real-time Routing**: Instant route calculation and display
- **Multiple Map Types**: Normal, Satellite, Hybrid, Terrain views
- **Smooth Animations**: Fluid map interactions and transitions

### State Management

- **Provider Pattern**: Reactive UI updates
- **Error Handling**: Graceful failure recovery
- **Loading States**: Clear user feedback
- **Route Persistence**: Maintains state during navigation

## 📊 Performance & Quality

### Code Quality

- **Clean Architecture**: Maintainable and testable code structure
- **SOLID Principles**: Well-structured object-oriented design
- **Error Boundaries**: Comprehensive error handling
- **Documentation**: Inline code documentation

### Performance Optimizations

- **Efficient Rendering**: Optimized map rendering and polyline drawing
- **Memory Management**: Proper resource cleanup
- **API Optimization**: Cached responses where appropriate

## 🔮 Production Considerations

- **API Rate Limiting**: Built-in error handling for API limits
- **Offline Support**: Graceful degradation when network unavailable
- **Security**: API keys properly managed
- **Scalability**: Architecture supports easy feature additions

## 🧪 Testing Strategy

The project structure supports easy testing implementation:

```bash
# Run tests (when implemented)
flutter test

# Test coverage
flutter test --coverage
```

## 📁 Project Structure Details

<details>
<summary>Click to expand detailed file structure</summary>

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # Configuration loader
│   ├── di/
│   │   └── service_locator.dart     # Dependency injection setup
│   └── utils/
│       └── constants.dart           # App constants
├── features/
│   ├── route/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── route_local_datasource.dart
│   │   │   │   └── route_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── location_point_model.dart
│   │   │   │   └── route_info_model.dart
│   │   │   └── repositories/
│   │   │       └── route_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── location_point.dart
│   │   │   │   └── route_info.dart
│   │   │   ├── repositories/
│   │   │   │   └── route_repository.dart
│   │   │   └── usecases/
│   │   │       ├── calculate_route_usecase.dart
│   │   │       └── get_address_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── route_page.dart
│   │       ├── providers/
│   │       │   └── route_provider.dart
│   │       └── widgets/
│   │           ├── map_widget.dart
│   │           ├── route_info_widget.dart
│   │           ├── map_type_bottom_sheet.dart
│   │           └── widget_to_map_icon.dart
│   └── splash/
│       └── presentation/
│           ├── pages/
│           │   └── splash_page.dart
│           └── providers/
│               └── splash_provider.dart
├── gen/
│   ├── assets.gen.dart              # Generated asset references
│   └── colors.gen.dart              # Generated color constants
├── main.dart                        # App entry point
├── config.json                      # API configuration
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

</details>

## 🏆 Assessment Checklist

- ✅ **Interactive map interface with pan/zoom functionality**
- ✅ **Point-and-select functionality for origin/destination**
- ✅ **Real-time route display with Google Directions API**
- ✅ **Optimal car routing algorithm implementation**
- ✅ **Clean Architecture with separation of concerns**
- ✅ **Provider state management pattern**
- ✅ **Production-level code quality and documentation**
- ✅ **Error handling and edge case management**
- ✅ **Responsive UI design**
- ✅ **Real Google Maps integration (not mock)**

## 🤝 Contributing

This is an assessment project, but suggestions and improvements are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

**Developer**: Md. Sifatullah  
**Email**: sifatullah617@gmail.com  
**GitHub**: [@Md-Sifatullah617](https://github.com/Md-Sifatullah617)  
**Project**: TechnoNext Flutter Assessment

---

**Built with ❤️ for TechnoNext Coding Assessment**
