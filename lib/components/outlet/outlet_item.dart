import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        child: Row(
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
                child: Image.asset(
                  "assets/icons/outlet.png",
                  width: screenWidth * 0.08,
                  height: screenHeight * 0.08,
                ),
              ),
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
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  // Outlet Name
                  Text(
                    widget.outlet["outlet_name"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: screenWidth * 0.040,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  // Full Width Button for "Tambah Produk" and 2-column layout for others
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Width Button for "Tambah Produk"
                      _buildActionButton(
                        label: "Tambah Produk",
                        onPressed: () {
                          context.pushNamed("Owner Add Outlet Product",
                              extra: widget.outlet);
                        },
                        icon: Icons.production_quantity_limits,
                        isFullWidth: true,
                        backgroundColor: Colors.red[800]!,
                      ),
                      SizedBox(height: screenHeight * 0.009),
                      // 2 Column Layout for "Tambah Karyawan" and "Tambah Mitra"
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              label: "Tambah Karyawan",
                              onPressed: () {
                                context.pushNamed("Owner Add Outlet Employee",
                                    extra: widget.outlet);
                              },
                              icon: Icons.person_add_alt_1,
                              isFullWidth: false,
                              backgroundColor: Colors.blue[800]!,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.020),
                          Expanded(
                            child: _buildActionButton(
                              label: "Tambah Mitra",
                              onPressed: () {
                                context.pushNamed("Owner Add Mitra",
                                    extra: widget.outlet);
                              },
                              icon: Icons.group_add,
                              backgroundColor: Colors.green[800]!,
                              isFullWidth: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
    required bool isFullWidth,
    required Color backgroundColor,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPressed,
      child: InkWell(
        splashColor: Colors.white.withOpacity(0.5),
        highlightColor: backgroundColor.withOpacity(0.2),
        child: Container(
          width: isFullWidth ? screenWidth : screenWidth * 0.35,
          height: screenHeight * 0.04,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: screenWidth * 0.03,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: screenWidth * 0.023,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
