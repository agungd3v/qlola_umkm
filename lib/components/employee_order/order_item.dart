import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qlola_umkm/components/employee_product_sheet.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderItem extends StatefulWidget {
  dynamic item;
  int index;

  OrderItem({super.key,
    required this.item,
    required this.index
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  void _openSheetProduct(dynamic data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => EmployeeProductSheet(product: data)
    );
  }

  Future _addProductToCart(dynamic data) async {
    debugPrint(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // getDeviceType() == "tablet" ? _addProductToCart(widget.item) : _openSheetProduct(widget.item);
        _openSheetProduct(widget.item);
      },
      child: Container(
        color: Colors.transparent,
        margin: widget.index > 0 ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                "${dotenv.env["ASSET_URL"]}/${widget.item["product_image"]}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2)
                    ),
                    child: Center(
                      child: Icon(Icons.photo_size_select_actual, color: Theme.of(context).primaryColorDark)
                    )
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2)
                    ),
                    child: Center(
                      child: Icon(Icons.photo_size_select_actual, color: Theme.of(context).primaryColorDark)
                    )
                  );
                }
              )
            ),
            const SizedBox(width: 12),
            Expanded(child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item["product_name"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18
                    )
                  ),
                  Text(
                    transformPrice(double.parse(widget.item["product_price"].toString())),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 14
                    )
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