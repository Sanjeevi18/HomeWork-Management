import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/validators.dart';
import '../../widgets/animated_learning_icon.dart';
import '../../app/themes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppThemes.color1),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Floating background elements
            FloatingBookIcon(
              position: Offset(30, 80),
              color: AppThemes.color3,
              size: 20,
            ),
            FloatingBookIcon(
              position: Offset(320, 120),
              color: AppThemes.color5,
              size: 25,
            ),
            FloatingBookIcon(
              position: Offset(60, 250),
              color: AppThemes.color2,
              size: 18,
            ),
            FloatingBookIcon(
              position: Offset(300, 350),
              color: AppThemes.color4,
              size: 22,
            ),

            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      AppBar().preferredSize.height -
                      48,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Animated Logo
                      Center(
                        child: AnimatedLearningIcon(
                          size: 100,
                          color: AppThemes.color2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.color1,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Sign up to start managing your homework',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Email field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemes.color1.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: AppThemes.color1),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppThemes.color1,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemes.color1.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: Validators.validatePassword,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: AppThemes.color1),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppThemes.color1,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemes.color1.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (value) =>
                              Validators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: AppThemes.color1),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppThemes.color1,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1.withOpacity(0.3),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1.withOpacity(0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: AppThemes.color1,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Register button
                      Obx(
                        () => Container(
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppThemes.color2, AppThemes.color1],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppThemes.color2.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : () => _register(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: AppThemes.color1,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      authController.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
  }
}
