import 'package:scrumflow/utils/json_helper.dart';

enum UserCategory { admin, scrumMaster, user }

class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final DateTime? createdAt;
  final bool? active;
  final UserCategory? userCategory;

  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.createdAt,
    this.active,
    this.userCategory = UserCategory.user,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: JsonHelper.keyExists<int>(json, 'id'),
        name: JsonHelper.keyExists<String>(json, 'name'),
        email: JsonHelper.keyExists<String>(json, 'email'),
        createdAt: JsonHelper.toDateTime(JsonHelper.keyExists(json, 'dt_created')),
        active: JsonHelper.toBool(JsonHelper.keyExists(json, 'active')),
        userCategory: JsonHelper.toEnum(UserCategory.values, JsonHelper.keyExists(json, 'userCategory'), base: UserCategory.user.index));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'email': email,
      'dt_created': createdAt?.toIso8601String() ?? '',
      'active': active,
      'userCategory': userCategory?.index,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? password,
    String? email,
    DateTime? createdAt,
    bool? active,
    UserCategory? userCategory,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      active: active ?? this.active,
      userCategory: userCategory ?? this.userCategory,
    );
  }
}
