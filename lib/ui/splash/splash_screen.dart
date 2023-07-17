import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyarios/data/repositories/profile_repository.dart';

import '../../routes/app_pages.dart';
import '../../services/language_service.dart';
import '../../services/storage_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final ProfileRepository repository = ProfileRepository();

  @override
  void initState() {
    Get.updateLocale(LanguageService.deviceLocale);
    splashTime();

    WidgetsBinding.instance.addObserver(this);
    repository.updateOnlineStatus(true);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      repository.updateOnlineStatus(true);
    } else {
      repository.updateOnlineStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset("assets/logo.png", width: 100),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/my_icon.png',
                  width: 32,
                ),
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
