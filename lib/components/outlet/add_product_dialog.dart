import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductDialog extends StatefulWidget {
  dynamic outlet;

  AddProductDialog({super.key,
    required this.outlet
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  OwnerProvider? owner_provider;
  List productDump = [];
  bool load = false;

  Future getProduct() async {
    setState(() => load = true);

    final Map<String, dynamic> data = {
      "outlet_id": widget.outlet["id"],
    };

    final httpRequest = await get_available_products(data);
    inspect(httpRequest);
    if (httpRequest["status"] == 200) {
      setState(() {
        productDump = httpRequest["data"].map((data) {
          return {...data, "checked": false};
        }).toList();
      });
    }

    setState(() => load = false);
  }

  Future _tempEmployee() async {
    final productChecked = productDump.where((data) => data["checked"]).toList();
    for (var i = 0; i < productChecked.length; i++) {
      owner_provider!.add_product = productChecked[i];
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      title: Text(
        "Daftar Produk",
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColorDark,
          fontSize: 18
        )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (load) Container(
            padding: const EdgeInsets.only(bottom: 40, top: 20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              ]
            )
          ),
          if (!load && productDump.isEmpty) Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Tidak ada satupun produk tersedia di bisnis anda",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: Theme.of(context).primaryColorDark,
                fontSize: 14
              )
            )
          ),
          if (!load && productDump.isNotEmpty) Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                for (var index = 0; index < productDump.length; index++) Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productDump[index]["product_name"],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 14
                        )
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: Checkbox(
                          value: productDump[index]["checked"],
                          onChanged: (bool? value) {
                            setState(() {
                              productDump[index]["checked"] = value;
                            });
                          },
                          activeColor: Theme.of(context).primaryColor,
                          side: BorderSide(
                            width: 1,
                            color: Theme.of(context).dividerColor
                          )
                        )
                      )
                    ]
                  )
                )
              ]
            )
          ),
          GestureDetector(
            onTap: () => _tempEmployee(),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
              alignment: Alignment.center,
              child: Text(
                "Tambahkan",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 14
                )
              )
            )
          )
        ]
      )
    );
  }
}