import 'package:flutter/material.dart';

class DarkTextField extends StatelessWidget {
  const DarkTextField({
    super.key,
    required this.hint,
    this.label,
    this.controller,
    this.sufficIcon,
  });

  final String hint;
  final String? label;
  final TextEditingController? controller;
  final Widget? sufficIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (label != null)
          Text(label!, style: Theme.of(context).textTheme.bodyMedium),
        if (label != null) const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: const Color(0xff2a2a2a),
            suffixIcon: sufficIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white24, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
