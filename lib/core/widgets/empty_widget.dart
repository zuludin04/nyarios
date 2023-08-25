import 'package:flutter/material.dart';
import 'package:nyarios/core/widgets/image_asset.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final String asset;

  const EmptyWidget({
    super.key,
    required this.message,
    this.asset = 'assets/empty.png',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageAsset(assets: asset, size: 80),
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
