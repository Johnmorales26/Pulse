import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/presentation/utils/app_toast.dart';
import 'package:pulse/core/presentation/widgets/blurred_bottom_sheet.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_bloc.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_intent.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_state.dart';
import 'package:pulse/features/map/domain/model/place_icon.dart';
import 'package:pulse/features/widgets/category_tile.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';
import 'package:pulse/l10n/app_localizations.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key, required this.lat, required this.lng});

  final double lat;
  final double lng;

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    context.read<AddPlaceBloc>().add(
      SubmitPlaceIntent(
        name: _nameController.text,
        description: _descriptionController.text,
        lat: widget.lat,
        lng: widget.lng,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addPlaceTitle)),
      body: BlocConsumer<AddPlaceBloc, AddPlaceState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          final l10n = AppLocalizations.of(context)!;

          if (state.status == AddPlaceStatus.unauthenticated) {
            AppToast.info(context, state.errorMessage ?? l10n.signInRequired);
            return;
          }
          if (state.status == AddPlaceStatus.validationError ||
              state.status == AddPlaceStatus.failure) {
            AppToast.error(context, state.errorMessage ?? l10n.unknownError);
            context.pop(false);
          }
          if (state.status == AddPlaceStatus.success) {
            AppToast.success(context, l10n.placeSavedSuccess);
            context.pop(true);
          }
        },
        buildWhen: (prev, curr) =>
            prev.selectedCategory != curr.selectedCategory ||
            prev.status != curr.status,
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          final isLoading = state.status == AddPlaceStatus.loading;

          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewInsets.bottom -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.vertical,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/img_map_simulated.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 16.0),
                              DarkTextField(
                                label: l10n.placeNameLabel,
                                hint: l10n.placeNameHint,
                                controller: _nameController,
                              ),
                              const SizedBox(height: 8.0),
                              DarkTextField(
                                label: l10n.placeDescriptionLabel,
                                hint: l10n.placeDescriptionHint,
                                controller: _descriptionController,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                l10n.categoryLabel,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4.0),
                              CategoryTile(
                                selected: state.selectedCategory,
                                onTap: () => _showCategoryBottomSheet(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: FloatingActionButton.extended(
                          onPressed: isLoading ? null : () => _onSave(context),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(isLoading ? l10n.savingLabel : l10n.savePlaceButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showCategoryBottomSheet(BuildContext context) {
  final categories = PlaceIcon.values
      .where((c) => c != PlaceIcon.all && c != PlaceIcon.unknown)
      .toList();

  showBlurredModalBottomSheet<void>(
    context: context,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    child: Builder(
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(context)!;

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.selectCategoryTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    final category = categories[index];
                    return ListTile(
                      leading: Image.asset(
                        category.asset,
                        width: 36,
                        height: 36,
                      ),
                      title: Text(category.label),
                      onTap: () {
                        context.read<AddPlaceBloc>().add(
                          SelectCategoryIntent(category),
                        );
                        Navigator.of(sheetContext).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
