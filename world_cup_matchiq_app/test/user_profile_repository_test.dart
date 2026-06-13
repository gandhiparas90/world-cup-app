import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:world_cup_matchiq/data/user_profile_repository.dart';
import 'package:world_cup_matchiq/models/user_profile.dart';

void main() {
  group('UserProfile storage', () {
    test('serializes and restores the active profile', () {
      final profile = UserProfile(
        displayName: 'Paras',
        countryCode: 'US',
        timezone: 'America/Chicago',
        favoriteTeamId: 'por',
        createdAt: DateTime(2026, 6, 13, 10),
        updatedAt: DateTime(2026, 6, 13, 10),
      );

      final restored = UserProfile.fromStorageMap(profile.toStorageMap());

      expect(restored.displayName, profile.displayName);
      expect(restored.countryCode, profile.countryCode);
      expect(restored.timezone, profile.timezone);
      expect(restored.favoriteTeamId, profile.favoriteTeamId);
      expect(restored.createdAt, profile.createdAt);
      expect(restored.updatedAt, profile.updatedAt);
    });

    test(
      'Hive repository persists the profile after reopening the box',
      () async {
        final tempDir = await Directory.systemTemp.createTemp(
          'matchiq_profile_hive_test_',
        );
        Hive.init(tempDir.path);

        try {
          var box = await Hive.openBox<dynamic>('user_profile_test');
          var repository = HiveUserProfileRepository(box: box);
          final profile = UserProfile(
            displayName: 'Paras',
            countryCode: 'US',
            timezone: 'America/Chicago',
            favoriteTeamId: 'por',
            createdAt: DateTime(2026, 6, 13, 10),
            updatedAt: DateTime(2026, 6, 13, 10),
          );

          await repository.save(profile);
          await box.close();

          box = await Hive.openBox<dynamic>('user_profile_test');
          repository = HiveUserProfileRepository(box: box);
          final saved = await repository.load();

          expect(saved?.displayName, 'Paras');
          expect(saved?.favoriteTeamId, 'por');

          await repository.clear();
          expect(await repository.load(), isNull);
          await box.close();
        } finally {
          await Hive.close();
          await tempDir.delete(recursive: true);
        }
      },
    );
  });
}
