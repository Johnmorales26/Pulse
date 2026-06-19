import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/core/utils/distance.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_intent.dart';
import 'package:pulse/features/map/presentation/map_state.dart';
import 'package:pulse/features/map/presentation/widgets/place_type_icon.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Modal search bottom sheet for finding places by name.
///
/// Features:
/// - [DarkTextField] with 300 ms debounce
/// - Real-time filtering via [SearchPlacesIntent] / [ClearSearchIntent]
/// - Distance-sorted results (or alphabetical fallback)
/// - Tap to navigate to [RouterNames.placeDetail]
class MapSearchBottomSheet extends StatefulWidget {
  const MapSearchBottomSheet({super.key});

  @override
  State<MapSearchBottomSheet> createState() => _MapSearchBottomSheetState();
}

class _MapSearchBottomSheetState extends State<MapSearchBottomSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final query = _controller.text;
      if (query.isEmpty) {
        context.read<MapBloc>().add(ClearSearchIntent());
      } else {
        context.read<MapBloc>().add(SearchPlacesIntent(query));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field with dynamic clear button
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return DarkTextField(
                hint: l10n.searchHint,
                label: l10n.searchLabel,
                controller: _controller,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<MapBloc>().add(ClearSearchIntent());
                        },
                      )
                    : null,
              );
            },
          ),
          const SizedBox(height: 16.0),

          // Results
          Flexible(
            child: BlocBuilder<MapBloc, MapState>(
              builder: (context, state) {
                if (state is! MapSuccess) {
                  return const SizedBox.shrink();
                }

                final results = state.searchedAndSortedLocations;

                // Empty results with an active query → show "no results" message
                if (results.isEmpty && state.searchQuery.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        l10n.noResults,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }

                // No results at all (empty query, no places)
                if (results.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: results.length,
                  separatorBuilder: (_, _) => const Divider(height: 1.0),
                  itemBuilder: (context, index) {
                    final place = results[index];
                    final distanceText = _distanceForPlace(state, place, l10n);

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                      leading: Icon(
                        PlaceTypeIcon.forType(place.type),
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                        semanticLabel: PlaceTypeIcon.labelForType(place.type),
                      ),
                      title: Text(
                        place.name,
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: distanceText != null
                          ? Text(
                              distanceText,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushNamed(
                          RouterNames.placeDetail,
                          pathParameters: {'id': place.id},
                          extra: place,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  /// Returns the formatted distance string for [place] relative to the user
  /// location in [state], or `null` when the user location is unavailable.
  String? _distanceForPlace(
    MapSuccess state,
    PlaceLocation place,
    AppLocalizations l10n,
  ) {
    if (state.userLocation == null) return null;
    final meters = haversineDistance(
      state.userLocation!.latitude,
      state.userLocation!.longitude,
      place.latitude,
      place.longitude,
    );
    return l10n.distanceFormat(formatDistance(meters));
  }
}
