import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_saved_places_use_case.dart';

import 'saved_places_intent.dart';
import 'saved_places_state.dart';

class SavedPlacesBloc extends Bloc<SavedPlacesIntent, SavedPlacesState> {
  final GetSavedPlacesUseCase _getSavedPlacesUseCase;
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;

  SavedPlacesBloc(
    this._getSavedPlacesUseCase,
    this._getCurrentUserIdUseCase,
  ) : super(SavedPlacesInitial()) {
    on<LoadSavedPlacesIntent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadSavedPlacesIntent intent,
    Emitter<SavedPlacesState> emit,
  ) async {
    emit(SavedPlacesLoading());
    try {
      final uid = _getCurrentUserIdUseCase();
      if (uid == null) {
        emit(SavedPlacesError('No hay sesión activa.'));
        return;
      }
      final places = await _getSavedPlacesUseCase(uid);
      emit(SavedPlacesLoaded(places));
    } catch (_) {
      emit(SavedPlacesError('No se pudieron cargar los lugares guardados.'));
    }
  }
}