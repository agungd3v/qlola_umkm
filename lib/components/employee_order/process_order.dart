import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:qlola_umkm/utils/printer.dart';

class ProcessOrder extends StatefulWidget {
  dynamic item;

  ProcessOrder({super.key,
    required this.item
  });

  @override
  State<ProcessOrder> createState() => _ProcessOrderState();
}

class _ProcessOrderState extends State<ProcessOrder> {
  bool processCancel = false;
  bool processConfirm = false;

  final reason = TextEditingController(text: "");

  Future<bool> cancelProcess() async {
    setState(() => processCancel = true);

    final request = await cancel_transaction(widget.item["id"] as int, reason.text);
    if (request["status"] == 200) {
      successMessage(context, "Informasi", "Berhasil membatalkan pesanan");
      return true;
    } else {
      errorMessage(context, "Informasi", request["message"]);
      return false;
    }
  }

  Future<bool> confirmProcess() async {
    final request = await confirm_transaction(widget.item["id"] as int);
    if (request["status"] == 200) {
      successMessage(context, "Informasi", "Berhasil menyelesaikan pesanan");

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await generateStruck(widget.item, authProvider, widget.item["transaction_code"]);
      // final struck = await generateStruck(widget.item, authProvider, widget.item["transaction_code"]);

      // if (!struck["status"]) {
      //   errorMessage(context, "Bluetooth print", struck["message"]);
      // } else {
      //   successMessage(context, "Bluetooth print", "Resi sebentar lagi siap 🥣");
      // }

      return true;
    } else {
      errorMessage(context, "Informasi", request["message"]);
      return false;
    }

  }

  void cancelOrder() {
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
                      final process = await cancelProcess();
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

  void confirmOrder() {
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
                    "Penyelesaian Order",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    )
                  ),
                  SizedBox(height: 26),
                  Text(
                    widget.item["transaction_code"],
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    transformPrice(widget.item["grand_total"]),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () async {
                      if (processConfirm) return;
                      setState(() => processConfirm = true);
                      final process = await confirmProcess();
                      if (process) Navigator.pop(context);
                      setState(() => processConfirm = false);
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
                        if (processConfirm) Text(
                          "Selesaikan...",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                        if (!processConfirm) Text(
                          "Selesaikan",
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

  Future printStruck() async {
    // setState(() => processBluetoothPrint = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final struck = await generateStruckKichen(widget.item, authProvider, "-");

    if (!struck["status"]) {
      errorMessage(context, "Bluetooth print", struck["message"]);
      // setState(() => processBluetoothPrint = false);
    } else {
      successMessage(context, "Bluetooth print", "Resi sebentar lagi siap 🥣");
      // setState(() => processBluetoothPrint = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(
                widget.item["transaction_code"],
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColorDark
                )
              )),
              Text(
                "#${widget.item["ordering"]}",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).primaryColorDark
                )
              )
            ]
          ),
          SizedBox(height: 8),
          Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
              )
            )
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset("assets/icons/order.png", width: 90, height: 90),
                  ElevatedButton(
                    onPressed: () => printStruck(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0
                    ),
                    child: Icon(Icons.print, color: Colors.white, size: 24)
                  )
                ]
              ),
              SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(
                        "Sub Total:",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark
                        )
                      )),
                      Expanded(child: Text(
                        transformPrice(widget.item["grand_total"]),
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColorDark
                        )
                      )),
                    ]
                  ),
                  SizedBox(height: 10),
                  for (var index = 0; index < (widget.item["checkouts"] as List).length; index++) Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text(
                          "${widget.item["checkouts"][index]["product"]["product_name"]} x${widget.item["checkouts"][index]["quantity"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorDark
                          )
                        )),
                        SizedBox(width: 6),
                        Text(
                          transformPrice(widget.item["checkouts"][index]["total"]),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorDark
                          )
                        )
                      ],
                    )
                  ),
                  for (var index = 0; index < (widget.item["others"] as List).length; index++) Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text(
                          "${widget.item["others"][index]["product_name"]} x ${widget.item["others"][index]["quantity"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorDark
                          )
                        )),
                        SizedBox(width: 6),
                        Text(
                          transformPrice(widget.item["others"][index]["total"]),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorDark
                          )
                        )
                      ]
                    )
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: ElevatedButton(
                        onPressed: () => cancelOrder(),
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
                      )),
                      SizedBox(width: 8),
                      Expanded(child: ElevatedButton(
                        onPressed: () => confirmOrder(),
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
                          "Selesaikan",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )
                        ) 
                      ))
                    ]
                  )
                ]
              ))
            ]
          )
        ]
      )
    );
  }
}