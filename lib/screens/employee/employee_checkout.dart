import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/helpers/helper_checkout.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class EmployeeCheckoutScreen extends StatefulWidget {
  const EmployeeCheckoutScreen({super.key});

  @override
  State<EmployeeCheckoutScreen> createState() => _EmployeeCheckoutScreenState();
}

class _EmployeeCheckoutScreenState extends State<EmployeeCheckoutScreen> {
  CheckoutProvider? checkout_provider;
  AuthProvider? auth_provider;

  final productName = TextEditingController(text: "");
  final productPrice = TextEditingController(text: "");
  final productQty = TextEditingController(text: "");

  bool _isFirstRun = true;
  bool proccess = false;
  List<int> bytes = [];
  int dumpId = 999999;
  bool isConnectedToInternet = false;

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() => isConnectedToInternet = false);
      print("❌ Tidak terhubung ke jaringan apapun");
      return;
    }

    bool hasInternet = await InternetConnectionChecker.instance.hasConnection;

    setState(() {
      isConnectedToInternet = hasInternet;
    });

    if (hasInternet) {
      print("✅ Terhubung ke internet");
      isConnectedToInternet = true;

      _prosesCheckout(context);
    } else {
      isConnectedToInternet = false;
      print("❌ Terhubung ke jaringan tapi tidak ada internet");
      _orderProduct(context);
    }
  }

  Future<void> _prosesCheckout(BuildContext context) async {
    setState(() => proccess = true);

    final checkout =
        await HelperCheckout.checkoutOnline(checkout_provider!, auth_provider!);

    if (checkout["status"]) {
      context.pushNamed("Employee Complete");

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        successMessage(context, auth_provider!.user["outlet"]["outlet_name"],
            "Berhasil melakukan pemesanan");
        setState(() => proccess = false);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        errorMessage(context, auth_provider!.user["outlet"]["outlet_name"],
            checkout["message"]);
        setState(() => proccess = false);
      });
    }
  }

  Future<void> _orderProduct(BuildContext context) async {
    setState(() => proccess = true);

    final checkout = await HelperCheckout.checkoutOffline(
        checkout_provider!, auth_provider!);

    if (checkout["status"]) {
      context.pushNamed("Employee Complete");

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        successMessage(context, auth_provider!.user["outlet"]["outlet_name"],
            "Berhasil melakukan pemesanan");
        setState(() => proccess = false);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        errorMessage(context, auth_provider!.user["outlet"]["outlet_name"],
            checkout["message"]);
        setState(() => proccess = false);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstRun) {
      _isFirstRun = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final carts =
            Provider.of<CheckoutProvider>(context, listen: false).carts;
        if (carts.isEmpty) {
          Navigator.pop(context);
        }
      });
    }
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
                    statusBarIconBrightness: Brightness.dark))),
        body: Stack(children: [
          Column(children: [
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: Theme.of(context).dividerColor))),
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
                      Text(
                          "Checkout ${auth_provider!.user["outlet"]["outlet_name"]}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 3.8.w))
                    ])),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              const SizedBox(height: 16),
              for (var index = 0;
                  index < checkout_provider!.carts.length;
                  index++)
                Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                              "${dotenv.env["ASSET_URL"]}/${checkout_provider!.carts[index]["product_image"]}",
                              width: 19.w,
                              height: 19.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                            return Container(
                                width: 19.w,
                                height: 19.w,
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2)),
                                child: Center(
                                    child: Image.asset(
                                  "assets/icons/image_crash.png",
                                  width: 25,
                                  height: 25,
                                )));
                          })),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Container(
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
                                    fontSize: 3.5.w)),
                            Text(
                                transformPrice(double.parse(checkout_provider!
                                    .carts[index]["product_price"]
                                    .toString())),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 3.w)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text("Quantity",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 3.w)),
                              const SizedBox(width: 6),
                              Text(
                                  "x${checkout_provider!.carts[index]["quantity"]}",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 3.w)),
                              Expanded(child: Container()),
                              Text(
                                  transformPrice(double.parse(checkout_provider!
                                          .carts[index]["product_price"]
                                          .toString()) *
                                      checkout_provider!.carts[index]
                                          ["quantity"]),
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 3.5.w))
                            ]),
                            const SizedBox(height: 5),
                            Row(children: [
                              GestureDetector(
                                  onTap: () {
                                    if (checkout_provider!.carts[index]
                                            ["quantity"] >
                                        1) {
                                      setState(() {
                                        checkout_provider!.carts[index]
                                            ["quantity"]--;
                                      });
                                    } else {
                                      checkout_provider!.remove_item_carts =
                                          checkout_provider!.carts[index]["id"];
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Image.asset(
                                          "assets/icons/minus_red.png",
                                          width: 5.w,
                                          height: 5.w))),
                              const SizedBox(width: 10),
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      checkout_provider!.carts[index]
                                              ["quantity"]
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontSize: 3.5.w))),
                              const SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkout_provider!.carts[index]
                                          ["quantity"]++;
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Image.asset(
                                          "assets/icons/plus_red.png",
                                          width: 5.w,
                                          height: 5.w)))
                            ])
                          ])))
                    ])),
              const SizedBox(height: 16)
            ]))),
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(
                      width: 1, color: Theme.of(context).dividerColor),
                )),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TOTAL BAYAR",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: 3.w)),
                            Text(
                                transformPrice(double.parse(
                                    checkout_provider!.cart_total.toString())),
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 4.w))
                          ]),
                      if (!proccess)
                        GestureDetector(
                            onTap: () {
                              setState(() => proccess = true);
                              checkInternetConnection();
                            },
                            child: Container(
                                height: 9.w,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                alignment: Alignment.center,
                                child: Text("Proses pesanan",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 3.w)))),
                      if (proccess)
                        Container(
                            height: 9.w,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            child: Row(children: [
                              LoadingAnimationWidget.fourRotatingDots(
                                  color: Colors.white, size: 3.w),
                              const SizedBox(width: 8),
                              Text("Memproses",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 3.w))
                            ]))
                    ]))
          ]),
          Positioned(
              bottom: 80,
              right: 12,
              child: GestureDetector(
                  onTap: () =>
                      HelperCheckout.otherOrder(context, checkout_provider!),
                  child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(99)),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).disabledColor,
                                spreadRadius: 0,
                                blurRadius: 1,
                                offset: const Offset(1, 2))
                          ]),
                      child: Center(
                          child: Image.asset("assets/icons/plus_white.png",
                              width: 25, height: 25)))))
        ]));
  }
}
