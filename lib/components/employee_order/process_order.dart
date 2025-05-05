import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessOrder extends StatefulWidget {
  dynamic item;

  ProcessOrder({super.key,
    required this.item
  });

  @override
  State<ProcessOrder> createState() => _ProcessOrderState();
}

class _ProcessOrderState extends State<ProcessOrder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => inspect(widget.item),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.asset("assets/icons/order.png", width: 90, height: 90),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    // minimumSize: const Size.fromHeight(28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0
                  ),
                  child: Icon(Icons.print, color: Colors.white, size: 24)
                )
              ]
            ),
            SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1),
                Text(
                  widget.item["transaction_code"],
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  )
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0
                      ),
                      child: Text(
                        "Batalkan",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )
                      )
                    )),
                    SizedBox(width: 8),
                    Expanded(child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0
                      ),
                      child: Text(
                        "Selesaikan",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )
                      )
                    ))
                  ]
                )
              ]
            ))
          ]
        )
      )
    );
  }
}