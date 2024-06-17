import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color? color;
  final String text;
  final bool isSquare;
  final double size;

  const Indicator({
    super.key,
    required this.text,
    required this.isSquare,
    this.color,
    this.size = 16
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: "Poppins",
            color: Theme.of(context).primaryColorDark,
            fontSize: 12
          ),
        ))
      ],
    );
  }
}