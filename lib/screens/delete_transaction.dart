import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';

class DeleteTransactionScreen extends StatefulWidget {
  const DeleteTransactionScreen({super.key});

  @override
  State<DeleteTransactionScreen> createState() => _DeleteTransactionScreenState();
}

class _DeleteTransactionScreenState extends State<DeleteTransactionScreen> {
  final code = TextEditingController(text: "");

  Map? transaction = null;
  bool loading = false;
  bool loading_delete = false;

  Future _searchTransaction(BuildContext context) async {
    setState(() => loading = true);

    final httpRequest = await search_transaction(code.text);
    if (httpRequest["status"] == 200) {
      setState(() => transaction = httpRequest["data"]);
    } else {
      setState(() => transaction = null);
      errorMessage(context, "Informasi", httpRequest["message"]);
    }

    setState(() => loading = false);
  }

  Future _deleteTransaction(BuildContext context) async {
    setState(() => loading_delete = true);

    final httpRequest = await delete_transaction(transaction!["id"]);
    debugPrint(transaction!["id"].toString());
    if (httpRequest["status"] == 200) {
      setState(() {
        transaction = null;
        code.text = "";
      });
      successMessage(context, "Informasi", httpRequest["message"]);
    } else {
      errorMessage(context, "Informasi", httpRequest["message"]);
    }

    setState(() => loading_delete = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          )
        )
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    width: 40,
                    child: Image.asset("assets/icons/arrow_back_white.png", width: 4.5.w, height: 4.5.w)
                  )
                ),
                Text(
                  "Hapus Transaksi",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 3.6.w
                  )
                ),
              ]
            )
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Masukan kode transaksi",
                      hintStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).disabledColor,
                        fontSize: 12
                      )
                    ),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12
                    ),
                    cursorColor: Theme.of(context).focusColor,
                    controller: code,
                  )
                )),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _searchTransaction(context),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(
                      child: loading ? LoadingAnimationWidget.fourRotatingDots(color: Colors.white, size: 22) : Image.asset("assets/icons/search_white.png", width: 20, height: 20)
                    )
                  )
                )
              ]
            )
          ),
          if (transaction != null) Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.all(Radius.circular(4))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/icons/transaction.png", width: 25, height: 25),
                    const SizedBox(width: 8),
                    Text(
                      transaction!["transaction_code"],
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600
                      )
                    )
                  ]
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grand Total",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          )
                        ),
                        Text(
                          transformPrice(double.parse(transaction!["grand_total"].toString())),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700
                          )
                        )
                      ]
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transaksi di buat",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          )
                        ),
                        Text(
                          transformDate(transaction!["created_at"]),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700
                          )
                        )
                      ]
                    )
                  ]
                ),
                const SizedBox(height: 30),
                if (loading_delete) Container(
                  width: double.infinity,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Proses...",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 12
                        )
                      )
                    ]
                  )
                ),
                if (!loading_delete) GestureDetector(
                  onTap: () => _deleteTransaction(context),
                  child: Container(
                    width: double.infinity,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    child: Text(
                      "Hapus Transaksi",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 12
                      )
                    )
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}