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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Saved predictions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 12),
        if (predictions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Text(
              'No saved predictions yet. Open a match and save the prototype estimate.',
              textAlign: TextAlign.center,
            ),
          )
        else
          for (final prediction in predictions)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(prediction.matchLabel),
                subtitle: Text('${prediction.scoreline} - ${prediction.confidence} confidence'),
                trailing: Text(
                  '${prediction.createdAt.hour.toString().padLeft(2, '0')}:${prediction.createdAt.minute.toString().padLeft(2, '0')}',
                ),
              ),
            ),
      ],
    );
  }
}
