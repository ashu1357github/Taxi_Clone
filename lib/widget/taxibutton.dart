import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Taxibutton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  Taxibutton(
    this.title,
    this.onPressed,
    this.color,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
