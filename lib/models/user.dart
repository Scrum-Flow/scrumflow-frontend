class User {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;
  final bool active;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['nome'],
      email: json['email'],
      createdAt: DateTime.parse(json['dataCriacao']),
      active: json['ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'active': active,
    };
  }
}
