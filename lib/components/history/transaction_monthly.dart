import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/history/transaction_item.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionMonthly extends StatefulWidget {
  TransactionMonthly({super.key});

  @override
  State<TransactionMonthly> createState() => _TransactionMonthlyState();
}

class _TransactionMonthlyState extends State<TransactionMonthly> {
  List data = [];
  bool loading = true;

  Future _getHistory() async {
    setState(() {
      loading = true;
    });

    final httpRequest = await owner_transaction();
    if (httpRequest["status"] == 200) {
      setState(() {
        data = httpRequest["monthly_transactions"];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Center(
      child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
    ) : data.isEmpty ? _emptyData() : _notEmptyData();
  }

  Widget _notEmptyData() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          for (var index = 0; index < data.length; index++) TransactionItem(transaction: data[index], isDaily: true),
          const SizedBox(height: 6)
        ]
      )
    );
  }

  Widget _emptyData() {
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
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 16
                )
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 320,
                child: Text(
                  'Oops... belum ada transaksi di bulan ini',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 14
                  )
                )
              )
            ]
          )
        ]
      )
    );
  }
}