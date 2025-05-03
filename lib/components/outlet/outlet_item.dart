import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qlola_umkm/utils/flush_message.dart';

class OutletItem extends StatefulWidget {
  final dynamic outlet;
  final int index;

  OutletItem({super.key, required this.outlet, required this.index});

  @override
  State<OutletItem> createState() => _OutletItemState();
}

class _OutletItemState extends State<OutletItem> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Handle tap if needed
      },
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Container
                Container(
                  width: screenWidth * 0.19,
                  height: screenHeight * 0.09,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Center(
                    child: Icon(Icons.store, size: 33, color: Theme.of(context).primaryColorDark)
                  )
                ),
                SizedBox(width: screenWidth * 0.03),
                // Main Content (Text)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Outlet Phone
                      Text(
                        widget.outlet["outlet_phone"],
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      // Outlet Name
                      Text(
                        widget.outlet["outlet_name"],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18,
                        ),
                      )
                    ]
                  )
                )
              ]
            ),
            SizedBox(height: 10),
            Row(children: [
              Expanded(child: _buildActionButton(
                label: "Tambah Produk",
                onPressed: () {
                  context.pushNamed("Owner Add Outlet Product", extra: widget.outlet);
                },
                icon: Icons.production_quantity_limits,
                isFullWidth: true,
                backgroundColor: Color(0xFFF5A623),
              )),
              SizedBox(width: screenWidth * 0.020),
              Expanded(child: _buildActionButton(
                label: "Tambah Karyawan",
                onPressed: () {
                  context.pushNamed("Owner Add Outlet Employee", extra: widget.outlet);
                },
                icon: Icons.person_add_alt_1,
                isFullWidth: false,
                backgroundColor: Color(0xFF3AA0F3),
              )),
              SizedBox(width: screenWidth * 0.020),
              Expanded(child: _buildActionButton(
                label: "Tambah Mitra",
                onPressed: () {
                  // context.pushNamed("Owner Add Mitra", extra: widget.outlet);
                  successMessage(context, "Kelola Outlet", "Sedang tahap development");
                },
                icon: Icons.group_add,
                backgroundColor: Theme.of(context).disabledColor,
                isFullWidth: true,
              ))
            ])
          ]
        )
      )
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
    required bool isFullWidth,
    required Color backgroundColor,
  }) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPressed,
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.5),
        highlightColor: backgroundColor.withOpacity(0.2),
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.05,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 5),
                Expanded(child: AutoSizeText(
                  label,
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 10,
                    height: 1
                  ),
                ))
              ]
            )
          )
        ),
      ),
    );
  }
}
