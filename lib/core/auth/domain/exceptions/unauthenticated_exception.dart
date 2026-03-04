class UnauthenticatedException implements Exception {
  const UnauthenticatedException();

  @override
  String toString() => 'Usuario no autenticado.';
}
