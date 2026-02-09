import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyarios/core/constants.dart';
import 'package:nyarios/core/controllers/language/language_controller.dart';
import 'package:nyarios/core/widgets/toolbar.dart';
import 'package:nyarios/core/l10n/app_localizations.dart';
import 'package:nyarios/ui/language/widgets/language_item.dart';

class LanguageSettingScreen extends ConsumerWidget {
  const LanguageSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(languageControllerProvider);

    return Scaffold(
      appBar: Toolbar.defaultToolbar(
        context,
        AppLocalizations.of(context)!.language,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final language = languages[index];
          return LanguageItem(
            title: language["language"] ?? "",
            selected: language["code"] == controller.value,
            onTap: () {
              ref
                  .read(languageControllerProvider.notifier)
                  .changeLanguage(language["code"] ?? "en");
            },
          );
        },
        itemCount: languages.length,
      ),
    );
  }
}
