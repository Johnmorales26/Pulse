import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/utils/distance.dart';

void main() {
  group('haversineDistance', () {
    test('returns 0 for identical coordinates', () {
      final distance = haversineDistance(0, 0, 0, 0);
      expect(distance, 0.0);
    });

    test('returns 0 for identical coordinates at non-zero lat/lng', () {
      final distance = haversineDistance(-34.6037, -58.3816, -34.6037, -58.3816);
      expect(distance, 0.0);
    });

    test('computes ~1 km distance within 0.5% accuracy', () {
      // Two points approximately 1 km apart along the same meridian.
      // 1° latitude ≈ 111.32 km, so 0.009° ≈ 1.001 km ≈ 1001 m
      final distance = haversineDistance(-34.6037, -58.3816, -34.6127, -58.3816);
      const expectedMeters = 1001.0;
      final error = (distance - expectedMeters).abs() / expectedMeters;
      expect(error, lessThan(0.005)); // within 0.5%
    });

    test('computes Buenos Aires to New York within 0.5% accuracy', () {
      // Obelisco BA: -34.6037, -58.3816
      // Times Square NY: 40.7580, -73.9855
      // Expected: ~8,536 km
      final distance = haversineDistance(-34.6037, -58.3816, 40.7580, -73.9855);
      const expectedMeters = 8536000.0;
      final error = (distance - expectedMeters).abs() / expectedMeters;
      expect(error, lessThan(0.005)); // within 0.5%
    });

    test('is symmetric (A→B equals B→A)', () {
      const lat1 = 34.0522, lng1 = -118.2437; // Los Angeles
      const lat2 = 51.5074, lng2 = -0.1278; // London
      final dAB = haversineDistance(lat1, lng1, lat2, lng2);
      final dBA = haversineDistance(lat2, lng2, lat1, lng1);
      expect(dAB, closeTo(dBA, 0.001));
    });
  });

  group('formatDistance', () {
    test('formats 0 meters as "0 m"', () {
      expect(formatDistance(0), '0 m');
    });

    test('formats 450 meters as "450 m"', () {
      expect(formatDistance(450), '450 m');
    });

    test('formats 999 meters as "999 m"', () {
      expect(formatDistance(999), '999 m');
    });

    test('formats 1000 meters as "1.0 km"', () {
      expect(formatDistance(1000), '1.0 km');
    });

    test('formats 2500 meters as "2.5 km"', () {
      expect(formatDistance(2500), '2.5 km');
    });

    test('formats 1500 meters as "1.5 km"', () {
      expect(formatDistance(1500), '1.5 km');
    });

    test('formats 10000 meters as "10.0 km"', () {
      expect(formatDistance(10000), '10.0 km');
    });

    test('formats 10499 meters as "10.5 km" (rounds to one decimal)', () {
      // 10.499 rounds to "10.5 km" with toStringAsFixed(1)
      expect(formatDistance(10499), '10.5 km');
    });
  });
}
