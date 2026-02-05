import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/splash/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    splashTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(splashControllerProvider);
    controller.whenData((value) {
      if (value.isAlreadyLogin) {
        context.go(AppPages.home);
      } else {
        context.go(AppPages.signIn);
      }
    });

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Image.asset("assets/logo.png", width: 100)),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/my_icon.png', width: 32),
                Text(
                  '\t by Zulfikar Mauludin',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void splashTime() {
    var duration = const Duration(seconds: 1);
    Timer(duration, () {
      ref.read(splashControllerProvider.notifier).loadScreen();
    });
  }
}
