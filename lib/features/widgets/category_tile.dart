import 'package:flutter/material.dart';
import 'package:pulse/features/map/domain/model/place_icon.dart';
import 'package:pulse/l10n/app_localizations.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.selected, required this.onTap});

  final PlaceIcon? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff2a2a2a),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Image.asset(
            selected?.asset ?? 'assets/icons/locations/ic_location_all.png',
            width: 36.0,
            height: 36.0,
          ),
          title: Text(selected?.label ?? AppLocalizations.of(context)!.selectCategoryTitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}