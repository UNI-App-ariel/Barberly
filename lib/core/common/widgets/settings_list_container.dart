import 'package:flutter/material.dart';

class SettingsListContainer extends StatelessWidget {
  final List<Widget> tiles;
  final double dividerIndent;
  final String? header;
  final String? footer;

  const SettingsListContainer({
    super.key,
    required this.tiles,
    this.dividerIndent = 16.0, // Default divider indent
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // header
        if (header != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  header!,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),

        // list
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: _buildTileList(context),
          ),
        ),
      ],
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
