import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared visual language for the app: colors, fonts, and reusable
/// decorations so screens stop redefining their own styling ad hoc.
class AppTheme {
  AppTheme._();

  // Per-topic accent colors, reused for cards, app bars, and buttons
  // wherever that topic is shown.
  static const Color colors = Colors.pink;
  static const Color numbers = Colors.blue;
  static const Color letters = Colors.deepOrange;
  static const Color shapes = Colors.green;
  static const Color animals = Colors.brown;
  static const Color stories = Colors.purple;

  static const Color background = Color(0xFFFFF8F0);

  static TextStyle heading({double fontSize = 28, Color color = Colors.white}) =>
      GoogleFonts.baloo2(fontSize: fontSize, fontWeight: FontWeight.bold, color: color);

  static TextStyle title({double fontSize = 22, Color color = Colors.black87}) =>
      GoogleFonts.baloo2(fontSize: fontSize, fontWeight: FontWeight.bold, color: color);

  static TextStyle body({double fontSize = 18, Color color = Colors.black87, FontWeight weight = FontWeight.normal}) =>
      GoogleFonts.comicNeue(fontSize: fontSize, color: color, fontWeight: weight);

  static BoxDecoration card(Color color, {double radius = 24}) => BoxDecoration(
        color: color.withOpacity(0.95),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static ButtonStyle pillButton(Color color) => ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        elevation: 4,
      );
}
