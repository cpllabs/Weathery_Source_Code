import 'package:flutter/material.dart';

Color primaryBackgroundColor = const Color(0xFF0A0E21);
Color primaryForegroundColor = const Color(0xFF1D1E33);
Color secondaryForegroundColor = const Color(0xFF111328);
Color primaryTextColor = Colors.white;
Color secondaryTextColor = const Color(0xFF8D8E98);
Color buttonColor = const Color(0xFFEB1555);

ThemeData mainTheme = ThemeData(
  fontFamily: "PT Sans",
  brightness: Brightness.dark,
  primaryColor: primaryBackgroundColor,
  appBarTheme: AppBarTheme(backgroundColor: primaryBackgroundColor),
  scaffoldBackgroundColor: primaryBackgroundColor,
);

TextStyle headingStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 35,
);

TextStyle captionStyle = TextStyle(
  color: secondaryTextColor,
  fontWeight: FontWeight.w400,
  fontSize: 20,
);
