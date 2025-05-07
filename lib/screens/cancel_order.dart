import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final reason = TextEditingController(text: "");

  List data = [];
  bool loading = true;
  bool processCancel = false;

  Future _getHistory() async {
    setState(() {
      loading = true;
    });

    final httpRequest = await owner_for_cancel();
    if (httpRequest["status"] == 200) {
      setState(() {
        data = [...httpRequest["transaction_pending_today"], ...httpRequest["transaction_success_today"]];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> cancelProcess(int idTransaction) async {
    setState(() => processCancel = true);

    final request = await cancel_transaction(idTransaction, reason.text);
    if (request["status"] == 200) {
      Future.delayed(Duration(seconds: 1), () => successMessage(context, "Informasi", "Berhasil membatalkan pesanan"));
      _getHistory();
      return true;
    } else {
      errorMessage(context, "Informasi", request["message"]);
      return false;
    }
  }

  void cancelOrder(int idTransaction) {
    setState(() => reason.text = "");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alasan Pembatalan",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    )
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Theme.of(context).dividerColor)
                    ),
                    child: TextField(
                      maxLines: 5,
                      controller: reason,
                      style: GoogleFonts.roboto(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "Alasan...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                      ),
                      cursorColor: Theme.of(context).primaryColor,
                    )
                  ),
                  SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () async {
                      if (processCancel) return;
                      setState(() => processCancel = true);
                      final process = await cancelProcess(idTransaction);
                      if (process) Navigator.pop(context);
                      setState(() => processCancel = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0
                    ),
                    child: Column(
                      children: [
                        if (processCancel) Text(
                          "Batalkan...",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        if (!processCancel) Text(
                          "Batalkan",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )
                        )
                      ]
                    )
                  )
                ]
              )
            )
          );
        });
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 42, bottom: 12, left: 20, right: 14),
                      child: Image.asset("assets/icons/arrow_back_white.png", width: 16, height: 16)
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 42, bottom: 12),
                    child: Text(
                      "Cancel Order",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 4.5.w
                      )
                    )
                  )
                ]
              )
            ),
            if (loading) Container(
              margin: const EdgeInsets.only(top: 100),
              child: Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
              )
            ),
            if (!loading && data.isEmpty) Expanded(child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Icon(Icons.note_alt, color: useColor("danger"), size: 80),
                  SizedBox(height: 8),
                  Text(
                    "Data tidak ditemukan",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 16
                    )
                  )
                ]
              )
            )),
            if (!loading && data.isNotEmpty) SingleChildScrollView(child: Column(
              children: [
                SizedBox(height: 20),
                for (var index = 0; index < data.length; index++) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(
                            data[index]["transaction_code"],
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).primaryColor
                            )
                          )),
                          Row(
                            children: [
                              Icon(Icons.lock_clock, size: 20, color: useColor("danger")),
                              Text(
                                data[index]["updated_at"].toString().split(" ")[1],
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                                )
                              )
                            ]
                          )
                        ]
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            for (var index2 = 0; index2 < (data[index]["checkouts"] as List).length; index2++) Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Expanded(child: Text(
                                    data[index]["checkouts"][index2]["product"]["product_name"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto()
                                  )),
                                  Text(
                                    "${data[index]["checkouts"][index2]["quantity"]}x ${transformPrice(data[index]["checkouts"][index2]["total"])}",
                                    style: GoogleFonts.roboto()
                                  )
                                ]
                              )
                            ),
                            for (var index3 = 0; index3 < (data[index]["others"] as List).length; index3++) Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Expanded(child: Text(
                                    data[index]["others"][index3]["product_name"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto()
                                  )),
                                  Text(
                                    "${data[index]["others"][index3]["quantity"]}x ${transformPrice(data[index]["others"][index3]["total"])}",
                                    style: GoogleFonts.roboto()
                                  )
                                ]
                              )
                            )
                          ]
                        )
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () => cancelOrder(data[index]["id"]),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            backgroundColor: Theme.of(context).primaryColor,
                            minimumSize: const Size.fromHeight(40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 0
                          ),
                          child: Text(
                            "Batalkan",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            )
                          )
                        )
                      )
                    ]
                  )
                ),
                SizedBox(height: 20)
              ]
            ))
          ]
        )
      )
    );
  }
}
