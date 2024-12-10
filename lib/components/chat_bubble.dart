import 'package:etuloc/components/colors.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {
      super.key,
      required this.message,
      required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                color: isCurrentUser ? myPrimaryColor : Colors.grey.shade500,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(8),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 25),
            )),
      ),
    );
  }
}
