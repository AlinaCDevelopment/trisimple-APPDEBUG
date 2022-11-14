import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants/colors.dart';

class ThemedButton extends StatelessWidget {
  const ThemedButton(
      {super.key, required this.onTap, required this.text, this.color});

  final VoidCallback onTap;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: color ?? secondColor),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
    );
  }
}
