import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _pickFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageFile = File(image.path);
      setState(() => imageTemp = imageFile);

      FocusScope.of(context).unfocus();
    } on PlatformException catch (e) {
      inspect("failed pick image: $e");
    }

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
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(99))
              )
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Image.asset("assets/icons/camera_red.png", width: 20, height: 20),
                    const SizedBox(width: 12),
                    Text(
                      "Kamera",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
                      )
                    )
                  ]
                )
              )
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _pickFromGallery();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Image.asset("assets/icons/gallery_red.png", width: 20, height: 20),
                    const SizedBox(width: 12),
                    Text(
                      "Pilih dari galeri",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 12
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                    )
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset("assets/icons/arrow_back_gray.png", width: 16, height: 16)
                        )
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Tambah Produk",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark
                        )
                      ),
                    ]
                  )
                ),
                Expanded(child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _openModalPicture(),
                        child: Container(
                          width: 80,
                          height: 80,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor,
                            borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (imageTemp == null) Image.asset("assets/icons/camera_white.png", width: 24, height: 24),
                              if (imageTemp != null) Image.file(imageTemp!, width: 80, height: 80, fit: BoxFit.cover)
                            ]
                          )
                        )
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: "Nama produk",
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
                                controller: productName,
                              )
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.all(Radius.circular(6))
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: "Harga jual",
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
                                keyboardType: TextInputType.number,
                                cursorColor: Theme.of(context).focusColor,
                                controller: productPrice,
                              )
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 10,
                        color: Theme.of(context).dividerColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Produk Favorit",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor
                                  )
                                ),
                                Text(
                                  "Tampilkan produk di posisi teratas",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 12
                                  )
                                )
                              ]
                            )),
                            const SizedBox(width: 12),
                            Transform.scale(
                              scale: 0.7,
                              child: CupertinoSwitch(
                                activeColor: Theme.of(context).primaryColor,
                                trackColor: Theme.of(context).dividerColor,
                                value: favorite,
                                onChanged: (value) => setState(() => favorite = value),
                              )
                            )
                          ]
                        )
                      ),
                      const SizedBox(height: 20)
                    ]
                  )
                )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: GestureDetector(
                    onTap: () => debugPrint("store image"),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      child: Text(
                        "Simpan",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                        )
                      )
                    )
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}