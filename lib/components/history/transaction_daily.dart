import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/history/transaction_item.dart';

class TransactionDaily extends StatefulWidget {
  TransactionDaily({super.key});

  @override
  State<TransactionDaily> createState() => _TransactionDailyState();
}

class _TransactionDailyState extends State<TransactionDaily> {
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
          return Container(
            margin: const EdgeInsets.all(16),
            child: Text("Waiting connection...")
          );
        }
        if (snapshot.data != null) {
          if (snapshot.data["transaction_count_today"] < 1) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/transaction_empty.png", width: 300, height: 200, fit: BoxFit.contain),
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "Belum ada Transaksi",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark
                        )
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 320,
                        child: Text(
                          'Oops... belum ada transaksi di hari ini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12
                          )
                        )
                      )
                    ]
                  )
                ]
              )
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                for (var index = 0; index < snapshot.data["transaction_count_today"]; index++) TransactionItem(
                  transaction: snapshot.data["daily_transactions"][index],
                  isDaily: true
                ),
                const SizedBox(height: 6)
              ]
            )
          );
        }

        return Container(
          margin: const EdgeInsets.all(16),
          child: Text("Error connection...")
        );
      }
    );
  }
}