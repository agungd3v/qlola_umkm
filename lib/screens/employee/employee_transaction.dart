import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmployeeTransactionScreen extends StatefulWidget {
  const EmployeeTransactionScreen({super.key});

  @override
  State<EmployeeTransactionScreen> createState() => _EmployeeTransactionScreenState();
}

class _EmployeeTransactionScreenState extends State<EmployeeTransactionScreen> {
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