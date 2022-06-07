// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: CupertinoColors.white,
    brightness: Brightness.dark,
    backgroundColor: CupertinoColors.lightBackgroundGray.withAlpha(215),
    primaryColor: CupertinoColors.systemPink,
    textSelectionColor: Colors.black
    
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: CupertinoColors.black,
    brightness: Brightness.light,
    backgroundColor: CupertinoColors.darkBackgroundGray.withAlpha(215),
    primaryColor: CupertinoColors.systemPink,
    textSelectionColor: Colors.white,
    
  );
}
