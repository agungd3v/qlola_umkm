import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';

class EmployeeTransactionToday extends StatefulWidget {
  const EmployeeTransactionToday({super.key});

  @override
  State<EmployeeTransactionToday> createState() => _EmployeeTransactionTodayState();
}

class _EmployeeTransactionTodayState extends State<EmployeeTransactionToday> {
  dynamic transaction;

  Future getHistory() async {
    final httpRequest = await outlet_transaction();
    if (httpRequest["status"] == 200) {
      setState(() {
        transaction = httpRequest;
      });
    }
  }

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (transaction != null) Text(
            transformPrice(double.parse(transaction["transaction_nominal_today"].toString())),
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 5.w
            )
          ),
          if (transaction == null) Text(
            transformPrice(0),
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 5.w
            )
          )
        ]
      )
    );
  }
}