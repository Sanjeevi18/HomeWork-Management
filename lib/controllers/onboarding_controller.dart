import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final box = GetStorage();
  var currentPage = 0.obs;
  var onboardingData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOnboardingData();
  }

  Future<void> loadOnboardingData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/onboarding_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract onboarding screens from JSON
      if (jsonData.containsKey('onboarding')) {
        onboardingData.value = List<Map<String, dynamic>>.from(
          jsonData['onboarding'],
        );
      } else {
        _setDefaultOnboardingData();
      }
    } catch (e) {
      print('Error loading onboarding data: $e');
      _setDefaultOnboardingData();
    }
  }

  void _setDefaultOnboardingData() {
    onboardingData.value = [
      {
        "title": "Welcome to Homework Manager",
        "description":
            "Your personal homework assistant that helps you stay organized and never miss a deadline again.",
        "icon": "school",
        "isAnimated": true,
      },
      {
        "title": "Stay Organized",
        "description":
            "Organize your assignments by subject, priority, and due dates to boost your productivity.",
        "icon": "folder_special",
        "isAnimated": false,
      },
      {
        "title": "Track Your Progress",
        "description":
            "Monitor your completion rates and celebrate your achievements with visual progress indicators.",
        "icon": "analytics",
        "isAnimated": false,
      },
      {
        "title": "Ready to Get Started?",
        "description":
            "Join thousands of students who have transformed their homework management. Let's begin your journey!",
        "icon": "rocket_launch",
        "isAnimated": false,
        "isGetStarted": true,
      },
    ];
  }

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
  }

  void finishOnboarding() {
    box.write('onboarding_completed', true);
    Get.offAllNamed('/login');
  }

  bool get isOnboardingCompleted => box.read('onboarding_completed') ?? false;
}
