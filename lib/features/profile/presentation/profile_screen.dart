import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/features/map/domain/model/place_icon.dart';
import 'package:pulse/features/profile/domain/model/user_profile.dart';
import 'package:pulse/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pulse/features/profile/presentation/bloc/profile_intent.dart';
import 'package:pulse/features/profile/presentation/bloc/profile_state.dart';
import 'package:pulse/features/profile/presentation/bloc/saved_places_bloc.dart';
import 'package:pulse/features/profile/presentation/bloc/saved_places_intent.dart';
import 'package:pulse/features/profile/presentation/bloc/saved_places_state.dart';
import 'package:pulse/features/profile/presentation/widgets/gradient_avatar.dart';
import 'package:pulse/features/widgets/option_tile.dart';
import 'package:pulse/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.cameraOption),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.galleryOption),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    if (!context.mounted) return;

    context
        .read<ProfileBloc>()
        .add(ChangeProfilePictureIntent(File(picked.path)));
  }

  void _showSavedPlacesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => sl<SavedPlacesBloc>()..add(LoadSavedPlacesIntent()),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (sheetContext, scrollController) => _SavedPlacesSheet(
            scrollController: scrollController,
            onPlaceTap: (placeId) {
              Navigator.of(sheetContext).pop();
              context.pushNamed(
                RouterNames.placeDetail,
                pathParameters: {'id': placeId},
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSignOutSuccess) {
          context.go('/');
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.profileTitle)),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            if (state is ProfileInitial || state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            UserProfile? profile;
            bool isPhotoUploading = false;

            if (state is ProfileLoaded) {
              profile = state.profile;
            } else if (state is ProfilePictureUploading) {
              profile = state.profile;
              isPhotoUploading = true;
            }

            if (profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: isPhotoUploading
                                ? null
                                : () => _pickAndUploadImage(context),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GradientAvatar(
                                  photoUrl: profile.photoUrl,
                                  isUploading: isPhotoUploading,
                                ),
                                if (!isPhotoUploading)
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF8E2DE2),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          Text(
                            profile.username.isNotEmpty
                                ? profile.username
                                : l10n.noName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            profile.email,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          OptionTile(
                            option: l10n.editProfile,
                            icon: const Icon(Icons.edit),
                            onTap: () {},
                          ),
                          const SizedBox(height: 8.0),
                          OptionTile(
                            option: l10n.savedPlacesOption,
                            icon: const Icon(Icons.bookmark_outline),
                            onTap: () => _showSavedPlacesBottomSheet(context),
                          ),
                          const SizedBox(height: 8.0),
                          OptionTile(
                            option: l10n.settingsOption,
                            icon: const Icon(Icons.settings_outlined),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: isPhotoUploading
                          ? null
                          : () => context.read<ProfileBloc>().add(
                                SignOutIntent(),
                              ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(l10n.signOutButton),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SavedPlacesSheet extends StatelessWidget {
  const _SavedPlacesSheet({
    required this.scrollController,
    required this.onPlaceTap,
  });

  final ScrollController scrollController;
  final void Function(String placeId) onPlaceTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: BlocBuilder<SavedPlacesBloc, SavedPlacesState>(
                buildWhen: (prev, curr) =>
                    prev.runtimeType != curr.runtimeType ||
                    (curr is SavedPlacesLoaded &&
                        prev is SavedPlacesLoaded &&
                        prev.places.length != curr.places.length),
                builder: (context, state) {
                  final subtitle = state is SavedPlacesLoaded
                      ? l10n.savedPlacesCount(state.places.length)
                      : l10n.savedPlacesOption;
                  return Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<SavedPlacesBloc, SavedPlacesState>(
              builder: (context, state) {
                if (state is SavedPlacesInitial || state is SavedPlacesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SavedPlacesError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (state is SavedPlacesLoaded) {
                  if (state.places.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.noSavedPlaces,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: state.places.length,
                    itemBuilder: (context, index) {
                      final place = state.places[index];
                      final icon = PlaceIcon.fromId(place.type);
                      return ListTile(
                        leading: Image.asset(
                          icon.asset,
                          width: 36,
                          height: 36,
                        ),
                        title: Text(place.name),
                        subtitle: Text(icon.label),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => onPlaceTap(place.id),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}