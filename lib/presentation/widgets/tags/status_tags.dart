import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/presentation/style/default_typography.dart';
import 'package:flutter/material.dart';

class StatusTags {

  static Row getActiveTag(String alias) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          alias,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: DefaultColors.activeBgGreen(),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
            child: Center(
            child: Text(
                "Ativo",  
                style: DefaultTypography.activeTag()
              ),
            ),  
          )
        )
        
      ],
    );
  }

  static Row getInactiveTag(String alias) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          alias,
          style: DefaultTypography.aliasText()
        ),
        Container(
          decoration: BoxDecoration(
            color: DefaultColors.inactiveBgRed(),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10.0, top: 2.0, right: 10.0, bottom: 2.0),
            child: Center(
            child: Text(
                "Inativo",  
                style: DefaultTypography.inactiveTag()
              ),
            ),  
          )
        )
        
      ],
    );
  }
}