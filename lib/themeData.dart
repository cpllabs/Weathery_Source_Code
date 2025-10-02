import 'package:flutter/material.dart';

Color primaryBackgroundColor = const Color(0xFF0A0E21);
Color primaryForegroundColor = const Color(0xFF1D1E33);
Color secondaryForegroundColor = const Color(0xFF111328);
Color primaryTextColor = Colors.white;
Color secondaryTextColor = Color(0xFF8D8E98);
Color buttonColor = const Color(0xFFEB1555);

ThemeData mainTheme = ThemeData(
  useMaterial3: false,
  snackBarTheme: SnackBarThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 5,
      backgroundColor: buttonColor,
      contentTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      )),
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
