import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class EmployeeTransactionToday extends StatefulWidget {
  const EmployeeTransactionToday({super.key});

  @override
  State<EmployeeTransactionToday> createState() => _EmployeeTransactionTodayState();
}

class _EmployeeTransactionTodayState extends State<EmployeeTransactionToday> {
  Future? future;

  Future getHistory() async {
    final httpRequest = await outlet_transaction();
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
          return Text(
            transformPrice(0),
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 20
            )
          );
        }
        if (snapshot.data != null) {
          return Text(
            transformPrice(double.parse(snapshot.data["transaction_nominal_today"].toString())),
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 20
            )
          );
        }
        return Text(
          transformPrice(0),
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 20
          )
        );
      }
    );
  }
}