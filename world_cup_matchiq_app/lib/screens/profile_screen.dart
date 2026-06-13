import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/saved_prediction.dart';
import '../models/team.dart';
import '../models/user_profile.dart';
import '../utils/match_viewing.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.profile,
    required this.teams,
    required this.savedPredictions,
    required this.onSaveProfile,
    required this.onResetProfile,
    required this.onClearSavedPredictions,
    super.key,
  });

  final UserProfile? profile;
  final List<Team> teams;
  final List<SavedPrediction> savedPredictions;
  final Future<void> Function(UserProfile profile) onSaveProfile;
  final Future<void> Function() onResetProfile;
  final Future<void> Function() onClearSavedPredictions;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late String _countryCode;
  late String _timezone;
  late String _favoriteTeamId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _syncFields(widget.profile);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _syncFields(widget.profile);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Profile',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Display name',
                    prefixIcon: Icon(LucideIcons.userRound),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: ValueKey('country-$_countryCode'),
                  initialValue: _countryCode,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    prefixIcon: Icon(LucideIcons.globe),
                  ),
                  items: [
                    for (final country in countryChoices)
                      DropdownMenuItem(
                        value: country.value,
                        child: Text(country.label),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _countryCode = value);
                    }
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: ValueKey('timezone-$_timezone'),
                  initialValue: _timezone,
                  decoration: const InputDecoration(
                    labelText: 'Time zone',
                    prefixIcon: Icon(LucideIcons.clock),
                  ),
                  items: [
                    for (final timezone in timezoneChoices)
                      DropdownMenuItem(
                        value: timezone.value,
                        child: Text(timezone.label),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _timezone = value);
                    }
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: ValueKey('favorite-team-$_favoriteTeamId'),
                  initialValue: _favoriteTeamId,
                  decoration: const InputDecoration(
                    labelText: 'Favorite team',
                    prefixIcon: Icon(LucideIcons.star),
                  ),
                  items: [
                    for (final team in widget.teams)
                      DropdownMenuItem(value: team.id, child: Text(team.name)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _favoriteTeamId = value);
                    }
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _save,
                        icon: const Icon(LucideIcons.save),
                        label: const Text('Save profile'),
                      ),
                    ),
                  ],
                ),
                if (widget.profile != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: widget.onResetProfile,
                    icon: const Icon(LucideIcons.trash2),
                    label: const Text('Reset profile'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SavedPredictionSection(
          predictions: widget.savedPredictions,
          onClearPredictions: widget.onClearSavedPredictions,
        ),
      ],
    );
  }

  Future<void> _save() async {
    final now = DateTime.now();
    final trimmedName = _nameController.text.trim();
    await widget.onSaveProfile(
      UserProfile(
        displayName: trimmedName.isEmpty ? 'World Cup fan' : trimmedName,
        countryCode: _countryCode,
        timezone: _timezone,
        favoriteTeamId: _favoriteTeamId,
        createdAt: widget.profile?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  }

  void _syncFields(UserProfile? profile) {
    final fallbackTeamId = _teamIdOrFallback(widget.teams, 'por');
    _nameController.text = profile?.displayName ?? 'World Cup fan';
    _countryCode = _choiceOrFallback(
      countryChoices,
      profile?.countryCode,
      countryChoices.first.value,
    );
    _timezone = _choiceOrFallback(
      timezoneChoices,
      profile?.timezone,
      'America/Chicago',
    );
    _favoriteTeamId = _teamIdOrFallback(
      widget.teams,
      profile?.favoriteTeamId ?? fallbackTeamId,
    );
  }
}

class _SavedPredictionSection extends StatelessWidget {
  const _SavedPredictionSection({
    required this.predictions,
    required this.onClearPredictions,
  });

  final List<SavedPrediction> predictions;
  final Future<void> Function() onClearPredictions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.bookmark, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Saved predictions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (predictions.isEmpty)
              const Text('No saved predictions yet.')
            else ...[
              OutlinedButton.icon(
                onPressed: onClearPredictions,
                icon: const Icon(LucideIcons.trash2),
                label: const Text('Clear saved predictions'),
              ),
              const SizedBox(height: 12),
              for (final prediction in predictions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(prediction.matchLabel),
                  subtitle: Text(
                    '${prediction.scoreline} - ${prediction.confidence} confidence',
                  ),
                  trailing: Text(
                    '${prediction.createdAt.hour.toString().padLeft(2, '0')}:${prediction.createdAt.minute.toString().padLeft(2, '0')}',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

String _choiceOrFallback(
  List<ProfileChoice> choices,
  String? value,
  String fallback,
) {
  final hasValue = choices.any((choice) => choice.value == value);
  return hasValue ? value! : fallback;
}

String _teamIdOrFallback(List<Team> teams, String id) {
  if (teams.any((team) => team.id == id)) {
    return id;
  }
  return teams.first.id;
}
