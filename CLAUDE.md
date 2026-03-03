# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run on a device/simulator
flutter run

# Analyze code (linting)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Get dependencies
flutter pub get

# Build for release
flutter build ios --release
flutter build apk --release
```

## Environment Setup

The app requires `assets/.env` with:
```
ACCESS_TOKEN=<mapbox_access_token>
```

Firebase is configured via `lib/firebase_options.dart` and `android/app/google-services.json`. These files must exist for the app to build.

## Architecture

This is a Flutter app using **clean architecture** organized by feature. The only feature currently developed is `map`, with `place_detail` started.

### Layer structure (per feature)

```
lib/features/<feature>/
  domain/
    model/          # Pure Dart data classes (no framework deps)
    repository/     # Abstract interfaces
    usecases/       # Single-responsibility callable classes
  data/
    datasource/     # Firebase/device data fetchers
    repository/     # Implementations of domain interfaces
    constants.dart  # Firestore field/collection name constants
  presentation/
    map_bloc.dart   # BLoC: events (Intents) → states
    map_intent.dart # Event classes
    map_state.dart  # State classes
    map_screen.dart # Screen widget (injects BLoC via BlocProvider)
    widgets/        # Sub-widgets
```

### Dependency injection

All dependencies are registered manually in `lib/core/di/injection.dart` using **GetIt** (`sl` global instance). No code generation — dependencies are wired by hand as lazy singletons or factories. `MapBloc` is registered as a factory (new instance per screen).

### State management

**flutter_bloc** is used with `Intent`/`State` naming (rather than the conventional `Event`/`State`). BLoCs are provided at the screen level via `BlocProvider(create: (ctx) => sl<XBloc>()..add(InitialIntent()))`. Use `BlocBuilder` for rebuilding UI and `BlocListener` for side effects (e.g., map camera animation).

### Navigation

**go_router** with named routes defined in `lib/core/navigation/router.dart`. Route names are constants in `lib/core/navigation/router_names.dart`. Navigate with `context.pushNamed('routeName', pathParameters: {...}, extra: object)`. The `extra` param passes full model objects between routes.

### Map

**Mapbox Maps Flutter** (`MapboxStyles.DARK` style). Custom PNG icons in `assets/icons/locations/` are loaded with `rootBundle` and added as `PointAnnotation` markers. The `PlaceIcon` enum maps Firestore `type` string IDs to asset paths. User location uses `geolocator` package for device GPS.

### Firebase / Firestore

Collection: `places`. Each document maps to `PlaceLocation`. Nested fields: `location` (lat/lng), `photos` (inside/outside arrays), `rating` (stars/totalReviews). Field name constants are in `lib/features/map/data/constants.dart`.

### Theme

Material 3 dark theme by default (`theme.dark()`). `MaterialTheme` class in `lib/core/theme/colors.dart` defines all color schemes. Typography uses **Poppins** (body) and **Space Grotesk** (display) via `google_fonts`.
