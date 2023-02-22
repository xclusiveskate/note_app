class MyNote {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final String category;
  final bool isSelected;
  MyNote({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.category,
    required this.isSelected,
  });

  MyNote copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    String? category,
    bool? isSelected,
  }) {
    return MyNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      category: category ?? this.category,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'category': category,
      'isSelected': isSelected
    };
  }

  factory MyNote.fromMysqlMap(Map<String, dynamic> map) {
    return MyNote(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      date: DateTime.parse(map['date']),
      category: map['category'] as String,
      isSelected: map['isSelected'] == 1 ? true : false,
    );
  }
}

List<MyNote> noteContainer = [];
