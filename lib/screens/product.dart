import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/product/product_item.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/screens/add_product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  OwnerProvider? owner_provider;
  List products = [];

  Future _getProduct() async {
    final httpRequest = await get_product();
    if (httpRequest["status"] == 200) {
      setState(() {
        products = httpRequest["data"];
      });
    }
  }

  void _editProduct(dynamic data) {
    owner_provider!.set_product_edit = data;
    context.pushNamed("Owner Edit Product");
  }

  Future<void> _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    );

    // If result is true, refresh the employee list
    if (result == true) {
      _getProduct();
    }
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80), // Disesuaikan dengan height header
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Kelola Produk", // Menjaga konsistensi nama di seluruh aplikasi
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 22, // Ukuran font lebih kecil dan pas
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: products.isNotEmpty
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kelola Produk",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 20, // Ukuran font lebih kecil
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Kelola semua produk untuk katalog toko kamu di sini.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).disabledColor,
                        fontSize: 12, // Ukuran font yang lebih kecil
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                height: 8,
                color: Theme.of(context).dividerColor.withOpacity(0.3),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => RefreshIndicator(
                    color: Theme.of(context).indicatorColor,
                    onRefresh: () => Future.delayed(
                      const Duration(seconds: 1),
                      () => _getProduct(),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              if (products.isNotEmpty)
                                for (var index = 0;
                                    index < products.length;
                                    index++)
                                  GestureDetector(
                                    onTap: () => _editProduct(
                                      products[index],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 12, left: 16, right: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white, // White background
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ProductItem(
                                          product: products[index],
                                          index: index),
                                    ),
                                  ),
                              if (products.isEmpty)
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          "assets/icons/product_empty.png",
                                          width: 300,
                                          height: 200,
                                          fit: BoxFit.contain),
                                      Column(
                                        children: [
                                          const SizedBox(height: 12),
                                          Text(
                                            "Belum ada Produk",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: 320,
                                            child: Text(
                                              'Tekan "Icon Plus" untuk menambahkan produk kamu ke dalam inventory',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: _navigateToAddProduct, // Navigate to add employee page

              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(99),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).disabledColor,
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(1, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/plus_white.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
