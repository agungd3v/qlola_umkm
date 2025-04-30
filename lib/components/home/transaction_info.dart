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
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Colors.redAccent), // Red color loader
            ),
          );
        }
        if (snapshot.data != null) {
          return Column(
            children: [
              _buildTransactionCard(
                title: "Penjualan ${getThisMonth()}",
                amount: snapshot.data["transaction_nominal_month"],
              ),
              const SizedBox(height: 12),
              _buildTransactionCard(
                title: "Penjualan hari ini",
                amount: snapshot.data["transaction_nominal_today"],
              ),
            ],
          );
        }
        return Center(
          child: Text(
            "Error connection...",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 4.w,
              color: Colors.redAccent, // Red color for error text
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required dynamic amount,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade800, // Dark Red
            Colors.black, // Black for gradient effect
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 4.w,
            ),
          ),
          SizedBox(height: 4),
          Text(
            transformPrice(double.parse(amount.toString())),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 5.w,
            ),
          ),
        ],
      ),
    );
  }
}
