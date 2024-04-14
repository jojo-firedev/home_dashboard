import 'package:flutter/material.dart';

class LightIndicator extends StatelessWidget {
  final bool isLightOn; // State of the light

  const LightIndicator({super.key, required this.isLightOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isLightOn ? Colors.green : Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
