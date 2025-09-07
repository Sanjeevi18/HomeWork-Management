import 'package:get/get.dart';
import '../models/homework_model.dart';

class HomeworkController extends GetxController {
  var homeworkList = <HomeworkModel>[].obs;

  // TODO: Firestore integration

  int get pendingCount => homeworkList.where((h) => !h.isCompleted).length;
  int get completedCount => homeworkList.where((h) => h.isCompleted).length;
  double get progressPercent =>
      homeworkList.isEmpty ? 0 : completedCount / homeworkList.length;

  void addHomework(HomeworkModel homework) {
    homeworkList.add(homework);
    // TODO: Add to Firestore
  }

  void markAsCompleted(String id) {
    final index = homeworkList.indexWhere((h) => h.id == id);
    if (index != -1) {
      homeworkList[index].isCompleted = true;
      homeworkList.refresh();
      // TODO: Update in Firestore
    }
  }

  void deleteHomework(String id) {
    homeworkList.removeWhere((h) => h.id == id);
    // TODO: Delete from Firestore
  }
}
