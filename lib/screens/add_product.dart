import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:sizer/sizer.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  bool favorite = false;
  File? imageTemp;
  String? imagePath;
  bool proccess = false;

  Future<void> _addproduct() async {
    final Map<String, dynamic> data = {
      "product_name": productName.text,
      "product_price": productPrice.text,
      "product_image": imagePath
    };

    setState(() => proccess = true);

    final httpRequest = await add_product(data);
    if (httpRequest["status"] == 200) {
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
        messageText: Text("Berhasil menambahkan produk baru",
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

    FocusScope.of(context).unfocus();
    Navigator.pop(context);
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
                            width: 5.w, height: 5.w),
                        const SizedBox(width: 12),
                        Text("Kamera",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 3.w))
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
                            width: 5.w, height: 5.w),
                        const SizedBox(width: 12),
                        Text("Pilih dari galeri",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 3.w))
                      ])))
            ])));
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
                        Text("Tambah Produk",
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
                            child: Column(children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).dividerColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: "Nama produk",
                                        hintStyle: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 3.w)),
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 3.w),
                                    cursorColor: Theme.of(context).focusColor,
                                    controller: productName,
                                  )),
                              const SizedBox(height: 12),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color:
                                              Theme.of(context).dividerColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: "Harga jual",
                                        hintStyle: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 3.w)),
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontSize: 3.w),
                                    keyboardType: TextInputType.number,
                                    cursorColor: Theme.of(context).focusColor,
                                    controller: productPrice,
                                  ))
                            ])),
                        const SizedBox(height: 20),
                        Container(
                          height: 10,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: Row(
                        //     children: [
                        //       Expanded(child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             "Produk Favorit",
                        //             style: TextStyle(
                        //               fontFamily: "Poppins",
                        //               fontWeight: FontWeight.w600,
                        //               color: Theme.of(context).primaryColor
                        //             )
                        //           ),
                        //           Text(
                        //             "Tampilkan produk di posisi teratas",
                        //             style: TextStyle(
                        //               fontFamily: "Poppins",
                        //               color: Theme.of(context).primaryColorDark,
                        //               fontSize: 12
                        //             )
                        //           )
                        //         ]
                        //       )),
                        //       const SizedBox(width: 12),
                        //       Transform.scale(
                        //         scale: 0.7,
                        //         child: CupertinoSwitch(
                        //           activeColor: Theme.of(context).primaryColor,
                        //           trackColor: Theme.of(context).dividerColor,
                        //           value: favorite,
                        //           onChanged: (value) => setState(() => favorite = value),
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
                          _addproduct();
                        },
                        child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: Text("Simpan",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white))))),
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
