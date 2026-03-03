# Pulse - Flutter Application

Pulse is a map-based Flutter application using Mapbox and Firebase, following Clean Architecture principles.

## Project Overview

- **Main Technologies:** Flutter, Dart, Firebase (Auth, Firestore, Storage), Mapbox Maps Flutter.
- **Architecture:** Clean Architecture organized by feature (Feature-driven structure).
- **State Management:** `flutter_bloc` with a custom naming convention (`Intent` instead of `Event`).
- **Dependency Injection:** `get_it` for manual service location (no code generation).
- **Navigation:** `go_router` with named routes.
- **UI/Theme:** Material 3 Dark Theme with Poppins (body) and Space Grotesk (display) fonts via Google Fonts.

## Core Commands

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Run linting
flutter analyze

# Build release
flutter build ios --release
flutter build apk --release
```

## Architecture & Directory Structure

The project follows a strict layer separation within each feature:

- `lib/core/`: Common logic, DI setup, theme, and global navigation.
- `lib/features/<feature_name>/`:
    - `domain/`: Business logic, pure Dart entities, repository interfaces, and use cases.
    - `data/`: Implementation of repositories, data sources (Firebase/Local), and data models (DTOs).
    - `presentation/`: BLoCs, UI widgets, and screens.

### State Management (BLoC)
Each BLoC consists of:
- `XBloc`: Logic to handle intents and emit states.
- `XIntent`: Replaces the traditional "Event" nomenclature.
- `XState`: Represents the UI state.

### Dependency Injection
All dependencies are manually wired in `lib/core/di/injection.dart` using the `sl` (Service Locator) global instance.

## Environment & Configuration

- **Mapbox:** Requires `assets/.env` with `ACCESS_TOKEN`.
- **Firebase:** Requires `lib/firebase_options.dart` and native configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).
- **Assets:** Icons are located in `assets/icons/locations/` and animations in `assets/animations/`.

## Development Guidelines

1. **Features:** When adding a new feature, follow the `domain` -> `data` -> `presentation` structure.
2. **DI:** Register new dependencies in `lib/core/di/injection.dart`.
3. **Naming:** Use `Intent` for BLoC events.
4. **Navigation:** Define new routes in `lib/core/navigation/router.dart` and constants in `router_names.dart`.
5. **UI:** Prefer using the predefined `MaterialTheme` and `textTheme` for consistency.
6. **Maps:** Marker icons are managed via `PlaceIcon` enum mapping Firestore types to asset paths.
