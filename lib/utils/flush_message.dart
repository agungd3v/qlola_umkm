import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future successMessage(BuildContext context, title, message) {
  return Flushbar(
    backgroundColor: Theme.of(context).primaryColor,
    duration: Duration(seconds: 3),
    reverseAnimationCurve: Curves.fastOutSlowIn,
    flushbarPosition: FlushbarPosition.TOP,
    titleText: Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 12
      )
    ),
    messageText: Text(
      message,
      style: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 12
      )
    ),
  ).show(context);
}

Future errorMessage(BuildContext context, title, message) {
  return Flushbar(
    backgroundColor: Color(0xFFE5484D),
    duration: Duration(seconds: 3),
    reverseAnimationCurve: Curves.fastOutSlowIn,
    flushbarPosition: FlushbarPosition.TOP,
    titleText: Text(
      title,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 12
      )
    ),
    messageText: Text(
      message,
      style: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 12
      )
    ),
  ).show(context);
}