import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/notifiers/tab_notifer.dart';

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
    setState(() => tabIndex = index);
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
    tabChangeNotifier.value = index;
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
          unselectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 12),
          selectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 12),
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
                  Image.asset("assets/icons/home.png", width: 27, height: 27) :
                  Image.asset("assets/icons/home_outline.png", width: 27, height: 27)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 1 ?
                  Image.asset("assets/icons/order.png", width: 27, height: 27) :
                  Image.asset("assets/icons/order_outline.png", width: 27, height: 27)
              ),
              label: 'Order'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 2 ?
                  Image.asset("assets/icons/transaction.png", width: 27, height: 27) :
                  Image.asset("assets/icons/transaction_outline.png", width: 27, height: 27)
              ),
              label: 'Transaksi'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 3 ?
                  Image.asset("assets/icons/profile.png", width: 27, height: 27) :
                  Image.asset("assets/icons/profile_outline.png", width: 27, height: 27)
              ),
              label: 'Saya'
            )
          ]
        )
      )
    );
  }
}