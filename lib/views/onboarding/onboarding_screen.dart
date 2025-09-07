import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/onboarding_controller.dart';
import '../../app/themes.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.onboardingData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              PageView.builder(
                controller: pageController,
                onPageChanged: (index) => controller.goToPage(index),
                itemCount: controller.onboardingData.length,
                physics: PageScrollPhysics(), // Only allow swipe, disable tap
                itemBuilder: (context, index) {
                  final data = controller.onboardingData[index];
                  return OnboardingPage(
                    title: data['title'] ?? '',
                    description: data['description'] ?? '',
                    icon: data['icon'] ?? 'school',
                    isAnimated: data['isAnimated'] ?? false,
                    isLast: index == controller.onboardingData.length - 1,
                    isGetStarted: data['isGetStarted'] ?? false,
                    onNext: () {
                      if (index < controller.onboardingData.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    onFinish: () => controller.finishOnboarding(),
                  );
                },
              ),

              // Skip button
              if (controller.currentPage.value <
                  controller.onboardingData.length - 1)
                Positioned(
                  top: 20,
                  right: 20,
                  child: TextButton(
                    onPressed: () => controller.finishOnboarding(),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: AppThemes.color1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              // Page indicators
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: controller.currentPage.value == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: controller.currentPage.value == index
                            ? AppThemes.color1
                            : AppThemes.color1.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String icon;
  final bool isAnimated;
  final bool isLast;
  final bool isGetStarted;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isAnimated,
    required this.isLast,
    required this.isGetStarted,
    required this.onNext,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Start animations
    _fadeController.forward();
    if (widget.isAnimated) {
      _bounceController.repeat(reverse: true);
    } else {
      _bounceController.forward();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'folder_special':
        return Icons.folder_special;
      case 'analytics':
        return Icons.analytics;
      case 'rocket_launch':
        return Icons.rocket_launch;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon or Lottie Animation
            ScaleTransition(
              scale: _bounceAnimation,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: widget.isGetStarted
                      ? Colors.transparent
                      : AppThemes.color1.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: widget.isGetStarted
                    ? Lottie.asset(
                        'assets/Kids Learning From Home.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        repeat: true,
                        animate: true,
                      )
                    : TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: widget.isAnimated ? value * 0.1 : 0,
                            child: Icon(
                              _getIconData(widget.icon),
                              size: 100,
                              color: AppThemes.color1,
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 60),

            // Title with slide animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(_fadeController),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.color1,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Description with slide animation
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(_fadeController),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 80),

            // Action Button
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.7),
                end: Offset.zero,
              ).animate(_fadeController),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppThemes.color1, AppThemes.color2],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemes.color1.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: widget.isLast ? widget.onFinish : widget.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.isGetStarted ? 'Get Started 🚀' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
