/// Domain Entity - Pure business object with no external dependencies
class Task {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  Task({this.id, required this.title, required this.description, this.isCompleted = false, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  /// Create a copy with modified fields
  Task copyWith({int? id, String? title, String? description, bool? isCompleted, DateTime? createdAt}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description, 'isCompleted': isCompleted ? 1 : 0, 'createdAt': createdAt.toIso8601String()};
  }

  /// Create from Map from database
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id && other.title == title && other.description == description && other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, description, isCompleted);
  }
}
