import 'package:flutter/material.dart';
import 'package:flutter_application_7/brand_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessDialog extends StatelessWidget {
  late final String status;

  ProcessDialog(this.status);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                height: 5,
              ),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                status,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
