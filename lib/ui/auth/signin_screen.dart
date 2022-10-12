import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/helper.dart';
import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';
import 'auth_input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Hi, Welcome Back!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Hello again, you\'ve been missed',
                  style: TextStyle(color: Colors.black45),
                ),
                const SizedBox(height: 32),
                AuthInputField(
                  label: 'Email Address',
                  controller: emailController,
                  hint: 'Enter your email',
                  validator: emailValidator,
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  label: 'Password',
                  controller: passwordController,
                  hint: 'Enter your password',
                  validator: passwordValidator,
                  obscure: true,
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password?'),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.home);
                      StorageServices.to.alreadyLogin = true;
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 12)),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 74),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(
                            color: Color.fromRGBO(251, 127, 107, 1),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.toNamed(AppRoutes.signUp),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      debugPrint('success login ${credential.user?.email}');

      Get.offAllNamed(AppRoutes.home);
      StorageServices.to.alreadyLogin = true;
    } on FirebaseAuthException catch (e) {
      debugPrint('error firebase login ${e.code}');
    } catch (e) {
      debugPrint('error ${e.toString()}');
    }
  }
}
