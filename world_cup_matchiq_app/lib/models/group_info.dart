class GroupInfo {
  const GroupInfo({
    required this.id,
    required this.name,
    required this.teamIds,
  });

  final String id;
  final String name;
  final List<String> teamIds;
}
