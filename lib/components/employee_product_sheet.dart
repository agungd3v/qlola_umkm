import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeProductSheet extends StatefulWidget {
  dynamic product;

  EmployeeProductSheet({super.key, required this.product});

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
  void initState() {
    debugPrint(widget.product.toString());
    super.initState();
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
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.6.h,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.all(Radius.circular(99))
            )
          ),
          SizedBox(height: 2.h),
          Container(
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              "${dotenv.env["ASSET_URL"]}/${widget.product["product_image"]}",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Icon(Icons.photo_size_select_actual, size: 43, color: Theme.of(context).primaryColorDark)
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product["product_name"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 16.sp, // Using responsive font size
                    ),
                  ),
                  Text(
                    transformPrice(double.parse(widget.product["product_price"].toString())),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.sp, // Using responsive font size
                    )
                  )
                ]
              )
            )
          ),
          Container(
            margin: EdgeInsets.only(bottom: 1.h), // Adjusted margin for bottom spacing
            child: Column(
              children: [
                Row(children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Icon(Icons.remove, size: 28, color: Theme.of(context).primaryColorDark)
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toString(),
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                        )
                      )
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => quantity++);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Icon(Icons.add, size: 28, color: Theme.of(context).primaryColorDark)
                    )
                  )
                ]),
                SizedBox(height: 2.h), // Adjusted for spacing
                GestureDetector(
                  onTap: () {
                    _addToCart(widget.product);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 5.h, // Adjusted height for responsiveness
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Tambahkan",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 16,
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
