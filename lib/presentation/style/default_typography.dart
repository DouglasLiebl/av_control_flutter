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

  static TextStyle loginTitle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle loginDescription() {
    return TextStyle(
      color: DefaultColors.subTitleGray(),
      fontSize: 15,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle appBar() {
    return TextStyle(
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle optionItem() {
    return TextStyle(
      fontFamily: "JetBrains Mono"
    );
  }
  
  static TextStyle countBox() {
    return TextStyle(
      color: DefaultColors.subTitleGray(),
      fontSize: 12,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle countBoxActiveValue() {
    return TextStyle(
      color: Color(0xFF38a169),
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle countBoxValue() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle activeTag() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: DefaultColors.activeGreen(),
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle activeTagTitle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: DefaultColors.valueGray(),
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle inactiveTag() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: DefaultColors.inactiveRed(),
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle aliasText() {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: "JetBrains Mono"
    );
  }

  static TextStyle aviaryName() {
    return TextStyle(
      fontSize: 14,
      color: DefaultColors.textGray(),
      fontFamily: "JetBrains Mono"
    );
  }

}