import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      backgroundColor: const Color(0xfff7f7f7),
      colorScheme: const ColorScheme(
        primary: Color.fromRGBO(251, 127, 107, 1),
        primaryContainer: Color(0xfffb7f6b),
        secondary: Color(0xfffb7f6b),
        secondaryContainer: Color(0xfffb7f6b),
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
              MaterialStateProperty.all<Color>(const Color(0xfffb7f6b)),
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
        secondary: Color(0xffffa400),
        secondaryContainer: Color(0xffc67500),
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
              MaterialStateProperty.all<Color>(const Color(0xfffb7f6b)),
        ),
      ),
    );
  }
}
