import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/core/presentation/widgets/blurred_bottom_sheet.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_intent.dart';
import 'package:pulse/features/map/presentation/map_state.dart';
import 'package:pulse/features/map/presentation/widgets/location_card.dart';
import 'package:pulse/features/map/presentation/widgets/map_filter_bottom_sheet.dart';
import 'package:pulse/features/map/presentation/widgets/map_search_bottom_sheet.dart';
import 'package:pulse/features/map/presentation/widgets/map_widget_loading.dart';
import 'package:pulse/features/map/presentation/widgets/map_widget_success.dart';
import 'package:pulse/l10n/app_localizations.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<MapBloc>()..add(FetchMapLocationsIntent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                BlocBuilder<MapBloc, MapState>(
                  buildWhen: (previous, current) {
                    if (previous is MapSuccess && current is MapSuccess) {
                      return previous.locations != current.locations;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is MapInitial || state is MapLoading) {
                      return const MapWidgetLoading();
                    } else if (state is MapError) {
                      return Center(
                        child: Text(l10n.mapLoadError(state.error)),
                      );
                    } else if (state is MapSuccess) {
                      return MapWidgetSuccess(
                        userLocation: state.userLocation,
                        locations: state.filteredLocations,
                        minZoom: 10.0,
                        maxZoom: 18.0,
                        onLocationSelected: (location) {
                          context.read<MapBloc>().add(
                            SelectMapLocationIntent(location),
                          );
                        },
                        onLongPress: (lat, lng) async {
                          final result = await context.pushNamed<bool>(
                            RouterNames.addPlace,
                            extra: (lat, lng),
                          );
                          if (result == true && context.mounted) {
                            context.read<MapBloc>().add(
                              FetchMapLocationsIntent(),
                            );
                          }
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: SafeArea(
                    minimum: const EdgeInsets.only(right: 16.0, bottom: 96.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          heroTag: 'locationFab',
                          tooltip: l10n.myLocationTooltip,
                          onPressed: () {
                            context.read<MapBloc>().add(
                              FetchUserLocationIntent(),
                            );
                          },
                          child: const Icon(Icons.my_location_outlined),
                        ),
                        const SizedBox(height: 12.0),
                        FloatingActionButton(
                          heroTag: 'searchFab',
                          tooltip: l10n.searchLabel,
                          onPressed: () => _showSearchBottomSheet(context),
                          child: const Icon(Icons.search),
                        ),
                        const SizedBox(height: 12.0),
                        BlocBuilder<MapBloc, MapState>(
                          builder: (context, state) {
                            final hasFilters =
                                state is MapSuccess &&
                                state.selectedCategories.isNotEmpty;

                            return FloatingActionButton.extended(
                              heroTag: 'filterFab',
                              onPressed: () => _showFilterBottomSheet(context),
                              icon: Icon(
                                hasFilters
                                    ? Icons.filter_list
                                    : Icons.filter_list_outlined,
                              ),
                              label: Text(l10n.filterLabel),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Tooltip(
                        message: l10n.profileTooltip,
                        child: InkWell(
                          onTap: () {
                            final uid = sl<GetCurrentUserIdUseCase>()();
                            if (uid != null) {
                              context.pushNamed(RouterNames.profile);
                            } else {
                              context.pushNamed(RouterNames.auth);
                            }
                          },
                          child: Image.asset(
                            'assets/icons/locations/ic_profile.png',
                            width: 36.0,
                            height: 36.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: BlocBuilder<MapBloc, MapState>(
                      builder: (context, state) {
                        if (state is MapSuccess &&
                            state.selectedLocation != null) {
                          return LocationCard(
                            location: state.selectedLocation!,
                            onClose: () {
                              context.read<MapBloc>().add(
                                DeselectMapLocationIntent(),
                              );
                            },
                            onTap: (location) {
                              context.pushNamed(
                                RouterNames.placeDetail,
                                pathParameters: {'id': location.id},
                                extra: location,
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final bloc = context.read<MapBloc>();
    final state = bloc.state;

    if (state is! MapSuccess) {
      return;
    }

    showBlurredModalBottomSheet(
      context: context,
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final successState = state is MapSuccess
                ? state
                : MapSuccess(locations: const []);

            return MapFilterBottomSheet(
              locations: successState.locations,
              selectedCategories: successState.selectedCategories,
              onCategoryToggled: (category) {
                context.read<MapBloc>().add(ToggleMapFilterIntent(category));
              },
            );
          },
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    final bloc = context.read<MapBloc>();
    final state = bloc.state;

    if (state is! MapSuccess) {
      return;
    }

    showBlurredModalBottomSheet(
      context: context,
      child: BlocProvider.value(
        value: bloc,
        child: const MapSearchBottomSheet(),
      ),
    );
  }
}
