import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

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
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
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
            Theme.of(context).primaryColor, // Dark Red
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
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            transformPrice(double.parse(amount.toString())),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
