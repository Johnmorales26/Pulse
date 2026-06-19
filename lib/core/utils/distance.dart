import 'dart:math';

/// Calculates the great-circle distance between two lat/lng points
/// using the haversine formula.
///
/// Returns distance in meters.
double haversineDistance(
  double lat1,
  double lng1,
  double lat2,
  double lng2,
) {
  const earthRadiusMeters = 6371000.0;
  final dLat = _degToRad(lat2 - lat1);
  final dLng = _degToRad(lng2 - lng1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degToRad(lat1)) *
          cos(_degToRad(lat2)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadiusMeters * c;
}

/// Formats a distance in meters for display.
///
/// - Less than 1000 m: `"450 m"`
/// - 1000 m and above: `"2.5 km"` (one decimal)
String formatDistance(double meters) {
  if (meters < 1000) {
    return '${meters.round()} m';
  }
  final km = meters / 1000;
  return '${km.toStringAsFixed(1)} km';
}

double _degToRad(double deg) => deg * (pi / 180.0);
