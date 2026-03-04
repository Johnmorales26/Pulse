/// Modelo de entrada con los datos mínimos requeridos para registrar
/// un nuevo lugar en Firestore. No contiene ID ni campos generados
/// por el servidor (createdAt, rating, etc.), que se crean en el datasource.
class NewPlace {
  final String name;
  final String description;
  final String type; // Corresponde a PlaceIcon.id
  final double latitude;
  final double longitude;

  const NewPlace({
    required this.name,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
  });
}
