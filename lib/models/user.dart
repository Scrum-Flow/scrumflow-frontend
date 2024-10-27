import 'package:scrumflow/models/user_role.dart';
import 'package:scrumflow/utils/utils.dart';

class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final DateTime? createdAt;
  final bool? active;
  final List<UserRole>? roles;

  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.createdAt,
    this.active,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: Helper.keyExists<int>(json, 'id'),
      name: Helper.keyExists<String>(json, 'name'),
      email: Helper.keyExists<String>(json, 'email'),
      createdAt: Helper.toDateTime(Helper.keyExists(json, 'dt_created')),
      active: Helper.toBool(Helper.keyExists(json, 'active')),
      roles: Helper.keyExists(json, 'roles')?.map<UserRole>((json) => UserRole.fromJson(json)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'dt_created': createdAt?.toIso8601String() ?? '',
      'active': active,
      'roles': roles?.map((role) => role.toJson()).toList(),
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? password,
    String? email,
    DateTime? createdAt,
    bool? active,
    List<UserRole>? roles,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      active: active ?? this.active,
      roles: roles ?? this.roles,
    );
  }

  @override
  bool operator ==(Object other) {
    return id == (other as User).id;
  }

  @override
  String toString() => name ?? '';
}
