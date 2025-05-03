import 'package:flutter/material.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeTransactionDaily extends StatefulWidget {
  dynamic item;

  EmployeeTransactionDaily({super.key,
    required this.item
  });

  @override
  State<EmployeeTransactionDaily> createState() => _EmployeeTransactionDailyState();
}

class _EmployeeTransactionDailyState extends State<EmployeeTransactionDaily> {
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
                transformPrice(double.parse(widget.item["grand_total"].toString())),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
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
            widget.item["transaction_code"],
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark,
              fontSize: 14
            )
          ),
          subtitle: Text(
            transformDate(widget.item["checkouts"][0]["created_at"]),
            style: GoogleFonts.roboto(
              color: Theme.of(context).disabledColor
            )
          ),
          children: [
            if ((widget.item as Map).containsKey("checkouts")) for (var index2 = 0; index2 < widget.item["checkouts"].length; index2++) ExpansionItem(widget.item["checkouts"][index2], false),
            if ((widget.item as Map).containsKey("others")) for (var index2 = 0; index2 < widget.item["others"].length; index2++) ExpansionItem(widget.item["others"][index2], true)
          ]
        ))
      ]
    );
  }

  Widget ExpansionItem(item, bool isOther) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: Theme.of(context).dividerColor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isOther ? item["product_name"] : item["product"]["product_name"],
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: Theme.of(context).primaryColorDark,
              fontSize: 14
            )
          ),
          Row(
            children: [
              Text(
                transformPrice(double.parse(item["total"].toString())),
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 12
                )
              ),
              const SizedBox(width: 5),
              Text(
                "(x${item["quantity"]})",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 12
                )
              ),
            ]
          )
        ]
      )
    );
  }
}