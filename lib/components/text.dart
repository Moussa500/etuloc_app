import 'package:etuloc/components/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String label;
  Header({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
          color: myTitlesColor, fontSize: 30, fontWeight: FontWeight.w400),
    );
  }
}
