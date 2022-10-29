import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      backgroundColor: const Color(0xfff7f7f7),
      colorScheme: const ColorScheme(
        primary: Color(0xffb3404a),
        primaryContainer: Color(0xffb3404a),
        secondary: Color(0xffb3404a),
        secondaryContainer: Color(0xffb3404a),
        surface: Colors.white,
        background: Colors.white,
        error: Colors.redAccent,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Color(0xffcccccc),
        onBackground: Color(0xffcccccc),
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xfff7f7f7),
        elevation: 0.8,
      ),
      fontFamily: 'Nunito',
      iconTheme: const IconThemeData(color: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xffb3404a)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      backgroundColor: const Color(0xff252526),
      colorScheme: const ColorScheme(
        primary: Color(0xff252526),
        primaryContainer: Colors.black,
        secondary: Color(0xffb3404a),
        secondaryContainer: Color(0xffb3404a),
        surface: Color(0xff252526),
        background: Color(0xff252526),
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xff252526),
        elevation: 0.8,
      ),
      fontFamily: 'Nunito',
      iconTheme: const IconThemeData(color: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xffb3404a)),
        ),
      ),
    );
  }
}
