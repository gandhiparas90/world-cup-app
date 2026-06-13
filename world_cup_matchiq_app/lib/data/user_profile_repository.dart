import 'package:hive/hive.dart';

import '../models/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> load();

  Future<void> save(UserProfile profile);

  Future<void> clear();
}

class InMemoryUserProfileRepository implements UserProfileRepository {
  UserProfile? _profile;

  @override
  Future<UserProfile?> load() async {
    return _profile;
  }

  @override
  Future<void> save(UserProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> clear() async {
    _profile = null;
  }
}

class HiveUserProfileRepository implements UserProfileRepository {
  HiveUserProfileRepository({required this.box});

  static const boxName = 'user_profile';
  static const _activeProfileKey = 'active_profile';

  final Box<dynamic> box;

  @override
  Future<UserProfile?> load() async {
    final stored = box.get(_activeProfileKey);
    if (stored is Map<dynamic, dynamic>) {
      return UserProfile.fromStorageMap(stored);
    }
    return null;
  }

  @override
  Future<void> save(UserProfile profile) async {
    await box.put(_activeProfileKey, profile.toStorageMap());
  }

  @override
  Future<void> clear() async {
    await box.delete(_activeProfileKey);
  }
}
