import 'package:flutter/material.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 5
        ),
        color: Colors.black45,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        tooltip: 'Cerrar',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}