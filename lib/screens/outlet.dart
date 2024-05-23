import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/api/request.dart';

class OutletScreen extends StatefulWidget {
  const OutletScreen({super.key});

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  List<dynamic> outlets = [];

  Future<void> _getProduct() async {
    final httpRequest = await get_outlet();
    inspect(httpRequest);
    if (httpRequest["status"] == 200) {
      setState(() {
        outlets = httpRequest["data"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

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
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
          )
        )
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kelola Outlet",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColorDark
                            )
                          ),
                          Text(
                            "Kelola semua outlet kamu di sini.",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Theme.of(context).disabledColor,
                              fontSize: 11
                            )
                          )
                        ]
                      ))
                    ]
                  )
                ),
                Container(
                  height: 10,
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                ),
                if (outlets.isEmpty) Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/icons/outlet_empty.png", width: 400, height: 200, fit: BoxFit.contain),
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              "Belum ada Outlet",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColorDark
                              )
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 320,
                              child: Text(
                                'Tekan "Icon Plus" untuk menambahkan outlet kamu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 12
                                )
                              )
                            )
                          ]
                        )
                      ]
                    )
                  )
                ),
                if (outlets.isNotEmpty) SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        for (var index = 0; index < outlets.length; index++) GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: index > 0 ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(top: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Center(
                                    child: Image.asset("assets/icons/outlet.png", width: 25, height: 25)
                                  )
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        outlets[index]["outlet_phone"],
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12
                                        )
                                      ),
                                      Text(
                                        outlets[index]["outlet_name"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColorDark
                                        )
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pushNamed(
                                                "Add Outlet Employee",
                                                extra: outlets[index]
                                              );
                                            },
                                            child: Container(
                                              height: 24,
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.all(Radius.circular(6))
                                              ),
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.hardEdge,
                                              child: Text(
                                                "Tambah Karyawan",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 10
                                                )
                                              )
                                            )
                                          ),
                                          const SizedBox(width: 6),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              height: 24,
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: BorderRadius.all(Radius.circular(6))
                                              ),
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.hardEdge,
                                              child: Text(
                                                "Tambah Produk",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 10
                                                )
                                              )
                                            )
                                          )
                                        ]
                                      )
                                    ]
                                  )
                                ))
                              ]
                            )
                          )
                        ),
                        const SizedBox(height: 16)
                      ]
                    )
                  )
                )
              ]
            )
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => context.pushNamed("Add Outlet"),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(99)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).disabledColor,
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(1, 2)
                    )
                  ]
                ),
                child: Center(
                  child: Image.asset("assets/icons/plus_white.png", width: 25, height: 25)
                )
              )
            )
          )
        ]
      )
    );
  }
}