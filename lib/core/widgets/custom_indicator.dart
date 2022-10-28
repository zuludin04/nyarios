import 'package:flutter/material.dart';

import '../../services/storage_services.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          StorageServices.to.darkMode ? Colors.white : Colors.black),
    );
  }
}
