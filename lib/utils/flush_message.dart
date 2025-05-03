import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future successMessage(BuildContext context, title, message) {
  return Flushbar(
    backgroundColor: Theme.of(context).primaryColor,
    duration: Duration(seconds: 3),
    reverseAnimationCurve: Curves.fastOutSlowIn,
    flushbarPosition: FlushbarPosition.TOP,
    titleText: Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 12
      )
    ),
    messageText: Text(
      message,
      style: TextStyle(
        fontFamily: "Poppins",
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
      style: TextStyle(
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 12
      )
    ),
    messageText: Text(
      message,
      style: TextStyle(
        fontFamily: "Poppins",
        color: Colors.white,
        fontSize: 12
      )
    ),
  ).show(context);
}