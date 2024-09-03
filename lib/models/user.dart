class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final DateTime? createdAt;
  final bool? active;

  User({
    this.id,
    this.name,
    this.password,
    this.email,
    this.createdAt,
    this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: DateTime.parse(json['dt_created']),
      active: json['active'],
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
    };
  }
}
