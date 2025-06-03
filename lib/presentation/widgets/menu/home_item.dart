import 'package:demo_project/domain/entity/aviary.dart';
import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:demo_project/presentation/widgets/tags/status_tags.dart';
import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget{
  final Aviary aviary;
  final VoidCallback onPress;

  const HomeItem({
    super.key,
    required this.aviary,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: DefaultColors.borderGray(),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      child: ListTile(
        leading: Icon(Icons.home_work),
        title: aviary.activeAllotmentId != null 
          ? StatusTags.getActiveTag(aviary.alias) 
          : StatusTags.getInactiveTag(aviary.alias),
        subtitle: Text(
          aviary.name,
          style: DefaultTypography.aviaryName()
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 15,),
        onTap: onPress
      )
    ); 
  }
}