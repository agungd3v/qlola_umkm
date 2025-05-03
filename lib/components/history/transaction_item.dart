import "dart:developer";

import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionItem extends StatefulWidget {
  dynamic transaction;
  bool isDaily;

  TransactionItem({super.key,
    required this.transaction,
    this.isDaily = false
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool loading = false;

  Future _deleteItem(num transaction_id, num item_id) async {
    setState(() => loading = true);
    final data = {
      "transaction_id": transaction_id,
      "item_id": item_id
    };

    final httpRequest = await delete_item_transaction(data);
    if (httpRequest["status"] == 200) {
      successMessage(context, "Informasi", httpRequest["message"]);
      setState(() => loading = false);
      return;
    }

    setState(() => loading = false);
    errorMessage(context, "informasi", httpRequest["message"]);
  }

  @override
  void initState() {
    super.initState();
    inspect(widget.transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Icon(Icons.wallet, size: 30, color: Theme.of(context).primaryColor)
              ),
              const SizedBox(height: 5),
              Text(
                transformPrice(double.parse(widget.transaction["grand_total"].toString())),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                  fontSize: 10
                )
              )
            ]
          )
        ),
        Expanded(child: ExpansionTile(
          dense: true,
          shape: Border(),
          title: Text(
            widget.transaction["checkouts"][0]["outlet"]["outlet_name"],
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark,
              fontSize: 14
            )
          ),
          subtitle: Text(
            "${transformDate(widget.transaction["checkouts"][0]["created_at"])} | ${widget.transaction["transaction_code"]}",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: Theme.of(context).disabledColor
            )
          ),
          children: [
            if ((widget.transaction as Map).containsKey("checkouts")) for (var index2 = 0; index2 < widget.transaction["checkouts"].length; index2++) Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: Theme.of(context).dividerColor,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transaction["checkouts"][index2]["product"]["product_name"],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 14
                        )
                      ),
                      Row(
                        children: [
                          Text(
                            transformPrice(double.parse(widget.transaction["checkouts"][index2]["total"].toString())),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                              fontSize: 12
                            )
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "(x${widget.transaction["checkouts"][index2]["quantity"].toString()})",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                              fontSize: 12
                            )
                          )
                        ]
                      )
                    ]
                  ),
                  const SizedBox(width: 8),
                  // if (loading) Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.all(Radius.circular(4))
                  //   ),
                  //   child: LoadingAnimationWidget.fourRotatingDots(
                  //     color: Colors.white,
                  //     size: 14,
                  //   ),
                  // ),
                  // if (!loading) GestureDetector(
                  //   onTap: () {
                  //     _deleteItem(
                  //       widget.transaction["id"],
                  //       widget.transaction["checkouts"][index2]["id"]
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: BorderRadius.all(Radius.circular(4))
                  //     ),
                  //     child: Text(
                  //       "Hapus",
                  //       style: TextStyle(
                  //         fontFamily: "Poppins",
                  //         color: Colors.white,
                  //         fontSize: 10
                  //       )
                  //     )
                  //   )
                  // )
                ]
              )
            ),
            if ((widget.transaction as Map).containsKey("others")) for (var index2 = 0; index2 < widget.transaction["others"].length; index2++) Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: Theme.of(context).dividerColor,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transaction["others"][index2]["product_name"],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 14
                        )
                      ),
                      Row(
                        children: [
                          Text(
                            transformPrice(double.parse(widget.transaction["others"][index2]["total"].toString())),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                              fontSize: 12
                            )
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "(x${widget.transaction["others"][index2]["quantity"].toString()})",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                              fontSize: 10
                            )
                          )
                        ]
                      )
                    ]
                  ),
                  const SizedBox(width: 8),
                  // if (loading) Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.all(Radius.circular(4))
                  //   ),
                  //   child: LoadingAnimationWidget.fourRotatingDots(
                  //     color: Colors.white,
                  //     size: 14,
                  //   ),
                  // ),
                  // if (!loading) GestureDetector(
                  //   onTap: () {
                  //     _deleteItem(
                  //       widget.transaction["id"],
                  //       widget.transaction["checkouts"][index2]["id"]
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: BorderRadius.all(Radius.circular(4))
                  //     ),
                  //     child: Text(
                  //       "Hapus",
                  //       style: TextStyle(
                  //         fontFamily: "Poppins",
                  //         color: Colors.white,
                  //         fontSize: 10
                  //       )
                  //     )
                  //   )
                  // )
                ]
              )
            )
          ]
        ))
      ]
    );
  }
}