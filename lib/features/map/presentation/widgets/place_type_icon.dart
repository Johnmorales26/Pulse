import 'package:flutter/material.dart';

/// Centralized mapping from place type keys to Material icons.
///
/// Used by [MapSearchBottomSheet], [MapFilterBottomSheet], and any other
/// widget that needs to display a visual indicator for place types.
///
/// Fallback: [Icons.place_outlined] for unknown types.
class PlaceTypeIcon {
  PlaceTypeIcon._();

  /// Returns the Material icon for the given place type key.
  ///
  /// Keys are expected to be the raw category IDs (e.g., 'id_cinema', 'id_gym').
  /// Falls back to [Icons.place_outlined] for unknown or null types.
  static IconData forType(String? type) {
    if (type == null || type.isEmpty) return Icons.place_outlined;

    switch (type) {
      case 'id_cinema':
        return Icons.movie_outlined;
      case 'id_gym':
        return Icons.fitness_center_outlined;
      case 'id_park':
        return Icons.park_outlined;
      case 'id_bar':
        return Icons.local_bar_outlined;
      case 'id_club':
        return Icons.nightlife_outlined;
      case 'id_beach':
        return Icons.beach_access_outlined;
      case 'id_hotel':
        return Icons.hotel_outlined;
      case 'id_restroom':
        return Icons.wc_outlined;
      case 'id_sex_shop':
        return Icons.shop_outlined;
      case 'id_steam_bath':
        return Icons.spa_outlined;
      case 'id_clock':
        return Icons.schedule_outlined;
      case 'id_cyber':
        return Icons.computer_outlined;
      case 'id_nudist_beach':
        return Icons.beach_access_outlined;
      case 'id_incognito':
        return Icons.visibility_off_outlined;
      case 'id_notification':
        return Icons.notifications_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  /// Accessible label for the given place type key.
  /// Used for screen readers and accessibility tools.
  static String? labelForType(String? type) {
    if (type == null || type.isEmpty) return null;

    switch (type) {
      case 'id_cinema':
        return 'Cinema';
      case 'id_gym':
        return 'Gym';
      case 'id_park':
        return 'Park';
      case 'id_bar':
        return 'Bar';
      case 'id_club':
        return 'Nightclub';
      case 'id_beach':
        return 'Beach';
      case 'id_hotel':
        return 'Hotel';
      case 'id_restroom':
        return 'Restroom';
      case 'id_sex_shop':
        return 'Sex shop';
      case 'id_steam_bath':
        return 'Steam bath';
      case 'id_clock':
        return 'Clock';
      case 'id_cyber':
        return 'Cyber';
      case 'id_nudist_beach':
        return 'Nudist beach';
      case 'id_incognito':
        return 'Incognito';
      case 'id_notification':
        return 'Notification';
      default:
        return null;
    }
  }
}