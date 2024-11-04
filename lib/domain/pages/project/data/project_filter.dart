class ProjectFilter {
  final int? userId;

  ProjectFilter({
    this.userId,
  });

  ProjectFilter copyWith({
    int? userId,
  }) {
    return ProjectFilter(
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }

  factory ProjectFilter.fromMap(Map<String, dynamic> map) {
    return ProjectFilter(
      userId: map['userId'],
    );
  }
}
