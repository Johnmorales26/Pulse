import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_place_stream_use_case.dart';
import '../../domain/usecases/add_comment_use_case.dart';
import 'place_detail_intent.dart';
import 'place_detail_state.dart';

class PlaceDetailBloc extends Bloc<PlaceDetailIntent, PlaceDetailState> {
  final AddCommentUseCase addCommentUseCase;
  final GetPlaceStreamUseCase getPlaceStreamUseCase;
  StreamSubscription? _placeSubscription;

  PlaceDetailBloc(this.addCommentUseCase, this.getPlaceStreamUseCase) : super(PlaceDetailState()) {
    on<InitializePlaceDetailIntent>((intent, emit) {
      emit(state.copyWith(comments: List.from(intent.initialComments)));
    });

    on<ObservePlaceDetailIntent>((intent, emit) async
      {
          emit(state.copyWith(status:
      PlaceDetailStatus.loading));
   
          // Cancelamos suscripción previa si existe
          await _placeSubscription?.cancel();
   
          // Nos suscribimos al flujo de datos en tiempo real
          _placeSubscription =
      getPlaceStreamUseCase(intent.placeId).listen(
            (place) {
              // Cada vez que Firestore cambie, el BLoC emite un nuevo estado
              add(UpdatePlaceDetailIntent(place));
            },
            onError: (error) =>
      add(SetErrorIntent(error.toString())),
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

    on<AddCommentIntent>((intent, emit) async {
      emit(state.copyWith(status: PlaceDetailStatus.loading));
      try {
        await addCommentUseCase(intent.placeId, intent.comment);

        // Creamos el nuevo comentario localmente para actualizar la UI sin otra consulta a Firebase
        final newComment = PlaceComments(
          comment: intent.comment,
          createdBy: 'user_1',
          createdAt: DateTime.now(),
        );

        // Actualizamos la lista local en el estado del BLoC
        final updatedComments = List<PlaceComments>.from(state.comments)
          ..add(newComment);

        emit(
          state.copyWith(
            status: PlaceDetailStatus.success,
            comments: updatedComments,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: PlaceDetailStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _placeSubscription?.cancel();
    return super.close();
  }
}
