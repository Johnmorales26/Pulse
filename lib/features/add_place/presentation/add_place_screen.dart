import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_bloc.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_intent.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_state.dart';
import 'package:pulse/features/map/domain/model/place_icon.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo lugar')),
      // BlocConsumer:
      //   • listener → efectos de lado: SnackBar de error y pop en éxito.
      //   • builder  → reconstruye solo cuando cambia selectedCategory o status.
      body: BlocConsumer<AddPlaceBloc, AddPlaceState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == AddPlaceStatus.unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Debes iniciar sesión para realizar esta acción.',
                ),
                backgroundColor: Colors.orange,
              ),
            );
            return;
          }
          if (state.status == AddPlaceStatus.validationError ||
              state.status == AddPlaceStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Error desconocido.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          if (state.status == AddPlaceStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lugar guardado correctamente.'),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          }
        },
        buildWhen: (prev, curr) =>
            prev.selectedCategory != curr.selectedCategory ||
            prev.status != curr.status,
        builder: (context, state) {
          final isLoading = state.status == AddPlaceStatus.loading;
          return SafeArea(
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
                          label: 'Name',
                          hint: 'Enter place name',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 8.0),
                        DarkTextField(
                          label: 'Description',
                          hint: 'Enter description',
                          controller: _descriptionController,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4.0),
                        _CategoryTile(
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
                    // Deshabilitado durante la carga para evitar doble envío
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
                    label: Text(isLoading ? 'Guardando...' : 'Save Place'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets privados
// ---------------------------------------------------------------------------

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.selected, required this.onTap});

  final PlaceIcon? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff2a2a2a),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Image.asset(
            selected?.asset ?? 'assets/icons/locations/ic_location_all.png',
            width: 36.0,
            height: 36.0,
          ),
          title: Text(selected?.label ?? 'Select Category'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom sheet
// ---------------------------------------------------------------------------

/// Muestra el modal con la lista de categorías registrables.
/// Recibe el [context] de la pantalla (que tiene el BLoC en su árbol)
/// para despachar [SelectCategoryIntent] correctamente.
void _showCategoryBottomSheet(BuildContext context) {
  final categories = PlaceIcon.values
      .where((c) => c != PlaceIcon.all && c != PlaceIcon.unknown)
      .toList();

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xff1e1e1e),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (sheetContext) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Category',
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
                      // Usamos el [context] externo (pantalla) que tiene
                      // el BLoC. El [sheetContext] del overlay no lo tiene.
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
  );
}
