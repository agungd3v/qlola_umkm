import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/database/database_helper.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';

class HelperCheckout {

  static Future<Map<String, dynamic>> checkoutOnline(CheckoutProvider checkout_provider, AuthProvider auth_provider) async {
    try {
      Map<String, dynamic> data = {
        "total": checkout_provider.cart_total,
        "outlet_id": auth_provider.user["outlet"]["id"],
        "business_id": auth_provider.user["outlet"]["business_id"],
        "products": checkout_provider.carts,
        "ordering": checkout_provider.ordering
      };

      final httpRquest = await proses_checkout(data);
      if (httpRquest["status"] != 200) throw Exception(httpRquest["message"]);

      final isOrder = localStorage.getItem("ordering");
      final incrementedOrder = (int.tryParse(isOrder ?? "1") ?? 1) + 1;
      localStorage.setItem("ordering", incrementedOrder.toString());

      checkout_provider.set_ordering = incrementedOrder;

      return <String, dynamic> {
        "status": true,
        "message": "success"
      };
    } catch (e) {
      return <String, dynamic> {
        "status": false,
        "message": "$e"
      };
    }
  }

  static Future<Map<String, dynamic>> checkoutOffline(CheckoutProvider checkout_provider, AuthProvider auth_provider) async {
    try {
      final databaseHelper = DatabaseHelper.instance;
      final time = DateTime.now().millisecondsSinceEpoch;

      Map<String, dynamic> data = {
        "total": checkout_provider.cart_total,
        "outlet_id": auth_provider.user["outlet"]["id"],
        "business_id": auth_provider.user["outlet"]["business_id"],
        "products": checkout_provider.carts
      };

      final database = await databaseHelper.database;
      final batch = database?.batch();

      for (var index = 0; index < data["products"].length; index++) {
        batch?.rawInsert('INSERT INTO '
          'orders(_transaction, _outletid, _productid, _productname, _productprice, _quantity, _total, _status, _createdat, _updatedat, _other) '
          'VALUES ('
          '"trx_${time}", ${data["outlet_id"]},'
          '${data["products"][index]["id"]},'
          '"${data["products"][index]["product_name"]}",'
          '${data["products"][index]["product_price"]},'
          '${data["products"][index]["quantity"]},'
          '${(double.parse(data["products"][index]["product_price"].toString()) * data["products"][index]["quantity"])},'
          '"paid",'
          '"${getDateTimeNow(isRequest: true)}", "${getDateTimeNow(isRequest: true)}",'
          '${data["products"][index]["id"] >= 999999 ? 1 : 0}'
        ')');
      }

      await batch?.commit();

      return <String, dynamic> {
        "status": true,
        "message": "success"
      };
    } catch (e) {
      return <String, dynamic> {
        "status": false,
        "message": "$e"
      };
    }
  }

  static void otherOrder(BuildContext context, CheckoutProvider checkout_provider) {
    final productName = TextEditingController(text: "");
    final productPrice = TextEditingController(text: "");
    final productQty = TextEditingController(text: "");

    int dumpId = 999999;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        title: Text("Custom produk",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColorDark,
            fontSize: 14
          )
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
                controller: productName
              )
            ),
            const SizedBox(height: 10),
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
                    fontSize: 3.w
                  )
                ),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 3.w
                ),
                keyboardType: TextInputType.number,
                cursorColor: Theme.of(context).focusColor,
                controller: productPrice,
              )
            ),
            const SizedBox(height: 10),
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
                  hintText: "Quantity",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).disabledColor,
                    fontSize: 3.w
                  )
                ),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 3.w
                ),
                keyboardType: TextInputType.number,
                cursorColor: Theme.of(context).focusColor,
                controller: productQty,
              )
            ),
            const SizedBox(height: 15),
            // Text(
            //   transformPrice(0),
            //   style: TextStyle(
            //     fontFamily: "Poppins",
            //     color: Theme.of(context).primaryColorDark,
            //     fontWeight: FontWeight.w700
            //   )
            // ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Map<String, dynamic> item = {
                  "id": dumpId,
                  "_other": true,
                  "product_name": productName.text,
                  "product_image": null,
                  "product_price": int.parse(productPrice.text),
                  "quantity": int.parse(productQty.text)
                };

                checkout_provider.set_carts = item;
                dumpId += 1;
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                child: Text(
                  "Tambah Pesanan",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12
                  )
                )
              )
            )
          ]
        )
      )
    );
  }

}