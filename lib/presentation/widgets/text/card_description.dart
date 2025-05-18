import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:flutter/material.dart';

class CardDescription extends StatelessWidget {
  final String text;

  const CardDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Container(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "JetBrains Mono",
            color: DefaultColors.subTitleGray(),
            fontSize: 15
          ),
          textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}