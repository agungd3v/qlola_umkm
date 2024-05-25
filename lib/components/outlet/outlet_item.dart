import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OutletItem extends StatefulWidget {
  dynamic outlet;
  int index;

  OutletItem({super.key,
    required this.outlet,
    required this.index
  });

  @override
  State<OutletItem> createState() => _OutletItemState();
}

class _OutletItemState extends State<OutletItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: widget.index > 0 ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(top: 0),
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
                    widget.outlet["outlet_phone"],
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 12
                    )
                  ),
                  Text(
                    widget.outlet["outlet_name"],
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
                            extra: widget.outlet
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
                        onTap: () {
                          context.pushNamed(
                            "Add Outlet Product",
                            extra: widget.outlet
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
    );
  }
}