import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';

class EmployeeCheckoutScreen extends StatefulWidget {
  const EmployeeCheckoutScreen({super.key});

  @override
  State<EmployeeCheckoutScreen> createState() => _EmployeeCheckoutScreenState();
}

class _EmployeeCheckoutScreenState extends State<EmployeeCheckoutScreen> {
  CheckoutProvider? checkout_provider;

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);
    inspect(checkout_provider);

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
      body: Container(
        child: Text("checkout screen")
      )
    );
  }
}