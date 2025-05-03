import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/components/button_checkout.dart';
import 'package:qlola_umkm/components/employee_order/order_item.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:sizer/sizer.dart';

class EmployeeOrderScreen extends StatefulWidget {
  const EmployeeOrderScreen({super.key});

  @override
  State<EmployeeOrderScreen> createState() => _EmployeeOrderScreenState();
}

class _EmployeeOrderScreenState extends State<EmployeeOrderScreen> {
  CheckoutProvider? checkout_provider;
  AuthProvider? auth_provider;

  List products = [];

  void _getProduct() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (auth_provider!.user["outlet"] != null) {
        setState(() {
          products = auth_provider!.user["outlet"]["products"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);
    auth_provider = Provider.of<AuthProvider>(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            title: Text(
              "Order Produk",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColorDark,
                fontSize: 18
              )
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).primaryColor,
              statusBarIconBrightness: Brightness.light,
            )
          )
        ),
        body: Column(children: [
          Expanded(
            child: RefreshIndicator(
              color: Theme.of(context).indicatorColor,
              onRefresh: () => Future.delayed(Duration(seconds: 1), () => _getProduct()),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Stack(children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: products.isNotEmpty ? MainAxisAlignment.start : MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            if (products.isNotEmpty) for (var index = 0; index < products.length; index++) OrderItem(item: products[index], index: index),
                            if (products.isEmpty) Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/icons/no_data.png",
                                    width: 80.w,
                                    height: 80.w,
                                    fit: BoxFit.fill
                                  ),
                                  Text(
                                    'Produk tidak di temukan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 4.w
                                    )
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Oops... produk tidak ditemukan atau kamu belum di daftarkan pada outlet ini, hubungi owner bisnis untuk memastikannya!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 3.w
                                    )
                                  )
                                ]
                              )
                            ),
                            const SizedBox(height: 16)
                          ]
                        )
                      )
                    ])
                  )
                )
              )
            )
          ),
          if (checkout_provider!.carts.isNotEmpty) ButtonCheckout()
        ])
      );
    });
  }
}
