import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/homework_model.dart';
import '../app/themes.dart';

class HomeworkController extends GetxController {
  var homeworkList = <HomeworkModel>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    // Add a small delay before loading homework to allow auth state to stabilize
    Future.delayed(Duration(milliseconds: 2000), () {
      if (_userId != null) {
        loadHomework();
      }
    });
  }

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _homeworkCollection {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(_userId).collection('homeworks');
  }

  // Test Firebase connectivity
  Future<bool> testFirebaseConnection() async {
    try {
      // Try to enable network first
      await _firestore.enableNetwork();

      // Simple connectivity test - try to read the user's own document
      if (_userId != null) {
        await _firestore
            .collection('users')
            .doc(_userId)
            .get(GetOptions(source: Source.server));
      }

      return true;
    } catch (e) {
      print('Firebase connection test failed: $e');

      // Try to re-enable network and test again
      try {
        await _firestore.disableNetwork();
        await Future.delayed(Duration(milliseconds: 500));
        await _firestore.enableNetwork();

        // Second attempt
        if (_userId != null) {
          await _firestore
              .collection('users')
              .doc(_userId)
              .get(GetOptions(source: Source.server));
        }

        return true;
      } catch (retryError) {
        print('Firebase reconnection failed: $retryError');
        return false;
      }
    }
  }

  int get pendingCount => homeworkList.where((h) => !h.isCompleted).length;
  int get completedCount => homeworkList.where((h) => h.isCompleted).length;
  double get progressPercent =>
      homeworkList.isEmpty ? 0 : completedCount / homeworkList.length;

  // Ensure user document exists in Firestore
  Future<void> _ensureUserDocumentExists() async {
    try {
      if (_userId == null) return;

      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No authenticated user found');
        return;
      }

      DocumentReference userDoc = _firestore.collection('users').doc(_userId);

      // Try to create the user document directly instead of checking if it exists
      // This approach avoids permission denied errors when the document doesn't exist
      try {
        await userDoc.set(
          {
            'email': currentUser.email,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLoginAt': FieldValue.serverTimestamp(),
            'displayName': currentUser.displayName ?? '',
            'photoURL': currentUser.photoURL ?? '',
          },
          SetOptions(merge: true),
        ); // Use merge to avoid overwriting existing data

        print('✅ User document created/updated successfully');
      } catch (setError) {
        print('Error creating user document: $setError');

        // If we can't create the document, there might be a permissions issue
        // Try to get the document to see if it exists
        try {
          DocumentSnapshot userSnapshot = await userDoc.get();
          if (userSnapshot.exists) {
            print('User document exists but couldn\'t update it');
          } else {
            print(
              'User document doesn\'t exist and can\'t be created - permissions issue',
            );
          }
        } catch (getError) {
          print('Can\'t read or create user document: $getError');
        }
      }
    } catch (e) {
      print('Error ensuring user document exists: $e');
    }
  }

  Future<void> loadHomework() async {
    if (_userId == null) {
      print('User not authenticated - waiting for auth state to stabilize');
      return;
    }

    try {
      isLoading.value = true;

      // Check if user document exists, create if not
      await _ensureUserDocumentExists();

      // Enable network and test connection
      await _firestore.enableNetwork();

      _homeworkCollection
          .orderBy('createdAt', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen(
            (snapshot) {
              try {
                // Check if data is from cache or server
                if (snapshot.metadata.isFromCache) {
                  print('Loading homework from cache');
                } else {
                  print('Loading homework from server');
                }

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
                // Remove snackbar to avoid showing error after successful login
                // Get.snackbar(
                //   'Error',
                //   'Failed to load homework data: ${e.toString()}',
                //   backgroundColor: Colors.red,
                //   colorText: Colors.white,
                // );
              }
            },
            onError: (error) {
              print('Firestore stream error: $error');
              isLoading.value = false;

              if (error.toString().contains('permission-denied')) {
                // Only reset auth state if user is actually null and it's been a while
                Future.delayed(Duration(seconds: 10), () {
                  if (_auth.currentUser == null &&
                      Get.currentRoute != '/login') {
                    print('Permission denied - user appears to be logged out');
                    // Don't show error message, just silently redirect to login
                    Get.offAllNamed('/login');
                  }
                });
              } else {
                // Don't show connection errors during login flow
                // Only log them for debugging
                print('Connection error (not showing snackbar): $error');
              }
            },
          );
    } catch (e) {
      print('Firestore loadHomework Error: $e');
      // Don't show error messages during normal login flow
      // Only log them for debugging purposes
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

    // Ensure user document exists before adding homework
    await _ensureUserDocumentExists();

    await _addHomeworkWithRetry(homework, maxRetries: 3);
  }

  Future<void> _addHomeworkWithRetry(
    HomeworkModel homework, {
    int maxRetries = 3,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        isLoading.value = true;

        print('Homework add attempt $attempt of $maxRetries');

        // Create homework data
        final homeworkData = {
          'title': homework.title,
          'description': homework.description,
          'dueDate': Timestamp.fromDate(homework.dueDate),
          'isCompleted': homework.isCompleted,
          'createdAt': Timestamp.fromDate(homework.createdAt),
        };

        print('Adding homework for user: $_userId');
        print('Homework data: $homeworkData');

        // Try to add with timeout
        await _homeworkCollection
            .add(homeworkData)
            .timeout(
              Duration(seconds: 10),
              onTimeout: () {
                throw Exception('Request timed out after 10 seconds');
              },
            );

        // Success!
        isLoading.value = false; // Reset loading state on success

        // Close any open dialogs/bottom sheets and navigate to homework list
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }

        // Ensure we're on the homework list screen
        Get.offAllNamed('/home');

        // Reload homework list to show the new homework
        await loadHomework();

        // Show success message
        Get.snackbar(
          'Success',
          'Homework added successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        return; // Exit the retry loop on success
      } catch (e) {
        print('Attempt $attempt failed: $e');

        if (attempt == maxRetries) {
          // Last attempt failed, show error
          String errorMessage =
              'Failed to add homework after $maxRetries attempts. ';

          if (e.toString().toLowerCase().contains('network') ||
              e.toString().toLowerCase().contains('unavailable') ||
              e.toString().toLowerCase().contains('internet')) {
            errorMessage +=
                'Please check your internet connection and try again.';
          } else if (e.toString().toLowerCase().contains('permission') ||
              e.toString().toLowerCase().contains('denied')) {
            errorMessage +=
                'Permission denied. Please try logging out and back in.';
          } else if (e.toString().toLowerCase().contains('quota')) {
            errorMessage += 'Storage quota exceeded.';
          } else if (e.toString().toLowerCase().contains('timeout')) {
            errorMessage += 'Request timed out. Please try again.';
          } else {
            errorMessage += 'Error: ${e.toString()}';
          }

          Get.snackbar(
            'Network Error',
            errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
          );
        } else {
          // Wait before retry
          await Future.delayed(Duration(seconds: attempt));

          // Show retry message
          Get.snackbar(
            'Retrying...',
            'Attempt $attempt failed, retrying in ${attempt + 1} seconds...',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        }
      }
    }

    isLoading.value = false;
  }

  Future<void> markAsCompleted(String id) async {
    if (_userId == null) return;

    try {
      await _homeworkCollection.doc(id).update({'isCompleted': true});
      Get.snackbar(
        'Great!',
        'Homework marked as completed! 🎉',
        backgroundColor: AppThemes.color2,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: () {
            Get.closeCurrentSnackbar();
            markAsPending(id);
          },
          child: Text(
            'UNDO',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update homework: $e');
    }
  }

  Future<void> markAsPending(String id) async {
    if (_userId == null) return;

    try {
      await _homeworkCollection.doc(id).update({'isCompleted': false});
      Get.snackbar(
        'Undone',
        'Homework marked as pending',
        backgroundColor: AppThemes.color1,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
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
      // Convert DateTime to Timestamp if present
      Map<String, dynamic> processedUpdates = Map.from(updates);
      if (processedUpdates.containsKey('dueDate') &&
          processedUpdates['dueDate'] is DateTime) {
        processedUpdates['dueDate'] = Timestamp.fromDate(
          processedUpdates['dueDate'],
        );
      }

      await _homeworkCollection.doc(id).update(processedUpdates);
      Get.snackbar(
        'Updated',
        'Homework updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update homework: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Clear all homework data (used during logout)
  void clearData() {
    try {
      homeworkList.clear();
      isLoading.value = false;
      print('Homework data cleared');
    } catch (e) {
      print('Error clearing homework data: $e');
    }
  }
}
