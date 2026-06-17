import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.option,
  });

  final Widget icon;
  final String option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: icon,
          title: Text(option),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
