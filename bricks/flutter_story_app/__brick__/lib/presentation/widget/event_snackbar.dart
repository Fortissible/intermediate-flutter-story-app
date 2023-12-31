import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventSnackBar {
  final BuildContext context;
  final String content;

  const EventSnackBar({
    required this.context,
    required this.content
  });

  void showSaveFilterSnackBar(){
    final snackBar = SnackBar(
      content: Center(
        child: Text(
          content,
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.normal
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF44F2B),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}