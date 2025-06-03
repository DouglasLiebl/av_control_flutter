import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String title;
  final String subtitle;
  final AsyncCallback onPress;
  final Icon icon;

  const Item({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPress,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DefaultColors.bgGray(),
      elevation: 0,
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: DefaultTypography.optionItem()
        ),
        subtitle: Text(
          subtitle,
          style: DefaultTypography.optionItem()  
        ),
        onTap: () async {
          await onPress();
        }
      )
    );
  }
}