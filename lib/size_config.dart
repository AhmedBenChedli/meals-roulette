import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

late double width;
late double height;

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;
  static bool wideScreen = false;
  static bool extraWideScreen = false;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    wideScreen = false;
    extraWideScreen = false;
    if (screenHeight / screenWidth < 1.62 &&
        screenHeight / screenWidth > 1.55) {
      screenWidth = screenWidth / 1.20;
      wideScreen = false;
    } else if (screenHeight / screenWidth <= 1.55 &&
        screenHeight / screenWidth > 1.3) {
      screenWidth = screenWidth / 1.25;
      wideScreen = false;
    } else if (screenHeight / screenWidth <= 1.3 &&
        screenHeight / screenWidth > 1.2) {
      screenWidth = (screenWidth / 1.9) * (screenHeight / screenWidth);
      wideScreen = true;
    } else if (screenHeight / screenWidth <= 1.2) {
      screenWidth = (screenWidth / 2.2) * (screenHeight / screenWidth);
      wideScreen = true;
      extraWideScreen = true;
    }
    width = screenWidth;
    height = screenHeight;
  }
}
