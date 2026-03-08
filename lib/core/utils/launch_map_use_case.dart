import 'package:map_launcher/map_launcher.dart';

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