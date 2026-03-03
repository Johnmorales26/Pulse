class PlaceComment {
  final String comment;
  final String createdBy;
  final DateTime? createdAt;

  PlaceComment({
    required this.comment,
    required this.createdBy,
    this.createdAt,
  });
}
