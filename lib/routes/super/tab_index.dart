import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TabIndex extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  TabIndex({super.key,
    required this.navigationShell
  });

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
            top: BorderSide(width: 1, color: Theme.of(context).dividerColor)
          ),
          color: Colors.white
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).disabledColor,
          unselectedLabelStyle: GoogleFonts.roboto(fontSize: 12),
          selectedLabelStyle: GoogleFonts.roboto(fontSize: 12),
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) => goIndex(index),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 0 ?
                  Icon(Icons.home_work_rounded, size: 33) :
                  Icon(Icons.home_work_rounded, size: 33)
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 1 ?
                  Icon(Icons.archive, size: 33) :
                  Icon(Icons.archive_outlined, size: 33)
              ),
              label: 'Produk'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 2 ?
                  Icon(Icons.store, size: 33) :
                  Icon(Icons.store_outlined, size: 33)
              ),
              label: 'Outlet'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 3 ?
                  Icon(Icons.badge, size: 33) :
                  Icon(Icons.badge_outlined, size: 33)
              ),
              label: 'Pegawai'
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: currentIndex == 4 ?
                  Icon(Icons.person, size: 33) :
                  Icon(Icons.person_outline, size: 33)
              ),
              label: 'Saya'
            )
          ]
        )
      )
    );
  }
}