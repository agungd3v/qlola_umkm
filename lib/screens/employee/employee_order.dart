import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeOrderScreen extends StatefulWidget {
  const EmployeeOrderScreen({super.key});

  @override
  State<EmployeeOrderScreen> createState() => _EmployeeOrderScreenState();
}

class _EmployeeOrderScreenState extends State<EmployeeOrderScreen> {
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
    );
  }
}