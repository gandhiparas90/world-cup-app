import 'package:flutter/material.dart';

import '../models/saved_prediction.dart';

class SavedPredictionsScreen extends StatelessWidget {
  const SavedPredictionsScreen({
    required this.predictions,
    super.key,
  });

  final List<SavedPrediction> predictions;

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No saved predictions yet. Open a match and save the prototype estimate.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: predictions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        return Card(
          child: ListTile(
            title: Text(prediction.matchLabel),
            subtitle: Text('${prediction.scoreline} - ${prediction.confidence} confidence'),
            trailing: Text(
              '${prediction.createdAt.hour.toString().padLeft(2, '0')}:${prediction.createdAt.minute.toString().padLeft(2, '0')}',
            ),
          ),
        );
      },
    );
  }
}
