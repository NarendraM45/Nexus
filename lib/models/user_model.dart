class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role;
  final int taskCount;
  final int activeCount;
  final double score;
  final int streak;
  final bool isProMember;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = 'Pro Member',
    this.taskCount = 0,
    this.activeCount = 0,
    this.score = 0.0,
    this.streak = 0,
    this.isProMember = true,
  });

  // ✅ Safe factory — never crashes even with partial JSON
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] as String?) ?? 'user_001',
      name: (map['name'] as String?) ?? 'User',
      email: (map['email'] as String?) ?? 'user@nexus.app',
      avatarUrl: map['avatarUrl'] as String?,
      role: (map['role'] as String?) ?? 'Pro Member',
      taskCount: (map['taskCount'] as int?) ?? 0,
      activeCount: (map['activeCount'] as int?) ?? 0,
      score: ((map['score'] as num?) ?? 0.0).toDouble(),
      streak: (map['streak'] as int?) ?? 0,
      isProMember: (map['isProMember'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'email': email,
    'avatarUrl': avatarUrl, 'role': role,
    'taskCount': taskCount, 'activeCount': activeCount,
    'score': score, 'streak': streak, 'isProMember': isProMember,
  };

  // ✅ copyWith — all fields optional
  UserModel copyWith({
    String? id, String? name, String? email, String? avatarUrl,
    String? role, int? taskCount, int? activeCount,
    double? score, int? streak, bool? isProMember,
  }) {
    return UserModel(
      id: id ?? this.id, name: name ?? this.name,
      email: email ?? this.email, avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role, taskCount: taskCount ?? this.taskCount,
      activeCount: activeCount ?? this.activeCount,
      score: score ?? this.score, streak: streak ?? this.streak,
      isProMember: isProMember ?? this.isProMember,
    );
  }
}
