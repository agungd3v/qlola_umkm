import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/screens/employee/part/order_now.dart';
import 'package:qlola_umkm/screens/employee/part/order_process.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeOrderScreen extends StatefulWidget {
  const EmployeeOrderScreen({super.key});

  @override
  State<EmployeeOrderScreen> createState() => _EmployeeOrderScreenState();
}

class _EmployeeOrderScreenState extends State<EmployeeOrderScreen> with TickerProviderStateMixin {
  late CheckoutProvider checkoutProvider;
  late AuthProvider authProvider;
  late TabController _tabController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkoutProvider = Provider.of<CheckoutProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
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
                fontSize: 18,
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).primaryColor,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorColor: Theme.of(context).primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(child: _tabLabel("Order Sekarang", 0)),
                        Tab(child: _tabLabel("Proses Order", 1)),
                      ]
                    )
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OrderNowWidget(
                        constraints: constraints,
                        authProvider: authProvider,
                        checkoutProvider: checkoutProvider,
                        tabController: _tabController
                      ),
                      OrderProcessWidget(
                        constraints: constraints,
                        tabController: _tabController
                      )
                    ]
                  )
                )
              )
            )
          ]
        )
      );
    });
  }

  Widget _tabLabel(String label, int index) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.w600,
        color: tabIndex == index ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
        fontSize: 14,
      )
    );
  }
}
