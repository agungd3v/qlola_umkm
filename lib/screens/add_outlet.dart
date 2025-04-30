import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:sizer/sizer.dart';

class AddOutletScreen extends StatefulWidget {
  const AddOutletScreen({super.key});

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  final outletName = TextEditingController();
  final outletPhone = TextEditingController();
  final outletAddress = TextEditingController();
  bool proccess = false;

  Future<void> _addoutlet() async {
    final Map<String, dynamic> data = {
      "outlet_name": outletName.text,
      "outlet_phone": "+62${outletPhone.text}",
      "outlet_address": outletAddress.text
    };

    setState(() => proccess = true);

    final httpRequest = await add_outlet(data);
    if (httpRequest["status"] == 200) {
      // Pop dan kirimkan true untuk memperbarui data di OutletScreen
      Navigator.pop(context, true);

      return Flushbar(
        backgroundColor: Color(0xff00880d),
        duration: Duration(seconds: 5),
        reverseAnimationCurve: Curves.fastOutSlowIn,
        flushbarPosition: FlushbarPosition.TOP,
        titleText: Text("Informasi",
            style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 12)),
        messageText: Text("Berhasil menambahkan outlet baru",
            style: TextStyle(
                fontFamily: "Poppins", color: Colors.white, fontSize: 12)),
      ).show(context);
    }

    setState(() => proccess = false);

    Flushbar(
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 5),
      reverseAnimationCurve: Curves.fastOutSlowIn,
      flushbarPosition: FlushbarPosition.TOP,
      titleText: Text("Informasi",
          style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12)),
      messageText: Text(httpRequest["message"],
          style: TextStyle(
              fontFamily: "Poppins", color: Colors.white, fontSize: 12)),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark))),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
                child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Theme.of(context).dividerColor))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Image.asset(
                                    "assets/icons/arrow_back_gray.png",
                                    width: 4.5.w,
                                    height: 4.5.w))),
                        const SizedBox(width: 6),
                        Text("Tambah Outlet",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 3.6.w))
                      ])),
              Expanded(
                  child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Informasi Outlet",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 3.6.w)),
                                  const SizedBox(height: 14),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .dividerColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: TextField(
                                        decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            hintText: "Nama outlet",
                                            hintStyle: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize: 3.w)),
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 3.w),
                                        cursorColor:
                                            Theme.of(context).focusColor,
                                        controller: outletName,
                                      )),
                                  const SizedBox(height: 12),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .dividerColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: Row(children: [
                                        Text("+62",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontSize: 3.w)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: TextField(
                                          decoration: InputDecoration(
                                              isDense: true,
                                              border: InputBorder.none,
                                              hintText: "No. Handphone",
                                              hintStyle: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontSize: 3.w)),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: 3.w),
                                          keyboardType: TextInputType.number,
                                          cursorColor:
                                              Theme.of(context).focusColor,
                                          controller: outletPhone,
                                        ))
                                      ])),
                                  const SizedBox(height: 12),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .dividerColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                      child: TextField(
                                        decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            hintText:
                                                "Detail Alamat (Optional)",
                                            hintStyle: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize: 3.w)),
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 3.w),
                                        cursorColor:
                                            Theme.of(context).focusColor,
                                        controller: outletAddress,
                                      ))
                                ])),
                        const SizedBox(height: 20)
                      ]))),
              if (!proccess)
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _addoutlet();
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save, // Ikon save
                                color: Colors.white,
                                size: 20, // Ukuran ikon
                              ),
                              const SizedBox(
                                  width:
                                      8), // Memberikan jarak antara ikon dan teks
                              Text(
                                "Simpan",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ))),
              if (proccess)
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.fourRotatingDots(
                                color: Colors.white,
                                size: 22,
                              ),
                              const SizedBox(width: 5),
                              Text("Proses Simpan...",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white))
                            ])))
            ]))));
  }
}
