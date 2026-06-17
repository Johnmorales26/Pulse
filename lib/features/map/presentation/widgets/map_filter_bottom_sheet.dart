import 'package:flutter/material.dart';
import 'package:pulse/features/map/domain/model/place_icon.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Maps raw category keys to Material icons.
IconData _mapCategoryToIcon(String rawKey) {
  switch (rawKey) {
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

/// Maps raw category keys to user-friendly display text.
String _mapCategoryToDisplayName(String rawKey, AppLocalizations l10n) {
  // Try to find matching PlaceIcon
  final icon = PlaceIcon.fromId(rawKey);
  if (icon != PlaceIcon.unknown) {
    return icon.label;
  }

  // Fallback: clean raw ID
  if (rawKey.startsWith('id_')) {
    final cleaned = rawKey.substring(3).replaceAll('_', ' ');
    return cleaned.isEmpty
        ? 'Unknown'
        : cleaned[0].toUpperCase() + cleaned.substring(1);
  }
  return rawKey;
}

/// Filter bottom sheet with:
/// - l10n support
/// - Vertical list of filter options
/// - Icon + translated text per item
/// - Clear visual selection feedback
class MapFilterBottomSheet extends StatelessWidget {
  final List<PlaceLocation> locations;
  final Set<String> selectedCategories;
  final ValueChanged<String> onCategoryToggled;

  const MapFilterBottomSheet({
    super.key,
    required this.locations,
    required this.selectedCategories,
    required this.onCategoryToggled,
  });

  /// Extract unique categories from locations.
  Set<String> get availableCategories {
    return locations.map((l) => l.type).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = availableCategories.toList()..sort();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and clear button
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.categoryLabel,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (selectedCategories.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      // Clear all filters
                      for (final category in selectedCategories) {
                        onCategoryToggled(category);
                      }
                    },
                    icon: const Icon(Icons.clear_all, size: 20),
                    label: Text(l10n.categoryLabel),
                  ),
              ],
            ),
          ),

          // Vertical list of filter options
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const Divider(height: 1.0),
              itemBuilder: (context, index) {
                final rawKey = categories[index];
                final isSelected = selectedCategories.contains(rawKey);
                final displayName = _mapCategoryToDisplayName(rawKey, l10n);
                final icon = _mapCategoryToIcon(rawKey);

                return _FilterTile(
                  displayName: displayName,
                  icon: icon,
                  isSelected: isSelected,
                  onTap: () => onCategoryToggled(rawKey),
                );
              },
            ),
          ),

          // Bottom safe area padding
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String displayName;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTile({
    required this.displayName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      leading: Icon(
        icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        displayName,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
      ),
      onTap: onTap,
    );
  }
}
