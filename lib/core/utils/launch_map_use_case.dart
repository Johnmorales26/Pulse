import 'package:map_launcher/map_launcher.dart';

/// Obtiene la lista de apps de mapas instaladas en el dispositivo.
/// Lanza [StateError] si no hay ninguna instalada.
class LaunchMapUseCase {
  const LaunchMapUseCase();

  Future<List<AvailableMap>> call() async {
    final maps = await MapLauncher.installedMaps;
    if (maps.isEmpty) {
      throw StateError('No map apps installed');
    }
    return maps;
  }
}