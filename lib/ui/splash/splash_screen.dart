import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/nyarios_repository.dart';
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
  final NyariosRepository repository = NyariosRepository();

  @override
  void initState() {
    Get.updateLocale(LanguageService.deviceLocale);
    splashTime();

    WidgetsBinding.instance.addObserver(this);
    repository.updateOnlineStatus("Online");
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      repository.updateOnlineStatus("Online");
    } else {
      repository.updateOnlineStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Logo'),
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
