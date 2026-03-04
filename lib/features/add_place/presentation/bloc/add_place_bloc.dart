import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/add_place/domain/model/new_place.dart';
import 'package:pulse/features/add_place/domain/usecases/add_place_use_case.dart';
import 'add_place_intent.dart';
import 'add_place_state.dart';

class AddPlaceBloc extends Bloc<AddPlaceIntent, AddPlaceState> {
  final AddPlaceUseCase addPlaceUseCase;
  final GetCurrentUserIdUseCase getCurrentUserId;

  AddPlaceBloc(this.addPlaceUseCase, this.getCurrentUserId)
      : super(const AddPlaceState()) {
    on<SelectCategoryIntent>(_onSelectCategory);
    on<SubmitPlaceIntent>(_onSubmit);
  }

  void _onSelectCategory(
    SelectCategoryIntent intent,
    Emitter<AddPlaceState> emit,
  ) {
    emit(state.copyWith(selectedCategory: intent.category));
  }

  Future<void> _onSubmit(
    SubmitPlaceIntent intent,
    Emitter<AddPlaceState> emit,
  ) async {
    // 1. Validación de sesión: primer rechazo antes de tocar datos o Firebase.
    final uid = getCurrentUserId();
    if (uid == null) {
      emit(state.copyWith(
        status: AddPlaceStatus.unauthenticated,
        errorMessage: 'Debes iniciar sesión para realizar esta acción.',
      ));
      return;
    }

    // 2. Validación de formulario en el BLoC: la UI permanece libre de lógica.
    if (intent.name.trim().isEmpty ||
        intent.description.trim().isEmpty ||
        state.selectedCategory == null) {
      emit(state.copyWith(
        status: AddPlaceStatus.validationError,
        errorMessage: 'Nombre, descripción y categoría son obligatorios.',
      ));
      return;
    }

    emit(state.copyWith(status: AddPlaceStatus.loading));

    try {
      await addPlaceUseCase(
        NewPlace(
          name: intent.name.trim(),
          description: intent.description.trim(),
          type: state.selectedCategory!.id,
          latitude: intent.lat,
          longitude: intent.lng,
        ),
      );
      emit(state.copyWith(status: AddPlaceStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: AddPlaceStatus.failure,
        errorMessage: 'Error al guardar el lugar. Intenta de nuevo.',
      ));
    }
  }
}
