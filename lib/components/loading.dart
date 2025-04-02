import 'package:demo_project/utils/default_colors.dart';
import 'package:flutter/material.dart';

class Loading {
  
  static getLoading(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DefaultColors.bgGray(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: DefaultColors.valueGray(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
