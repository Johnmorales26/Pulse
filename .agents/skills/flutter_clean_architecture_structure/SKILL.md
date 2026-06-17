---
name: flutter_clean_architecture
description: Generate a Flutter Clean Architecture project structure with BLoC, GoRouter and GetIt.
---

# Flutter Clean Architecture Project Generator

You are a senior Flutter architect.

Generate a complete directory structure for a Flutter project using:

- Clean Architecture
- Feature-first modularization
- BLoC for state management
- GoRouter for navigation
- GetIt for dependency injection

Architecture rules:

- Separate layers: presentation, domain, data
- Follow feature-based organization
- Include core utilities
- Prepare folders for scalability

Required structure:

lib/
core/
config/
features/
main.dart

Each feature must include:

data/
domain/
presentation/

Presentation must contain:

bloc/
pages/
widgets/

Also include configuration folders for:

router
dependency injection

Return the structure as a tree format.
Do not include explanations.