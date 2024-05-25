import 'package:flutter/material.dart';
import 'package:qlola_umkm/utils/global_function.dart';

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
                child: Image.asset("assets/icons/transaction.png", width: 25, height: 25)
              ),
              const SizedBox(height: 5),
              Text(
                transformPrice(double.parse(widget.item["grand_total"])),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Poppins",
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
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColorDark
            )
          ),
          subtitle: Text(
            transformDate(widget.item["created_at"]),
            style: TextStyle(
              fontFamily: "Poppins",
              color: Theme.of(context).disabledColor
            )
          ),
          children: [
            for (var index2 = 0; index2 < widget.item["checkouts"].length; index2++) Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: Theme.of(context).dividerColor,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item["checkouts"][index2]["product"]["product_name"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 13
                    )
                  ),
                  Row(
                    children: [
                      Text(
                        transformPrice(double.parse(widget.item["checkouts"][index2]["total"])),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                          fontSize: 12
                        )
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "(x${widget.item["checkouts"][index2]["quantity"]})",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                          fontSize: 10
                        )
                      ),
                    ]
                  )
                ]
              )
            )
          ]
        ))
      ]
    );
  }
}