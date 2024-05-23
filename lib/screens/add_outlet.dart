import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/api/request.dart';

class AddOutletScreen extends StatefulWidget {
  const AddOutletScreen({super.key});

  @override
  State<AddOutletScreen> createState() => _AddOutletScreenState();
}

class _AddOutletScreenState extends State<AddOutletScreen> {
  final outletName = TextEditingController();
  final outletPhone = TextEditingController();
  final outletAddress = TextEditingController();

  Future<void> _addoutlet() async {
    final Map<String, dynamic> data = {
      "outlet_name": outletName.text,
      "outlet_phone": "+62${outletPhone.text}",
      "outlet_address": outletAddress.text
      // "outlet_image": imagePath
    };

    final httpRequest = await add_outlet(data);
    if (httpRequest["status"] == 200) {
      Navigator.pop(context);
    }
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
            statusBarIconBrightness: Brightness.dark
          )
        )
      ),
      body: GestureDetector(
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
                      "Tambah Outlet",
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Informasi Outlet",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark
                            )
                          ),
                          const SizedBox(height: 14),
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
                                hintText: "Nama outlet",
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
                              controller: outletName,
                            )
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "+62",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 12
                                  )
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: "No. Handphone",
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
                                  controller: outletPhone,
                                ))
                              ]
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
                                hintText: "Detail Alamat (Optional)",
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
                              controller: outletAddress,
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
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _addoutlet();
                  },
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
    );
  }
}