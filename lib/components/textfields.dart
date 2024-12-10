import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/device_dimensions.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool? obscured;
  final Icon? icon;
  final double? customwidth;
  final void Function(String)? onChanged;
  final Widget? suffix;
  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.icon,
    this.customwidth,
    this.onChanged,
    this.obscured,
    this.suffix,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.customwidth != null
          ? widget.customwidth
          : Dimensions.deviceWidth(context) * .7,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.all(style: BorderStyle.none),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 3), blurRadius: 6, color: myShadowColor),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 9),
          child: TextField(
            textDirection: TextDirection.ltr,
            controller: widget.controller,
            onChanged: widget.onChanged,
            obscureText: widget.obscured == null ? false : true,
            decoration: InputDecoration(
              suffix: widget.suffix,
              prefixIcon: widget.icon,
              hintText: widget.label,
              hintStyle: const TextStyle(fontSize: 20),
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
    );
  }
}
