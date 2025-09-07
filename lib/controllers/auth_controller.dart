import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();

  var isLoading = false.obs;
  Rx<User?> firebaseUser = Rx<User?>(null);
  bool _isNavigating = false;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  bool get isOnboardingCompleted => box.read('onboarding_completed') ?? false;

  _setInitialScreen(User? user) {
    // Prevent multiple navigation attempts
    if (_isNavigating) return;

    // Only navigate if onboarding is completed and we're not already on the correct screen
    if (isOnboardingCompleted) {
      final currentRoute = Get.currentRoute;

      // Add delay to prevent rapid navigation loops
      Future.delayed(Duration(milliseconds: 500), () {
        if (_isNavigating) return;

        _isNavigating = true;

        if (user == null &&
            currentRoute != '/login' &&
            currentRoute != '/register') {
          Get.offAllNamed('/login');
        } else if (user != null && currentRoute != '/home') {
          Get.offAllNamed('/home');
        }

        // Reset navigation flag after a delay
        Future.delayed(Duration(seconds: 2), () {
          _isNavigating = false;
        });
      });
    }
  }

  // Create or update user document in Firestore
  Future<void> createUserDocument(User user) async {
    try {
      print('Attempting to create user document for: ${user.email}');

      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

      Map<String, dynamic> userData = {
        'email': user.email,
        'displayName': user.displayName ?? '',
        'photoURL': user.photoURL ?? '',
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      // Use set with merge to create or update the document
      await userDoc.set({
        ...userData,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Successfully created/updated user document for ${user.email}');

      // Don't show snackbar here, let the calling method handle success messages
    } catch (e) {
      print('❌ Error creating/updating user document: $e');

      // Re-throw the error so calling method can handle it
      throw e;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;

      print('Attempting to sign in with email: $email');

      // First clear any existing auth state
      if (_auth.currentUser != null) {
        await _auth.signOut();
        await Future.delayed(Duration(milliseconds: 500));
      }

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (result.user != null) {
        print('✅ Login successful for user: ${result.user!.email}');

        try {
          // Create/update user document in Firestore
          await createUserDocument(result.user!);

          Get.snackbar(
            'Success',
            'Logged in successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Small delay to ensure auth state is updated
          await Future.delayed(Duration(milliseconds: 500));

          // Auto-navigate to home after successful login
          Get.offAllNamed('/home');
        } catch (firestoreError) {
          print('❌ Firestore error during login: $firestoreError');

          // Still allow login even if Firestore fails
          Get.snackbar(
            'Partial Success',
            'Logged in, but profile sync failed. Continuing...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );

          // Navigate to home anyway
          Get.offAllNamed('/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      String errorMessage = 'An error occurred';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Login failed';
      }

      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } catch (e) {
      print('General login error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;
      print('Creating new user account for: $email');

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (result.user != null) {
        print('✅ Firebase Auth account created successfully');

        try {
          // Create user document in Firestore
          await createUserDocument(result.user!);

          Get.snackbar(
            'Success',
            'Account created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Auto-navigate to home after successful signup
          Get.offAllNamed('/home');
        } catch (firestoreError) {
          print('❌ Firestore error but auth succeeded: $firestoreError');

          // Since auth succeeded, navigate to home anyway
          // The user document will be created by the homework controller
          Get.snackbar(
            'Success',
            'Account created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Get.offAllNamed('/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');

      String errorMessage = 'Registration failed';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'This email is already registered. Please login instead.';
          break;
        case 'weak-password':
          errorMessage =
              'Password is too weak. Please use a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = e.message ?? 'Registration failed';
      }

      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } catch (e) {
      print('❌ General registration error: $e');

      // Check if user was actually created despite the error
      if (_auth.currentUser != null) {
        print(
          'User was created successfully despite error, navigating to home',
        );
        Get.offAllNamed('/home');
        return;
      }

      // Only show error if registration actually failed
      Get.snackbar(
        'Error',
        'Something went wrong during registration. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _auth.signOut();

      // Clear any cached data
      firebaseUser.value = null;

      // Force navigation to login
      Get.offAllNamed('/login');

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error signing out: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to force reset auth state when permission errors occur
  Future<void> resetAuthState() async {
    try {
      print('Resetting auth state...');

      // Sign out completely
      await _auth.signOut();

      // Clear local auth state
      firebaseUser.value = null;

      // Small delay to ensure state is cleared
      await Future.delayed(Duration(milliseconds: 500));

      // Navigate to login
      Get.offAllNamed('/login');

      Get.snackbar(
        'Session Reset',
        'Please login again to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      print('Error resetting auth state: $e');
    }
  }

  String? get currentUserId => _auth.currentUser?.uid;
  User? get currentUser => _auth.currentUser;
}
