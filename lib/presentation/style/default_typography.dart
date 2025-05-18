import 'package:demo_project/presentation/style/default_colors.dart';
import 'package:demo_project/utils/device_dimensions_utils.dart';
import 'package:flutter/material.dart';

class DefaultTypography {
  static double responsiveFontSize(double fontSize) {
    final double screenWidth = DeviceDimensions.screenWidth;
    const double baseWidthResolution = 428.0;

    double scaleFactor = screenWidth / baseWidthResolution;
    scaleFactor = scaleFactor.clamp(0.7, 1.3);

    return fontSize * scaleFactor;
  }

  static TextStyle tableRowLabel() {
    return TextStyle(
      color: DefaultColors.valueGray(),
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle tableRowValue() {
    return TextStyle(
      color: DefaultColors.textGray(),
      fontWeight: FontWeight.w500,
      fontSize: 14,
      fontFamily: "JetBrains Mono"
    );
  }

}