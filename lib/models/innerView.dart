import 'package:flutter/material.dart';

class InnerView extends StatelessWidget {
  final String name;
  final Widget view;

  const InnerView({super.key, required this.name, required this.view});

  @override
  Widget build(BuildContext context) {
    return view;
  }
}
