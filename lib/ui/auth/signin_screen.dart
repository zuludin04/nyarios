import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../services/storage_services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset('assets/logo.png', width: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'Nyarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Make your conversation\nmore enjoyable',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 32),
                    Image.asset('assets/background.png'),
                    const SizedBox(height: 32),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                width: 24,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Get Started',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    try {
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: emailController.text,
      //   password: passwordController.text,
      // );

      // debugPrint('success login ${credential.user?.email}');

      // Get.offAllNamed(AppRoutes.home);
      // StorageServices.to.alreadyLogin = true;
    } on FirebaseAuthException catch (e) {
      debugPrint('error firebase login ${e.code}');
    } catch (e) {
      debugPrint('error ${e.toString()}');
    }
  }
}
