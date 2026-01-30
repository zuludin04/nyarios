import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:nyarios/routes/app_pages.dart';
import 'package:nyarios/services/language_service.dart';
import 'package:nyarios/services/storage_services.dart';
import 'package:nyarios/ui/splash/provider/splash_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    Get.updateLocale(LanguageService.deviceLocale);
    splashTime();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(splashProviderProvider(true));
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
                  style: Get.textTheme.titleMedium,
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
      var alreadyLogin = StorageServices.to.alreadyLogin;
      if (alreadyLogin) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    });
  }
}
