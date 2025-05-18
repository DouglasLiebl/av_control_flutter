import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String text;

  const CardTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: "JetBrains Mono",
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}