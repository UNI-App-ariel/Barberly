import 'package:flutter/material.dart';

class SettingsListContainer extends StatelessWidget {
  final List<Widget> tiles;
  final double dividerIndent;

  const SettingsListContainer({
    super.key,
    required this.tiles,
    this.dividerIndent = 16.0, // Default divider indent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: _buildTileList(context),
      ),
    );
  }

  List<Widget> _buildTileList(BuildContext context) {
    final List<Widget> children = [];
    for (int i = 0; i < tiles.length; i++) {
      children.add(tiles[i]);

      // Add divider except for the last tile
      if (i != tiles.length - 1) {
        children.add(
          Divider(
            color: Theme.of(context).colorScheme.secondary,
            height: 0,
            indent: dividerIndent,
          ),
        );
      }
    }
    return children;
  }
}
