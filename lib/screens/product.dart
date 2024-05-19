import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                          "Kelola Produk",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark
                          )
                        ),
                        Text(
                          "Kelola semua produk untuk katalog toko kamu di sini.",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Theme.of(context).disabledColor,
                            fontSize: 11
                          )
                        )
                      ]
                    )),
                    GestureDetector(
                      onTap: () => debugPrint("create new product"),
                      child: Image.asset("assets/icons/add_new.png", width: 30, height: 30)
                    )
                  ]
                )
              ),
              Container(
                height: 4,
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/product_empty.png", width: 300, height: 200, fit: BoxFit.contain),
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            "Belum ada Produk",
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
                              'Pilih "Icon Plus" untuk menambahkan produk kamu ke dalam inventory',
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
        )
      )
    );
  }
}