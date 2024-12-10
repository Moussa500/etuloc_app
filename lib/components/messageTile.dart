import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String name;
  const MessageTile({
    super.key,
    required this.name,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset("assets/images/profile.png"),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 25,
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}
