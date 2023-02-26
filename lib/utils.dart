import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle(double size, [Color? color, FontWeight? fontWeight]) {
  return GoogleFonts.montserrat(
      fontSize: size, color: color, fontWeight: fontWeight);
}
