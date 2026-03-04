import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/utils/date_time_extensions.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_bloc.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_intent.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_state.dart';
import 'package:pulse/features/place_detail/presentation/widgets/image_carousel.dart';
import 'package:pulse/features/widgets/dark_text_field.dart';

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
    // AQUÍ: Disparamos el intent inicial; el BLoC se suscribe al Stream de Firebase
    context.read<PlaceDetailBloc>().add(
      ObservePlaceDetailIntent(widget.placeId),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // BlocBuilder aislado: solo reconstruye el título, no el Scaffold entero.
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
              // Captura la respuesta tras enviar un comentario (loading → otro).
              (previous.status == PlaceDetailStatus.loading &&
                  previous.place != null &&
                  current.status != PlaceDetailStatus.loading) ||
              // Captura el rechazo por sesión sin necesidad de pasar por loading.
              current.status == PlaceDetailStatus.unauthenticated,
          listener: (context, state) {
            if (state.status == PlaceDetailStatus.unauthenticated) {
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
            if (state.status == PlaceDetailStatus.success) {
              _commentController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comentario añadido')),
              );
            }
            if (state.status == PlaceDetailStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Error al añadir comentario',
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            // ESTADO initial / loading sin place → carga inicial del lugar
            if (state.place == null) {
              if (state.status == PlaceDetailStatus.error) {
                // ESTADO error en la carga inicial — no hay place que mostrar
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.errorMessage ?? 'Error al cargar el lugar',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<PlaceDetailBloc>().add(
                            ObservePlaceDetailIntent(widget.placeId),
                          ),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              // ESTADO loading inicial → spinner
              return const Center(child: CircularProgressIndicator());
            }

            // AQUÍ: Consumiendo el estado exitoso — extraemos el place del estado
            final PlaceLocation place = state.place!;
            final bool isSubmittingComment =
                state.status == PlaceDetailStatus.loading;

            return _PlaceDetailBody(
              place: place,
              comments: state.comments,
              commentController: _commentController,
              isSubmittingComment: isSubmittingComment,
              placeId: widget.placeId,
            );
          },
        ),
      ),
    );
  }
}

/// Widget interno que renderiza el contenido visual una vez que [place] está disponible.
/// No modifica ningún componente de diseño existente.
class _PlaceDetailBody extends StatelessWidget {
  const _PlaceDetailBody({
    required this.place,
    required this.comments,
    required this.commentController,
    required this.isSubmittingComment,
    required this.placeId,
  });

  final PlaceLocation place;
  final List<PlaceComments> comments;
  final TextEditingController commentController;
  final bool isSubmittingComment;
  final String placeId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageCarousel(photos: place.photos),
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
                    subtitle: Text(comment.createdAt.toDisplayFormat()),
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
                  hint: 'Escribe un comentario...',
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
