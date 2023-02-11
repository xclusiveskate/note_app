class MyCategory {
  final int? id;
  String title;
  String description;

  MyCategory({
    this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory MyCategory.fromMysqlMap(Map<String, dynamic> map) {
    return MyCategory(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  MyCategory copyWith({
    int? id,
    String? title,
    String? description,
  }) {
    return MyCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

List<MyCategory> myCategories = [];
