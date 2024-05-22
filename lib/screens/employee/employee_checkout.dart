import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeCheckoutScreen extends StatefulWidget {
  const EmployeeCheckoutScreen({super.key});

  @override
  State<EmployeeCheckoutScreen> createState() => _EmployeeCheckoutScreenState();
}

class _EmployeeCheckoutScreenState extends State<EmployeeCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
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