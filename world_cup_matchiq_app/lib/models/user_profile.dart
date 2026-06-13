class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.countryCode,
    required this.timezone,
    required this.favoriteTeamId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String displayName;
  final String countryCode;
  final String timezone;
  final String favoriteTeamId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, Object?> toStorageMap() {
    return {
      'displayName': displayName,
      'countryCode': countryCode,
      'timezone': timezone,
      'favoriteTeamId': favoriteTeamId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromStorageMap(Map<dynamic, dynamic> map) {
    return UserProfile(
      displayName: map['displayName'] as String,
      countryCode: map['countryCode'] as String,
      timezone: map['timezone'] as String,
      favoriteTeamId: map['favoriteTeamId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? countryCode,
    String? timezone,
    String? favoriteTeamId,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      countryCode: countryCode ?? this.countryCode,
      timezone: timezone ?? this.timezone,
      favoriteTeamId: favoriteTeamId ?? this.favoriteTeamId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
