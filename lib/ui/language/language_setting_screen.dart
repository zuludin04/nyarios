import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/widgets/toolbar.dart';
import '../../services/storage_services.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  int selectedLanguage = StorageServices.to.selectedLanguage == 'en_US' ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar.defaultToolbar(context, 'Language'),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return LanguageItem(
            title: languages[index],
            selected: selectedLanguage == index,
            onTap: () {
              StorageServices.to.selectedLanguage =
                  index == 0 ? 'en_US' : 'id_ID';
              setState(() {
                selectedLanguage = index;
              });
            },
          );
        },
        itemCount: languages.length,
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  final String title;
  final bool selected;
  final Function() onTap;

  const LanguageItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        Icons.check,
        color:
            selected ? Theme.of(context).iconTheme.color : Colors.transparent,
      ),
      onTap: onTap,
    );
  }
}
