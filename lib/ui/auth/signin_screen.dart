import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/core/services/google_signin_service.dart';
import 'package:nyarios/routes/app_routes.dart';
import 'package:nyarios/ui/auth/permission_request_dialog.dart';
import 'package:nyarios/ui/auth/signin_controller.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInControllerProvider);
    ref.listen(signInControllerProvider.select((value) => value), (prev, next) {
      if (next.value!.successLogin) {
        context.go(AppPages.home);
      } else if (next.value!.message.isNotEmpty) {
        context.pop();
        Flushbar(message: next.value!.message).show(context);
      }
    });

    return Scaffold(
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome_message,
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
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => PermissionRequestDialog(
                                onPermissionAccepted: () async {
                                  final googleAuth = await signInGoogle();
                                  ref
                                      .read(signInControllerProvider.notifier)
                                      .signIn(
                                        googleAuth.accessToken,
                                        googleAuth.idToken,
                                      );
                                },
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStatePropertyAll(
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                          child: state.when(
                            data: (data) => state.value!.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/google.png',
                                        width: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.get_started,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                            error: (_, _) => SizedBox(),
                            loading: () => SizedBox(),
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
}
