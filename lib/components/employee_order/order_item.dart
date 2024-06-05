import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qlola_umkm/components/employee_product_sheet.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:sizer/sizer.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openSheetProduct(widget.item);
      },
        child: Container(
        margin: widget.index > 0 ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                "${dotenv.env["ASSET_URL"]}${widget.item["product_image"]}",
                width: 18.w,
                height: 18.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 18.w,
                    height: 18.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2)
                    ),
                    child: Center(
                      child: Image.asset("assets/icons/image_crash.png", width: 25, height: 25)
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
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 3.5.w
                    )
                  ),
                  Text(
                    transformPrice(double.parse(widget.item["product_price"])),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 3.w
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