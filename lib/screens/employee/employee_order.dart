import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/button_checkout.dart';
import 'package:qlola_umkm/components/employee_order/order_item.dart';
import 'package:qlola_umkm/components/employee_order/process_order.dart';
import 'package:qlola_umkm/components/history/employee_transaction_daily.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeOrderScreen extends StatefulWidget {
  const EmployeeOrderScreen({super.key});

  @override
  State<EmployeeOrderScreen> createState() => _EmployeeOrderScreenState();
}

class _EmployeeOrderScreenState extends State<EmployeeOrderScreen> {
  CheckoutProvider? checkout_provider;
  AuthProvider? auth_provider;

  int tabIndex = 0;
  List products = [];
  List orders = [];

  void _getProduct() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (auth_provider!.user["outlet"] != null) {
        setState(() {
          products = auth_provider!.user["outlet"]["products"];
        });
      }
    });
  }

  Future _getTransactionPending() async {
    final httpRequest = await outlet_transaction();
    if (httpRequest["status"] == 200) {
      setState(() {
        orders = httpRequest["transactions_pending"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
    _getTransactionPending();
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
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
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
          Expanded(child: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    setState(() {
                      tabIndex = index;
                    });
                  },
                  padding: const EdgeInsets.only(top: 0),
                  tabs: [
                    Tab(child: Text(
                      "Order Sekarang",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: tabIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                        fontSize: 14
                      )
                    )),
                    Tab(child: Text(
                      "Proses Order",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: tabIndex == 1 ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
                        fontSize: 14
                      )
                    ))
                  ]
                )
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Get Produk
                  Column(
                    children: [
                      Expanded(child: RefreshIndicator(
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
                                            Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor, size: 120),
                                            SizedBox(height: 20),
                                            Text(
                                              'Produk tidak di temukan',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context).primaryColorDark,
                                                fontSize: 4.w
                                              )
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Oops... produk tidak ditemukan atau kamu belum di daftarkan pada outlet ini, hubungi owner bisnis untuk memastikannya!',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
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
                      )),
                      if (checkout_provider!.carts.isNotEmpty) ButtonCheckout()
                    ]
                  ),
                  // Get Order Process (transaction pending)
                  Column(
                    children: [
                      Expanded(child: RefreshIndicator(
                        color: Theme.of(context).indicatorColor,
                        onRefresh: () => Future.delayed(Duration(seconds: 1), () => _getTransactionPending()),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: orders.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
                                children: [
                                  // if (orders.isNotEmpty) for (var index = 0; index < orders.length; index++) EmployeeTransactionDaily(item: orders[index]),
                                  if (orders.isNotEmpty) for (var index = 0; index < orders.length; index++) ProcessOrder(item: orders[index]),
                                  if (orders.isEmpty) Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/transaction_empty.png",
                                        width: 300.w,
                                        height: 50.w,
                                        fit: BoxFit.contain
                                      ),
                                      Column(children: [
                                        const SizedBox(height: 12),
                                        Text(
                                          "Belum ada Order",
                                          style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).primaryColorDark,
                                            fontSize: 18
                                          )
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: 320,
                                          child: Text(
                                            'Oops... belum ada oerderan di hari ini',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                              color: Theme.of(context).primaryColorDark,
                                              fontSize: 14
                                            )
                                          )
                                        )
                                      ])
                                    ]
                                  )
                                ]
                              )
                            )
                          )
                        )
                      ))
                    ]
                  )
                ]
              )
            )
          ))
        ])
      );
    });
  }
}
