import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Represents the currently selected action in the [FloatingMapActionBar].
enum FloatingMapAction {
  /// Search button is selected.
  search,
  /// Filter button is selected.
  filter,
  /// Center location button is selected.
  location,
}

/// A horizontal pill-shaped action bar that floats at the bottom of the map.
///
/// Contains three icon buttons: search, filter (with active/inactive visual
/// state), and center-on-my-location. Each button includes a [Semantics] label
/// and a tooltip for accessibility.
///
/// The selected button displays a circular border highlight.
/// Only one action can be selected at a time.
///
/// Selection state is managed internally — tap a button to select it,
/// tap again to deselect, or tap another to switch selection.
class FloatingMapActionBar extends StatefulWidget {
  const FloatingMapActionBar({
    super.key,
    required this.onSearch,
    required this.onFilter,
    required this.onLocation,
    required this.isFilterActive,
  });

  /// Called when the search button is tapped.
  final VoidCallback onSearch;

  /// Called when the filter button is tapped.
  final VoidCallback onFilter;

  /// Called when the location button is tapped.
  final VoidCallback onLocation;

  /// Whether any filter category is currently selected (drives the filter icon
  /// variant: filled when active, outlined when inactive).
  final bool isFilterActive;

  @override
  State<FloatingMapActionBar> createState() => _FloatingMapActionBarState();
}

class _FloatingMapActionBarState extends State<FloatingMapActionBar> {
  FloatingMapAction? _selectedAction;

  // Getters for convenient access to widget properties
  VoidCallback get onSearch => widget.onSearch;
  VoidCallback get onFilter => widget.onFilter;
  VoidCallback get onLocation => widget.onLocation;
  bool get isFilterActive => widget.isFilterActive;

  void _handleTap(FloatingMapAction action) {
    setState(() {
      if (_selectedAction == action) {
        _selectedAction = null; // Deselect on second tap
      } else {
        _selectedAction = action;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Liquid Glass effect colors
    final glassColor = theme.colorScheme.surface.withValues(alpha: 0.75);
    final borderColor = theme.colorScheme.outline.withValues(alpha: 0.2);
    final shadowColor = theme.colorScheme.shadow.withValues(alpha: 0.1);

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context: context,
                action: FloatingMapAction.search,
                icon: Icons.search,
                semanticsLabel: l10n.searchLabel,
                tooltip: l10n.searchLabel,
                onPressed: onSearch,
              ),
              _buildActionButton(
                context: context,
                action: FloatingMapAction.filter,
                icon: isFilterActive
                    ? Icons.filter_list
                    : Icons.filter_list_outlined,
                semanticsLabel: l10n.filterLabel,
                tooltip: l10n.filterLabel,
                onPressed: onFilter,
              ),
              _buildActionButton(
                context: context,
                action: FloatingMapAction.location,
                icon: Icons.my_location_outlined,
                semanticsLabel: l10n.myLocationTooltip,
                tooltip: l10n.myLocationTooltip,
                onPressed: onLocation,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single action button with selection border and interaction states.
  Widget _buildActionButton({
    required BuildContext context,
    required FloatingMapAction action,
    required IconData icon,
    required String semanticsLabel,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final isSelected = _selectedAction == action;
    final primaryColor = theme.colorScheme.primary;

    return Semantics(
      label: semanticsLabel,
      button: true,
      selected: isSelected,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: () {
            _handleTap(action);
            onPressed();
          },
          borderRadius: BorderRadius.circular(24),
          splashFactory: InkSparkle.splashFactory,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: primaryColor,
                      width: 2.5,
                    )
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? primaryColor
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
