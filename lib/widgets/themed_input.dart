import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants/colors.dart';

class ThemedInput extends StatelessWidget {
  const ThemedInput(
      {super.key,
      required this.onChanged,
      this.obscureText = false,
      required this.hintText,
      this.suffixIcon});
  final Function(String value) onChanged;
  final bool obscureText;
  final String hintText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      style: const TextStyle(color: hintColor),
      decoration: InputDecoration(
          focusColor: secondColor,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 30),
          border: InputBorder.none,
          filled: true,
          hintStyle: const TextStyle(fontSize: 13),
          fillColor: canvasColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
          suffixIcon: suffixIcon),
    );
  }
}
