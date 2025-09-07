import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/homework_controller.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_page.dart';
import '../views/homework/homework_list.dart';
import '../views/profile/profile_screen.dart';

class AppRoutes {
  static String get initial {
    final box = GetStorage();
    final isOnboardingCompleted = box.read('onboarding_completed') ?? false;
    return isOnboardingCompleted ? '/login' : '/onboarding';
  }

  static final pages = [
    GetPage(
      name: '/onboarding',
      page: () => OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingController());
      }),
    ),
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: '/register',
      page: () => const RegisterPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
    GetPage(
      name: '/home',
      page: () => HomeworkListScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
        Get.lazyPut(() => HomeworkController());
      }),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),
  ];
}
