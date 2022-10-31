import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/empty.png', width: 80),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
