import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 120, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Icon(Icons.arrow_downward, size: 48, color: Colors.grey[400]),
        ],
      ),
    );
  }
}
