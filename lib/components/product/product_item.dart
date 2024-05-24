import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class ProductItem extends StatefulWidget {
  dynamic product;
  int index;

  ProductItem({super.key,
    required this.product,
    required this.index
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.index > 0 ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(top: 0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              "${dotenv.env["ASSET_URL"]}${widget.product["product_image"]}",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2)
                  ),
                  child: Center(
                    child: Image.asset("assets/icons/image_crash.png", width: 25, height: 25)
                  )
                );
              },
            )
          ),
          const SizedBox(width: 12),
          Expanded(child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product["product_name"],
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark
                  )
                ),
                Text(
                  transformPrice(double.parse(widget.product["product_price"])),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor
                  )
                )
              ]
            )
          ))
        ]
      )
    );
  }
}