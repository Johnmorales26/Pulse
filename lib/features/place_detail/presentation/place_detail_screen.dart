import 'package:flutter/material.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.location});

  final PlaceLocation location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(location.name));
  }
}
