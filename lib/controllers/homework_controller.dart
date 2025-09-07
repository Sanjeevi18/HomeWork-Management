import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  // Test Firebase connectivity
  Future<bool> testFirebaseConnection() async {
    try {
      await _firestore.enableNetwork();
      // Test if we can read/write to Firestore
      await _firestore.collection('test').doc('connection_test').set({
        'timestamp': Timestamp.now(),
        'userId': _userId,
      });
      // Clean up test document
      await _firestore.collection('test').doc('connection_test').delete();
      return true;
    } catch (e) {
      print('Firebase connection test failed: $e');
      return false;
    }
  }

  int get pendingCount => homeworkList.where((h) => !h.isCompleted).length;
  int get completedCount => homeworkList.where((h) => h.isCompleted).length;
  double get progressPercent =>
      homeworkList.isEmpty ? 0 : completedCount / homeworkList.length;

  Future<void> loadHomework() async {
    if (_userId == null) {
      print('User not authenticated');
      return;
    }

    try {
      isLoading.value = true;
      _homeworkCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
            try {
              homeworkList.value = snapshot.docs
                  .map(
                    (doc) => HomeworkModel.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList();
            } catch (e) {
              print('Error parsing homework data: $e');
              Get.snackbar('Error', 'Failed to load homework data');
            }
          });
    } catch (e) {
      print('Firestore loadHomework Error: $e');
      Get.snackbar(
        'Error',
        'Failed to load homework. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHomework(HomeworkModel homework) async {
    if (_userId == null) {
      Get.snackbar('Error', 'Please login first');
      return;
    }

    // Check if user is still authenticated
    if (_auth.currentUser == null) {
      Get.snackbar('Error', 'Session expired. Please login again.');
      return;
    }

    try {
      isLoading.value = true;

      // Test Firebase connection first
      bool isConnected = await testFirebaseConnection();
      if (!isConnected) {
        throw Exception('No internet connection or Firebase unavailable');
      }

      // Create a map without the id field since Firestore will generate it
      final homeworkData = {
        'title': homework.title,
        'description': homework.description,
        'dueDate': Timestamp.fromDate(homework.dueDate),
        'isCompleted': homework.isCompleted,
        'createdAt': Timestamp.fromDate(homework.createdAt),
      };

      print('Adding homework for user: $_userId'); // Debug log
      print('Homework data: $homeworkData'); // Debug log

      await _homeworkCollection.add(homeworkData);
      Get.snackbar(
        'Success',
        'Homework added successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Firestore Error: $e'); // Debug log
      String errorMessage = 'Failed to add homework. ';

      if (e.toString().toLowerCase().contains('network') ||
          e.toString().toLowerCase().contains('unavailable') ||
          e.toString().toLowerCase().contains('internet')) {
        errorMessage += 'Please check your internet connection and try again.';
      } else if (e.toString().toLowerCase().contains('permission') ||
          e.toString().toLowerCase().contains('denied')) {
        errorMessage +=
            'Permission denied. Please try logging out and back in.';
      } else if (e.toString().toLowerCase().contains('quota')) {
        errorMessage += 'Storage quota exceeded.';
      } else if (e.toString().toLowerCase().contains('timeout')) {
        errorMessage += 'Request timed out. Please try again.';
      } else {
        errorMessage += 'Please try again later. Error: ${e.toString()}';
      }

      Get.snackbar(
        'Network Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
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
