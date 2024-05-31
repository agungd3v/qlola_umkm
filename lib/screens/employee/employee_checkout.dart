import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:qlola_umkm/utils/printer.dart';

class EmployeeCheckoutScreen extends StatefulWidget {
  const EmployeeCheckoutScreen({super.key});

  @override
  State<EmployeeCheckoutScreen> createState() => _EmployeeCheckoutScreenState();
}

class _EmployeeCheckoutScreenState extends State<EmployeeCheckoutScreen> {
  CheckoutProvider? checkout_provider;
  AuthProvider? auth_provider;

  bool proccess = false;
  List<int> bytes = [];

  Future _orderProduct() async {
    Map<String, dynamic> data = {
      "total": checkout_provider?.cart_total,
      "outlet_id": auth_provider?.user["outlet"]["id"],
      "business_id": int.parse(auth_provider?.user["outlet"]["business_id"]),
      "products": checkout_provider?.carts
    };

    setState(() => proccess = true);

    final httpRequest = await proses_checkout(data);
    if (httpRequest["status"] == 200) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          backgroundColor: Color(0xff00880d),
          duration: Duration(seconds: 3),
          reverseAnimationCurve: Curves.fastOutSlowIn,
          flushbarPosition: FlushbarPosition.TOP,
          titleText: Text(
            auth_provider!.user["outlet"]["outlet_name"],
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 12
            )
          ),
          messageText: Text(
            "Berhasil melakukan pemesanan",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 12
            )
          ),
        ).show(context);
      });

      final generate = await generateStruck(checkout_provider!, auth_provider!, "#${httpRequest["message"]}");

      if (generate) {
        checkout_provider?.reset();
        return context.go("/order");
      }
    }

    setState(() => proccess = false);

    Flushbar(
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 3),
      reverseAnimationCurve: Curves.fastOutSlowIn,
      flushbarPosition: FlushbarPosition.BOTTOM,
      titleText: Text(
        "Pesanan",
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 12
        )
      ),
      messageText: Text(
        httpRequest["message"],
        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.white,
          fontSize: 12
        )
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);
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
            statusBarIconBrightness: Brightness.dark
          )
        )
      ),
      body: Container(
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
                    "Checkout ${auth_provider!.user["outlet"]["outlet_name"]}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark
                    )
                  )
                ]
              )
            ),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  for (var index = 0; index < checkout_provider!.carts.length; index++) Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            "${dotenv.env["ASSET_URL"]}${checkout_provider!.carts[index]["product_image"]}",
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.2)
                                ),
                                child: Center(
                                  child: Image.asset("assets/icons/image_crash.png", width: 25, height: 25)
                                )
                              );
                            }
                          )
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                checkout_provider!.carts[index]["product_name"],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 12
                                )
                              ),
                              Text(
                                transformPrice(double.parse(checkout_provider!.carts[index]["product_price"])),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12
                                )
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "Quantity",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 12
                                    )
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "x${checkout_provider!.carts[index]["quantity"]}",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12
                                    )
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    transformPrice(
                                      double.parse(checkout_provider!.carts[index]["product_price"]) * checkout_provider!.carts[index]["quantity"]
                                    ),
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12
                                    )
                                  )
                                ]
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (checkout_provider!.carts[index]["quantity"] > 1) {
                                        setState(() {
                                          checkout_provider!.carts[index]["quantity"]--;
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(Radius.circular(4))
                                      ),
                                      child: Image.asset("assets/icons/minus_red.png", width: 18, height: 18)
                                    )
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      checkout_provider!.carts[index]["quantity"].toString(),
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColorDark
                                      )
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        checkout_provider!.carts[index]["quantity"]++;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(Radius.circular(4))
                                      ),
                                      child: Image.asset("assets/icons/plus_red.png", width: 18, height: 18)
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                        ))
                      ]
                    )
                  ),
                  const SizedBox(height: 16),
                ]
              )
            )),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TOTAL BAYAR",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 10
                        )
                      ),
                      Text(
                        transformPrice(checkout_provider!.cart_total),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16
                        )
                      )
                    ]
                  ),
                  if (!proccess) GestureDetector(
                    onTap: () => _orderProduct(),
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Proses pesanan",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 12
                        )
                      )
                    )
                  ),
                  if (proccess) Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Row(
                      children: [
                        LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Memproses",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 12
                          )
                        )
                      ]
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}