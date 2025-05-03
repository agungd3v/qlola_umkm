import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qlola_umkm/utils/global_function.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductItem extends StatefulWidget {
  dynamic product;
  int index;

  ProductItem({super.key, required this.product, required this.index});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.index > 0 ? const EdgeInsets.only(top: 14, bottom: 14) : const EdgeInsets.only(top: 14, bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              "${dotenv.env["ASSET_URL"]}/${widget.product["product_image"]}",
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
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product["product_name"],
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 18
                    )
                  ),
                  Text(
                    transformPrice(
                      double.parse(
                        widget.product["product_price"].toString(),
                      )
                    ),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      fontSize: 16
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}
