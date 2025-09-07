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
        'assets/Kids Learning From Home.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract onboarding screens from JSON
      if (jsonData.containsKey('onboarding')) {
        onboardingData.value = List<Map<String, dynamic>>.from(
          jsonData['onboarding'],
        );
      } else {
        // Default onboarding data if JSON doesn't have it
        onboardingData.value = [
          {
            "title": "Manage Your Homework",
            "description":
                "Keep track of all your assignments and never miss a deadline again.",
            "image": "assets/images/homework1.png",
          },
          {
            "title": "Stay Organized",
            "description":
                "Organize your tasks by subject and priority to boost your productivity.",
            "image": "assets/images/homework2.png",
          },
          {
            "title": "Track Progress",
            "description":
                "Monitor your progress and celebrate your achievements.",
            "image": "assets/images/homework3.png",
          },
          {
            "title": "Get Started",
            "description":
                "Ready to take control of your homework? Let's begin!",
            "image": "assets/images/homework4.png",
          },
        ];
      }
    } catch (e) {
      print('Error loading onboarding data: $e');
      // Use default data if JSON loading fails
      onboardingData.value = [
        {
          "title": "Manage Your Homework",
          "description":
              "Keep track of all your assignments and never miss a deadline again.",
          "image": "assets/images/homework1.png",
        },
        {
          "title": "Stay Organized",
          "description":
              "Organize your tasks by subject and priority to boost your productivity.",
          "image": "assets/images/homework2.png",
        },
        {
          "title": "Track Progress",
          "description":
              "Monitor your progress and celebrate your achievements.",
          "image": "assets/images/homework3.png",
        },
        {
          "title": "Get Started",
          "description": "Ready to take control of your homework? Let's begin!",
          "image": "assets/images/homework4.png",
        },
      ];
    }
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
