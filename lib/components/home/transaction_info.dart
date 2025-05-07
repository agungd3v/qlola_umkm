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
    final httpRequest = await owner_summary();
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
            margin: const EdgeInsets.only(top: 50),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              )
            )
          );
        }
        if (snapshot.data != null) {
          return Column(
            children: [
              _buildTransactionCard(
                icon: Container(
                  width: 80,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Icon(Icons.payments, color: Colors.white, size: 40),
                  )
                ),
                title: "Penjualan ${getThisMonth()}",
                amount: snapshot.data["transaction_success_month"],
              ),  
              const SizedBox(height: 12),
              _buildTransactionCard(
                icon: Container(
                  width: 80,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Icon(Icons.payments, color: Colors.white, size: 35),
                  )
                ),
                title: "Penjualan Hari ini",
                amount: snapshot.data["transaction_success_today"],
              ),
              const SizedBox(height: 12),
              _buildTransactionCard(
                icon: Container(
                  width: 80,
                  color: Theme.of(context).primaryColorDark,
                  child: Center(
                    child: Icon(Icons.list_alt, color: Colors.white, size: 40),
                  )
                ),
                title: "Order Disimpan Hari ini",
                amount: snapshot.data["transaction_pending_today"],
              ),
              const SizedBox(height: 12),
              _buildTransactionCard(
                icon: Container(
                  width: 80,
                  color: Color(0xFFE5484D),
                  child: Center(
                    child: Icon(Icons.playlist_remove_outlined, color: Colors.white, size: 40),
                  )
                ),
                title: "Order Cancel Hari ini",
                amount: snapshot.data["transaction_void_today"],
              ),
            ]
          );
        }
        return Center(
          child: Text(
            "Error connection...",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 4.w,
              color: Color(0xFFE5484D),
            )
          )
        );
      }
    );
  }

  Widget _buildTransactionCard({required String title, required dynamic amount, required Widget icon}) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: Theme.of(context).dividerColor),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            icon,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      transformPrice(amount),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 20,
                      )
                    )
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}
