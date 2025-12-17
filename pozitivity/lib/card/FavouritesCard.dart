import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  final String affirmation;
  final Color categoryBaseColor;
  final VoidCallback? onDelete;

  const FavoriteCard({
    super.key,
    required this.affirmation,
    required this.categoryBaseColor,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: categoryBaseColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              affirmation,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
