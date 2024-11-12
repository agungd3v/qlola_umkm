import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OutletItem extends StatefulWidget {
  dynamic outlet;
  int index;

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
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white, // White background
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // How much the shadow spreads
              blurRadius: 8, // How blurry the shadow is
              offset: Offset(0, 3), // Shadow position (x, y)
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Icon container
            Container(
              width: screenWidth * 0.19, // Adjust width based on screen width
              height:
                  screenHeight * 0.10, // Adjust height based on screen height
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Image.asset(
                  "assets/icons/outlet.png",
                  width: screenWidth * 0.08,
                  height: screenHeight * 0.04,
                ), // Adjust icon size based on screen size
              ),
            ),
            SizedBox(
                width:
                    screenWidth * 0.03), // Adjust space between image and text

            // Text and Buttons container
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone number
                  Text(
                    widget.outlet["outlet_phone"],
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: screenWidth * 0.03, // Responsive font size
                    ),
                  ),
                  // Outlet name
                  Text(
                    widget.outlet["outlet_name"],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: screenWidth * 0.04, // Responsive font size
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.01), // Adjust vertical spacing between elements

                  // Action buttons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushNamed("Add Outlet Employee",
                              extra: widget.outlet);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.35, // Set width as a percentage of screen width
                          height: screenHeight *
                              0.04, // Adjust button height based on screen height
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth *
                                  0.02), // Adjust button padding based on screen width
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Tambah Karyawan",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: screenWidth *
                                  0.03, // Responsive font size for button text
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: screenWidth * 0.03), // Space between buttons
                      GestureDetector(
                        onTap: () {
                          context.pushNamed("Add Outlet Product",
                              extra: widget.outlet);
                        },
                        child: Container(
                          height: screenHeight *
                              0.04, // Adjust button height based on screen height
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth *
                                  0.02), // Adjust button padding based on screen width
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Tambah Produk",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: screenWidth *
                                  0.03, // Responsive font size for button text
                            ),
                          ),
                        ),
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
}
