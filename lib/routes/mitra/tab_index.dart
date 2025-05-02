import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabIndex extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  TabIndex({super.key, required this.navigationShell});

  @override
  State<TabIndex> createState() => _TabIndexState();
}

class _TabIndexState extends State<TabIndex> {
  void goIndex(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Theme.of(context).dividerColor
            )
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
          currentIndex: currentIndex,
          onTap: (index) => goIndex(index),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 0 ?
                  Image.asset("assets/icons/home.png", width: 27, height: 27) :
                  Image.asset("assets/icons/home_outline.png", width: 27, height: 27)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 1 ?
                  Image.asset("assets/icons/transaction.png", width: 27, height: 27) :
                  Image.asset("assets/icons/transaction_outline.png", width: 27, height: 27)
              ),
              label: 'Transaksi'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 2 ?
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
