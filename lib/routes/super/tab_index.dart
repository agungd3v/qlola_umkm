import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

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
          unselectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 2.5.w),
          selectedLabelStyle: TextStyle(fontFamily: "Poppins", fontSize: 2.5.w),
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
                  Image.asset("assets/icons/home.png", width: 6.w, height: 6.w) :
                  Image.asset("assets/icons/home_outline.png", width: 6.w, height: 6.w)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 1 ?
                  Image.asset("assets/icons/product.png", width: 6.w, height: 6.w) :
                  Image.asset("assets/icons/product_outline.png", width: 6.w, height: 6.w)
              ),
              label: 'Produk'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 2 ?
                  Image.asset("assets/icons/outlet.png", width: 6.w, height: 6.w) :
                  Image.asset("assets/icons/outlet_outline.png", width: 6.w, height: 6.w)
              ),
              label: 'Outlet'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 3 ?
                  Image.asset("assets/icons/employee.png", width: 6.w, height: 6.w) :
                  Image.asset("assets/icons/employee_outline.png", width: 6.w, height: 6.w)
              ),
              label: 'Pegawai'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: tabIndex == 4 ?
                  Image.asset("assets/icons/profile.png", width: 6.w, height: 6.w) :
                  Image.asset("assets/icons/profile_outline.png", width: 6.w, height: 6.w)
              ),
              label: 'Saya'
            )
          ]
        )
      )
    );
  }
}