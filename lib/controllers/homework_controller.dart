import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/homework_model.dart';

class HomeworkController extends GetxController {
  var homeworkList = <HomeworkModel>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadHomework();
  }

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _homeworkCollection =>
      _firestore.collection('users').doc(_userId).collection('homeworks');

  int get pendingCount => homeworkList.where((h) => !h.isCompleted).length;
  int get completedCount => homeworkList.where((h) => h.isCompleted).length;
  double get progressPercent =>
      homeworkList.isEmpty ? 0 : completedCount / homeworkList.length;

  Future<void> loadHomework() async {
    if (_userId == null) return;

    try {
      isLoading.value = true;
      _homeworkCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            homeworkList.value = snapshot.docs
                .map(
                  (doc) => HomeworkModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList();
          });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load homework: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHomework(HomeworkModel homework) async {
    if (_userId == null) return;

    try {
      await _homeworkCollection.add(homework.toMap());
      Get.snackbar('Success', 'Homework added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add homework: $e');
    }
  }

  Future<void> markAsCompleted(String id) async {
    if (_userId == null) return;

    try {
      await _homeworkCollection.doc(id).update({'isCompleted': true});
      Get.snackbar('Great!', 'Homework marked as completed! 🎉');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update homework: $e');
    }
  }

  Future<void> deleteHomework(String id) async {
    if (_userId == null) return;

    try {
      await _homeworkCollection.doc(id).delete();
      Get.snackbar('Deleted', 'Homework removed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete homework: $e');
    }
  }

  Future<void> updateHomework(String id, Map<String, dynamic> updates) async {
    if (_userId == null) return;

    try {
      await _homeworkCollection.doc(id).update(updates);
      Get.snackbar('Updated', 'Homework updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update homework: $e');
    }
  }
}
