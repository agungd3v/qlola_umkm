import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/button_checkout.dart';
import 'package:qlola_umkm/components/employee_order/order_item.dart';
import 'package:qlola_umkm/components/employee_order/process_order.dart';
import 'package:qlola_umkm/providers/auth_provider.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:sizer/sizer.dart';
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
  List products = [];
  List orders = [];

  void _getProduct() {
    if (!mounted) return;
    final outlet = authProvider.user["outlet"];
    if (outlet != null && outlet["products"] != null) {
      setState(() {
        products = outlet["products"];
      });
    }
  }

  Future<void> _getTransactionPending() async {
    if (!mounted) return;
    final httpRequest = await outlet_transaction_part("pending");
    if (httpRequest["status"] == 200) {
      setState(() {
        orders = httpRequest["data"];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        tabIndex = _tabController.index;
      });

      if (_tabController.index == 0) {
        _getProduct();
      } else {
        _getTransactionPending();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getProduct();
    });
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
                      _buildProductTab(constraints),
                      _buildOrderTab(constraints),
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

  Widget _buildProductTab(BoxConstraints constraints) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            color: Theme.of(context).indicatorColor,
            onRefresh: () async => _getProduct(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
        if (checkoutProvider.carts.isNotEmpty) const ButtonCheckout()
      ]
    );
  }

  Widget _buildOrderTab(BoxConstraints constraints) {
    return RefreshIndicator(
      color: Theme.of(context).indicatorColor,
      onRefresh: () async => _getTransactionPending(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: orders.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (orders.isNotEmpty) for (var i = 0; i < orders.length; i++) ProcessOrder(item: orders[i]),
                if (orders.isEmpty) Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/transaction_empty.png",
                      width: 300.w,
                      height: 50.w,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Belum ada Order",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18,
                      )
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 320,
                      child: Text(
                        'Oops... belum ada orderan di hari ini',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 14,
                        )
                      )
                    )
                  ]
                )
              ]
            )
          )
        )
      )
    );
  }
}
