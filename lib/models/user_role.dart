class UserRole {
  const UserRole({
    this.id,
    this.name,
  });

  final int? id;
  final String? name;

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) {
    return id == (other as UserRole).id;
  }
}
