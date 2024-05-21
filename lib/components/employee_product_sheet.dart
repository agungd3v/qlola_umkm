import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class EmployeeProductSheet extends StatefulWidget {
  dynamic product;

  EmployeeProductSheet({super.key,
    required this.product
  });

  @override
  State<EmployeeProductSheet> createState() => _EmployeeProductSheetState();
}

class _EmployeeProductSheetState extends State<EmployeeProductSheet> {
  CheckoutProvider? checkout_provider;
  int quantity = 1;

  void _addToCart(dynamic product) {
    Map<String, dynamic> item = {
      "id": product["id"],
      "product_name": product["product_name"],
      "product_image": product["product_image"],
      "product_price": product["product_price"],
      "quantity": quantity
    };

    checkout_provider?.set_carts = item;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.all(Radius.circular(99))
            )
          ),
          const SizedBox(height: 10),
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              "${dotenv.env["ASSET_URL"]}${widget.product["product_image"]}",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          ),
          const SizedBox(height: 10),
          Expanded(child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product["product_name"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 16
                  )
                ),
                Text(
                  transformPrice(double.parse(widget.product["product_price"])),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  )
                )
              ]
            )
          )),
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                        child: Image.asset("assets/icons/minus_red.png", width: 25, height: 25)
                      )
                    ),
                    Expanded(child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18
                        )
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        setState(() => quantity++);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                        child: Image.asset("assets/icons/plus_red.png", width: 25, height: 25)
                      )
                    )
                  ]
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _addToCart(widget.product);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Tambahkan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
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