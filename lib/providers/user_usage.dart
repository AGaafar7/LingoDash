class UserUsage {
  final int totalUnits;
  final int usedUnits;
  final int translationUsed;

  UserUsage({
    required this.totalUnits,
    required this.usedUnits,
    required this.translationUsed,
  });

  factory UserUsage.fromMap(Map<String, dynamic> data) {
    return UserUsage(
      totalUnits: data['totalUnits'] ?? 0,
      usedUnits: data['usedUnits'] ?? 0,
      translationUsed: data['translationUsed'] ?? 0,
    );
  }
}
