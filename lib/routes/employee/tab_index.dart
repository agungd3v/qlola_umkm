import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabIndex extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  TabIndex({super.key,
    required this.navigationShell
  });

  @override
  State<TabIndex> createState() => _TabIndexState();
}

class _TabIndexState extends State<TabIndex> {
  int tabIndex = 0;

  void goIndex(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Theme.of(context).dividerColor)
          ),
          color: Colors.white
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 10),
          selectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 10),
          elevation: 0,
          currentIndex: tabIndex,
          onTap: (index) {
            setState(() => tabIndex = index);
            goIndex(tabIndex);
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 0 ?
                  Image.asset("assets/icons/home.png", width: 24, height: 24) :
                  Image.asset("assets/icons/home_outline.png", width: 24, height: 24)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 1 ?
                  Image.asset("assets/icons/order.png", width: 24, height: 24) :
                  Image.asset("assets/icons/order_outline.png", width: 24, height: 24)
              ),
              label: 'Order'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 2 ?
                  Image.asset("assets/icons/transaction.png", width: 24, height: 24) :
                  Image.asset("assets/icons/transaction_outline.png", width: 24, height: 24)
              ),
              label: 'Transaksi'
            )
          ]
        )
      )
    );
  }
}