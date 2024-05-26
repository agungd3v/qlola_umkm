import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/product/product_item.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];

  Future _getProduct() async {
    final httpRequest = await get_product();
    if (httpRequest["status"] == 200) {
      setState(() {
        products = httpRequest["data"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark
          )
        )
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: products.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
                    ))
                  ]
                )
              ),
              Container(
                height: 10,
                color: Theme.of(context).dividerColor.withOpacity(0.5),
              ),
              Expanded(child: LayoutBuilder(builder: (context, constraints) => RefreshIndicator(
                color: Theme.of(context).indicatorColor,
                onRefresh: () => Future.delayed(Duration(seconds: 1), () => _getProduct()),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          if (products.isNotEmpty) for (var index = 0; index < products.length; index++) ProductItem(
                            product: products[index],
                            index: index
                          ),
                          if (products.isEmpty) Expanded(child: Column(
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
                                      'Tekan "Icon Plus" untuk menambahkan produk kamu ke dalam inventory',
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
                          )),
                          const SizedBox(height: 16)
                        ]
                      )
                    )
                  )
                )
              )))
            ]
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => context.pushNamed("Add Product"),
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
    );
  }
}