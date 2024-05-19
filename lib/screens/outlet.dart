import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OutletScreen extends StatefulWidget {
  const OutletScreen({super.key});

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                  Expanded(
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
                                  'Pilih "Icon Plus" untuk menambahkan outlet kamu',
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
      )
    );
  }
}