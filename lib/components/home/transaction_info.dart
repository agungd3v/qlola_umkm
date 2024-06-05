import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';

class TransactionInfo extends StatefulWidget {
  const TransactionInfo({super.key});

  @override
  State<TransactionInfo> createState() => _TransactionInfoState();
}

class _TransactionInfoState extends State<TransactionInfo> {
  Future getHistory() async {
    final httpRequest = await owner_transaction();
    if (httpRequest["status"] == 200) {
      return httpRequest;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Waiting connection...");
        }
        if (snapshot.data != null) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penjualan ${getThisMonth()}",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 4.w
                      )
                    ),
                    Text(
                      transformPrice(double.parse(snapshot.data["transaction_nominal_month"].toString())),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 5.w
                      )
                    )
                  ]
                )
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Penjualan hari ini",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 4.w
                      )
                    ),
                    Text(
                      transformPrice(double.parse(snapshot.data["transaction_nominal_today"].toString())),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 5.w
                      )
                    )
                  ]
                )
              )
            ]
          );
        }
        return Text("Error connection...");
      }
    );
  }
}