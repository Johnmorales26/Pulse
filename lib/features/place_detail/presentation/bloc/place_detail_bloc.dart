import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/place_detail/domain/usecases/check_if_place_saved_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_place_stream_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/toggle_saved_place_use_case.dart';
import '../../domain/usecases/add_comment_use_case.dart';
import 'place_detail_intent.dart';
import 'place_detail_state.dart';

class PlaceDetailBloc extends Bloc<PlaceDetailIntent, PlaceDetailState> {
  final AddCommentUseCase addCommentUseCase;
  final GetPlaceStreamUseCase getPlaceStreamUseCase;
  final CheckIfPlaceSavedUseCase checkIfPlaceSavedUseCase;
  final ToggleSavedPlaceUseCase toggleSavedPlaceUseCase;
  final GetCurrentUserIdUseCase getCurrentUserId;
  StreamSubscription? _placeSubscription;

  PlaceDetailBloc(
    this.addCommentUseCase,
    this.getPlaceStreamUseCase,
    this.checkIfPlaceSavedUseCase,
    this.toggleSavedPlaceUseCase,
    this.getCurrentUserId,
  ) : super(PlaceDetailState()) {
    on<InitializePlaceDetailIntent>((intent, emit) {
      emit(state.copyWith(comments: List.from(intent.initialComments)));
    });

    on<ObservePlaceDetailIntent>((intent, emit) async {
      emit(state.copyWith(status: PlaceDetailStatus.loading));
      await _placeSubscription?.cancel();

      final uid = getCurrentUserId();
      if (uid != null) {
        try {
          final saved = await checkIfPlaceSavedUseCase(uid, intent.placeId);
          emit(state.copyWith(isSaved: saved));
        } catch (_) {
          // ignore: empty_catches
        }
      }

      _placeSubscription = getPlaceStreamUseCase(intent.placeId).listen(
        (place) => add(UpdatePlaceDetailIntent(place)),
        onError: (error) => add(SetErrorIntent(error.toString())),
      );
    });

    on<UpdatePlaceDetailIntent>((intent, emit) {
      emit(state.copyWith(
        status: PlaceDetailStatus.success,
        place: intent.place,
        comments: intent.place.comments,
      ));
    });

    on<SetErrorIntent>((intent, emit) {
      emit(state.copyWith(
        status: PlaceDetailStatus.error,
        errorMessage: intent.message,
      ));
    });

    on<ToggleSavePlaceIntent>((intent, emit) async {
      final uid = getCurrentUserId();
      if (uid == null) {
        emit(state.copyWith(
          status: PlaceDetailStatus.unauthenticated,
          errorMessage: 'Debes iniciar sesión para guardar lugares.',
        ));
        return;
      }

      final previousIsSaved = state.isSaved;

      emit(state.copyWith(isSaved: !previousIsSaved));

      try {
        await toggleSavedPlaceUseCase(
          uid,
          intent.placeId,
          isCurrentlySaved: previousIsSaved,
        );
      } catch (e) {
        emit(state.copyWith(
          isSaved: previousIsSaved,
          status: PlaceDetailStatus.error,
          errorMessage: 'No se pudo actualizar la lista de guardados.',
        ));
      }
    });

    on<AddCommentIntent>((intent, emit) async {
      final uid = getCurrentUserId();
      if (uid == null) {
        emit(state.copyWith(
          status: PlaceDetailStatus.unauthenticated,
          errorMessage: 'Debes iniciar sesión para realizar esta acción.',
        ));
        return;
      }

      emit(state.copyWith(status: PlaceDetailStatus.loading));
      try {
        await addCommentUseCase(intent.placeId, intent.comment);

        final newComment = PlaceComments(
          comment: intent.comment,
          createdBy: uid,
          createdAt: DateTime.now(),
        );

        final updatedComments = List<PlaceComments>.from(state.comments)
          ..add(newComment);

        emit(state.copyWith(
          status: PlaceDetailStatus.success,
          comments: updatedComments,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: PlaceDetailStatus.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _placeSubscription?.cancel();
    return super.close();
  }
}