import 'package:flutter/material.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/employee_order/process_order.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderProcessWidget extends StatefulWidget {
  BoxConstraints constraints;
  TabController tabController;

  OrderProcessWidget({super.key,
    required this.constraints,
    required this.tabController
  });

  @override
  State<OrderProcessWidget> createState() => _OrderProcessWidgetState();
}

class _OrderProcessWidgetState extends State<OrderProcessWidget> {
  List orders = [];
  bool loading = true;

  Future<void> _getTransactionPending() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });

    final httpRequest = await outlet_transaction_part("pending");
    if (httpRequest["status"] == 200) {
      setState(() {
        orders = httpRequest["data"];
      });
    }

    setState(() {
      loading = false;
    });
  }

  void _onTabChange() {
    if (!widget.tabController.indexIsChanging) {
      if (widget.tabController.index == 1) {
        _getTransactionPending();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).indicatorColor,
      onRefresh: () async => _getTransactionPending(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.constraints.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: orders.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (loading) Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 300),
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
                ),
                if (!loading && orders.isNotEmpty) for (var i = 0; i < orders.length; i++) ProcessOrder(item: orders[i]),
                if (!loading && orders.isEmpty) Column(
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
                    ),
                    const SizedBox(height: 100)
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