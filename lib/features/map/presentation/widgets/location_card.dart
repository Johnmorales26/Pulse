import 'package:flutter/material.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    required this.onClose,
    required this.onTap,
  });

  final PlaceLocation location;
  final VoidCallback onClose;
  final Function(PlaceLocation) onTap;

  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    if (location.photos.outside.isNotEmpty) {
      imageUrl = location.photos.outside.first;
    } else if (location.photos.inside.isNotEmpty) {
      imageUrl = location.photos.inside.first;
    }

    return GestureDetector(
      onTap: () => onTap(location),
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: imageUrl != null
                    ? Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/icons/locations/ic_location_user.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      location.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: onClose, icon: Icon(Icons.close)),
            ],
          ),
        ),
      )
    );
  }
}
