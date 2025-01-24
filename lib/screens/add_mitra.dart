import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:sizer/sizer.dart';

class AddMitra extends StatefulWidget {
  const AddMitra({super.key});

  @override
  State<AddMitra> createState() => _AddMitraState();
}

class _AddMitraState extends State<AddMitra> {
  AuthProvider? auth_provider;

  final mitraName = TextEditingController();
  final mitraPhone = TextEditingController();
  final mitraEmail = TextEditingController();
  File? imageTemp;
  String? imagePath;
  bool proccess = false;
  String role = '';
  String email = '';
  String password = '';

  Future<void> _addMitra() async {
    final Map<String, dynamic> data = {
      "name": mitraName.text,
      "phone": "+62${mitraPhone.text}",
      "photo": imagePath,
      "email": mitraEmail.text,
      "business_id": _convertToString(auth_provider!.user["business"]["id"]),
      "owner_id": _convertToString(auth_provider!.user["business"]["owner_id"]),
    };

    print(data);
    setState(() => proccess = true);

    final httpRequest = await add_mitra(data);
    if (httpRequest["status"] == 200) {
      Navigator.pop(context);

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
        messageText: Text("Berhasil menambahkan mitra baru",
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

  Future<void> _pickFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageFile = File(image.path);
      setState(() {
        imageTemp = imageFile;
        imagePath = image.path;
      });

      FocusScope.of(context).unfocus();
    } on PlatformException catch (e) {
      inspect("failed pick image: $e");
    }

    Navigator.pop(context);
  }

  String _convertToString(dynamic value) {
    if (value == null) {
      return ""; // or return a default value, or throw an error if null is not acceptable
    }

    if (value is String) {
      return value; // Already a String
    } else if (value is int || value is double) {
      return value.toString(); // Convert int or double to String
    } else {
      // Handle unexpected types if needed
      return ""; // or throw an error
    }
  }

  void _openModalPicture() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(children: [
              const SizedBox(height: 6),
              Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(99)))),
              const SizedBox(height: 24),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Image.asset("assets/icons/camera_red.png",
                            width: 20, height: 20),
                        const SizedBox(width: 12),
                        Text("Kamera",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 12))
                      ]))),
              const SizedBox(height: 10),
              GestureDetector(
                  onTap: () {
                    _pickFromGallery();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: [
                        Image.asset("assets/icons/gallery_red.png",
                            width: 20, height: 20),
                        const SizedBox(width: 12),
                        Text("Pilih dari galeri",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 12))
                      ])))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    auth_provider = Provider.of<AuthProvider>(context);

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
                        Text("Tambah Mitra",
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
                        GestureDetector(
                            onTap: () => _openModalPicture(),
                            child: Container(
                                width: 80,
                                height: 80,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (imageTemp == null)
                                        Image.asset(
                                            "assets/icons/camera_white.png",
                                            width: 24,
                                            height: 24),
                                      if (imageTemp != null)
                                        Image.file(imageTemp!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover)
                                    ]))),
                        const SizedBox(height: 24),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                            hintText: "Email mitra",
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        cursorColor:
                                            Theme.of(context).focusColor,
                                        controller: mitraEmail,
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
                                      child: TextField(
                                        decoration: InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                            hintText: "Nama mitra",
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
                                        controller: mitraName,
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
                                          controller: mitraPhone,
                                        ))
                                      ])),
                                  const SizedBox(height: 2),
                                  Text("Contoh: 82179099557",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize: 2.5.w))
                                ])),
                        const SizedBox(height: 20),
                        Container(
                          height: 10,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        // Container(
                        //   margin: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             "Outlet",
                        //             style: TextStyle(
                        //               fontFamily: "Poppins",
                        //               fontWeight: FontWeight.w700,
                        //               color: Theme.of(context).primaryColorDark
                        //             )
                        //           ),
                        //           GestureDetector(
                        //             onTap: () {},
                        //             child: Container(
                        //               padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        //               decoration: BoxDecoration(
                        //                 color: Theme.of(context).primaryColor,
                        //                 borderRadius: BorderRadius.all(Radius.circular(4))
                        //               ),
                        //               child: Text(
                        //                 "Pilih outlet",
                        //                 style: TextStyle(
                        //                   fontFamily: "Poppins",
                        //                   fontWeight: FontWeight.w700,
                        //                   color: Colors.white,
                        //                   fontSize: 10
                        //                 )
                        //               )
                        //             )
                        //           )
                        //         ]
                        //       ),
                        //       const SizedBox(height: 20),
                        //       Container(
                        //         width: 300,
                        //         padding: const EdgeInsets.symmetric(horizontal: 10),
                        //         child: Text(
                        //           'Tekan "Pilih Outlet" untuk memilih tempat pegawai bekerja',
                        //           textAlign: TextAlign.center,
                        //           style: TextStyle(
                        //             fontFamily: "Poppins",
                        //             color: Theme.of(context).disabledColor,
                        //             fontSize: 10
                        //           )
                        //         )
                        //       )
                        //     ]
                        //   )
                        // ),
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
                          _addMitra();
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
                              Text("Proses simpan...",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white))
                            ])))
            ]))));
  }
}
