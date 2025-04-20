import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart'; // Pastikan menggunakan Sizer untuk responsivitas

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w), // Responsif dengan Sizer
      child: Column(
        children: [
          Container(
            width: 10.w, // Adjusted width for responsiveness
            height: 0.6.h, // Adjusted height for responsiveness
            margin:
                EdgeInsets.only(top: 1.h), // Adjusted margin for responsiveness
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.all(Radius.circular(99)),
            ),
          ),
          SizedBox(height: 2.h), // Adjusted for spacing
          Container(
            height: 25.h, // Responsively adjusting image height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              "${dotenv.env["ASSET_URL"]}${widget.product["product_image"]}",
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
                    child: Image.asset("assets/icons/image_crash.png",
                        width: 12.w, height: 12.w),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h), // Adjusted for spacing
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
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 16.sp, // Using responsive font size
                    ),
                  ),
                  Text(
                    transformPrice(double.parse(
                        widget.product["product_price"].toString())),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.sp, // Using responsive font size
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                bottom: 1.h), // Adjusted margin for bottom spacing
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
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Image.asset("assets/icons/minus_red.png",
                            width: 7.w, height: 7.w),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => quantity++);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Image.asset("assets/icons/plus_red.png",
                            width: 7.w, height: 7.w),
                      ),
                    ),
                  ],
                ),
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
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14.sp, // Responsive font size
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
