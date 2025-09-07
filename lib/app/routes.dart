import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/homework/homework_list.dart';

class AppRoutes {
  static const initial = '/onboarding';

  static final pages = [
    GetPage(
      name: '/onboarding',
      page: () => OnboardingScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingController());
      }),
    ),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/home', page: () => HomeworkListScreen()),
  ];
}
