import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkModel {
  String id;
  String title;
  String? description;
  DateTime dueDate;
  bool isCompleted;
  DateTime createdAt;

  HomeworkModel({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory HomeworkModel.fromMap(Map<String, dynamic> map, String id) {
    return HomeworkModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
