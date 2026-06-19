import 'package:flutter/material.dart';
import 'package:lordicon/lordicon.dart';
import 'package:pulse/l10n/app_localizations.dart';

class MapWidgetLoading extends StatelessWidget {
  const MapWidgetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = IconController.assets(
      'assets/animations/animation_loading.json',
    );

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }

      if (status == ControllerStatus.completed) {
        controller.playFromBeginning();
      }
    });

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconViewer(controller: controller, width: 128, height: 128),
          Text(
            l10n.loadingMap,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}