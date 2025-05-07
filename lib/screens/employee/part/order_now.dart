import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qlola_umkm/components/button_checkout.dart';
import 'package:qlola_umkm/components/employee_order/order_item.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:sizer/sizer.dart';

class OrderNowWidget extends StatefulWidget {
  BoxConstraints constraints;
  AuthProvider authProvider;
  CheckoutProvider checkoutProvider;
  TabController tabController;

  OrderNowWidget({super.key,
    required this.constraints,
    required this.authProvider,
    required this.checkoutProvider,
    required this.tabController
  });

  @override
  State<OrderNowWidget> createState() => _OrderNowWidgetState();
}

class _OrderNowWidgetState extends State<OrderNowWidget> {
  List products = [];

  void _getProduct() {
    if (!mounted) return;
    final outlet = widget.authProvider.user["outlet"];
    if (outlet != null && outlet["products"] != null) {
      setState(() {
        products = outlet["products"];
      });
    }
  }

  void _onTabChange() {
    if (!widget.tabController.indexIsChanging) {
      if (widget.tabController.index == 0) {
        // debugPrint("hello world");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
    widget.tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: Theme.of(context).indicatorColor,
            onRefresh: () async => _getProduct(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: widget.constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: products.isNotEmpty ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        if (products.isNotEmpty) for (var i = 0; i < products.length; i++) OrderItem(item: products[i], index: i),
                        if (products.isEmpty) Column(
                          children: [
                            Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor, size: 120),
                            const SizedBox(height: 20),
                            Text(
                              'Produk tidak di temukan',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14.sp,
                              )
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Oops... produk tidak ditemukan atau kamu belum didaftarkan pada outlet ini, hubungi owner bisnis untuk memastikannya!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 12.sp,
                              )
                            )
                          ]
                        ),
                        const SizedBox(height: 16)
                      ]
                    )
                  )
                )
              )
            )
          )
        ),
        if (widget.checkoutProvider.carts.isNotEmpty) const ButtonCheckout()
      ]
    );
  }
}