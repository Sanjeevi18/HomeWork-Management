import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullName = ''.obs;
  var dateOfBirth = ''.obs;
  var school = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  String? get _userId => _auth.currentUser?.uid;

  Future<void> loadUserProfile() async {
    if (_userId == null) return;

    try {
      isLoading.value = true;

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        fullName.value = data['fullName'] ?? '';
        dateOfBirth.value = data['dateOfBirth'] ?? '';
        school.value = data['school'] ?? '';
      }
    } catch (e) {
      print('Error loading user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile({
    String? newFullName,
    String? newDateOfBirth,
    String? newSchool,
  }) async {
    if (_userId == null) return;

    try {
      isLoading.value = true;

      Map<String, dynamic> updates = {};

      if (newFullName != null) {
        updates['fullName'] = newFullName;
        fullName.value = newFullName;
      }

      if (newDateOfBirth != null) {
        updates['dateOfBirth'] = newDateOfBirth;
        dateOfBirth.value = newDateOfBirth;
      }

      if (newSchool != null) {
        updates['school'] = newSchool;
        school.value = newSchool;
      }

      if (updates.isNotEmpty) {
        updates['updatedAt'] = FieldValue.serverTimestamp();

        await _firestore
            .collection('users')
            .doc(_userId)
            .set(updates, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating user profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String get displayName {
    if (fullName.value.isNotEmpty) {
      return fullName.value;
    }

    String? email = _auth.currentUser?.email;
    if (email != null) {
      return email.split('@')[0];
    }

    return 'Student';
  }

  String get displayDateOfBirth {
    return dateOfBirth.value.isEmpty ? 'Not set' : dateOfBirth.value;
  }

  String get displaySchool {
    return school.value.isEmpty ? 'Not set' : school.value;
  }
}
