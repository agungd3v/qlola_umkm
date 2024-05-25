import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/button_checkout.dart';
import 'package:qlola_umkm/components/employee_order/order_item.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';

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
      final httpRequest = await get_outlet_products(auth_provider!.user["outlet"]["id"]);
      if (httpRequest["status"] == 200) {
        setState(() {
          products = httpRequest["data"];
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

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          )
        )
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            color: Theme.of(context).indicatorColor,
            onRefresh: () => Future.delayed(Duration(seconds: 1), () => _getProduct()),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(child: Stack(
                  children: [
                    if (checkout_provider!.carts.isNotEmpty) Positioned(
                      bottom: 12,
                      left: MediaQuery.of(context).size.width / 3,
                      child: ButtonCheckout()
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          for (var index = 0; index < products.length; index++) OrderItem(item: products[index], index: index),
                          const SizedBox(height: 16)
                        ]
                      )
                    )
                  ]
                ))
              )
            ),
          );
        }
      )
    );
  }
}