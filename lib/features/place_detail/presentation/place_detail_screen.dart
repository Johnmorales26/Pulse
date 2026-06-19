import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/presentation/utils/app_toast.dart';
import 'package:pulse/core/presentation/widgets/blurred_bottom_sheet.dart';
import 'package:pulse/core/utils/launch_map_use_case.dart';
import 'package:pulse/core/utils/date_time_extensions.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_bloc.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_intent.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_state.dart';
import 'package:pulse/features/place_detail/presentation/widgets/image_carousel.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';
import 'package:pulse/l10n/app_localizations.dart';

class PlaceDetailScreen extends StatefulWidget {
  const PlaceDetailScreen({super.key, required this.placeId});

  final String placeId;

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PlaceDetailBloc>().add(
      ObservePlaceDetailIntent(widget.placeId),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _onNavigateTap(PlaceLocation place) async {
    try {
      final maps = await sl<LaunchMapUseCase>()();
      if (!mounted) return;
      showBlurredModalBottomSheet(
        context: context,
        child: _MapPickerSheet(
          maps: maps,
          latitude: place.latitude,
          longitude: place.longitude,
          placeName: place.name,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppToast.info(context, AppLocalizations.of(context)!.noMapsInstalled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
          buildWhen: (prev, curr) => prev.place?.name != curr.place?.name,
          builder: (context, state) {
            if (state.place != null) return Text(state.place!.name);
            return const SizedBox.shrink();
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PlaceDetailBloc, PlaceDetailState>(
          listenWhen: (previous, current) =>
              (previous.status == PlaceDetailStatus.loading &&
                  previous.place != null &&
                  current.status != PlaceDetailStatus.loading) ||
              current.status == PlaceDetailStatus.unauthenticated,
          listener: (context, state) {
            if (state.status == PlaceDetailStatus.unauthenticated) {
              AppToast.info(context, state.errorMessage ?? l10n.signInRequired);
              return;
            }
            if (state.status == PlaceDetailStatus.success) {
              _commentController.clear();
              AppToast.info(context, l10n.commentAdded);
            }
            if (state.status == PlaceDetailStatus.error) {
              AppToast.error(context, state.errorMessage ?? l10n.commentError);
            }
          },
          builder: (context, state) {
            if (state.place == null) {
              if (state.status == PlaceDetailStatus.error) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ?? l10n.loadPlaceError,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<PlaceDetailBloc>().add(
                            ObservePlaceDetailIntent(widget.placeId),
                          ),
                          child: Text(l10n.retryButton),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }

            final PlaceLocation place = state.place!;
            final bool isSubmittingComment =
                state.status == PlaceDetailStatus.loading;

            return _PlaceDetailBody(
              place: place,
              comments: state.comments,
              commentController: _commentController,
              isSubmittingComment: isSubmittingComment,
              placeId: widget.placeId,
              onNavigateTap: () => _onNavigateTap(place),
            );
          },
        ),
      ),
    );
  }
}

class _PlaceDetailBody extends StatelessWidget {
  const _PlaceDetailBody({
    required this.place,
    required this.comments,
    required this.commentController,
    required this.isSubmittingComment,
    required this.placeId,
    required this.onNavigateTap,
  });

  final PlaceLocation place;
  final List<PlaceComments> comments;
  final TextEditingController commentController;
  final bool isSubmittingComment;
  final String placeId;
  final VoidCallback onNavigateTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageCarousel(photos: place.photos),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<PlaceDetailBloc, PlaceDetailState>(
                  buildWhen: (prev, curr) => prev.isSaved != curr.isSaved,
                  builder: (context, state) {
                    return OutlinedButton.icon(
                      onPressed: () => context.read<PlaceDetailBloc>().add(
                        ToggleSavePlaceIntent(placeId),
                      ),
                      icon: Icon(
                        state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      label: Text(
                        state.isSaved ? l10n.savedButton : l10n.saveButton,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onNavigateTap,
                  icon: const Icon(Icons.directions),
                  label: Text(l10n.navigateButton),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    leading: Image.asset(
                      'assets/icons/locations/ic_location_user.png',
                    ),
                    title: Text(comment.comment),
                    subtitle: Text(
                      comment.createdAt.toDisplayFormat(
                        l10n.commentDateFormat,
                        locale,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DarkTextField(
                  label: null,
                  hint: l10n.commentHint,
                  controller: commentController,
                  suffixIcon: isSubmittingComment
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              context.read<PlaceDetailBloc>().add(
                                AddCommentIntent(
                                  placeId,
                                  commentController.text,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPickerSheet extends StatelessWidget {
  const _MapPickerSheet({
    required this.maps,
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });

  final List<AvailableMap> maps;
  final double latitude;
  final double longitude;
  final String placeName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.openWith,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            ...maps.map(
              (map) => ListTile(
                leading: Image(
                  image: AssetImage(map.icon, package: 'map_launcher'),
                  width: 30,
                  height: 30,
                  errorBuilder: (_, _, _) => const Icon(Icons.map_outlined),
                ),
                title: Text(map.mapName),
                onTap: () async {
                  Navigator.of(context).pop();
                  await map.showDirections(
                    destination: Coords(latitude, longitude),
                    destinationTitle: placeName,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
