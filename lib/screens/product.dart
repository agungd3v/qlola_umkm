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
  Future<List> _getProduct() async {
    final httpRequest = await get_product();
    if (httpRequest["status"] == 200) {
      return httpRequest["data"] as List;
    }

    return List.empty();
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
          Container(
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
                      ))
                    ]
                  )
                ),
                Container(
                  height: 10,
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                ),
                FutureBuilder(
                  future: _getProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.all(16),
                        child: Text("Waiting connection...")
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Expanded(
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
                          )
                        )
                      );
                    }
                    if (snapshot.data!.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              for (var index = 0; index < snapshot.data!.length; index++) ProductItem(
                                product: snapshot.data![index],
                                index: index
                              ),
                              const SizedBox(height: 16)
                            ]
                          )
                        )
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.all(16),
                      child: Text("Error connection...")
                    );
                  }
                )
              ]
            )
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