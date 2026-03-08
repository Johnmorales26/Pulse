import 'package:flutter/material.dart';
import 'package:pulse/features/map/domain/model/place_photos.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key, required this.photos});

  final PlacePhotos photos;

  @override
  Widget build(BuildContext context) {
    if (photos.inside.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.inside.length,
        itemBuilder: (context, index) {
          final url = photos.inside[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SizedBox(
                width: 220,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    final expected = loadingProgress.expectedTotalBytes;
                    final value = expected != null
                        ? loadingProgress.cumulativeBytesLoaded / expected
                        : null;
                    return ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: CircularProgressIndicator(value: value),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
