import 'package:flutter/material.dart';

class PlantTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF77A688),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF77A688),
        secondary: Color(0xFFC8CBAF),
        onPrimary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF77A688),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Color(0xFF4A5240)),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF77A688),
        textTheme: ButtonTextTheme.primary,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: const Color(0xFFC8CBAF).withOpacity(0.5),
        elevation: 5,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF77A688)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF77A688)),
        ),
        labelStyle: TextStyle(color: Color(0xFF4A5240)),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF77A688),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF77A688),
      ),
    );
  }
}
