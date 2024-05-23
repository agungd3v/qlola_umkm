import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/button_checkout.dart';
import 'package:qlola_umkm/components/employee_product_sheet.dart';
import 'package:qlola_umkm/providers/checkout_provider.dart';
import 'package:qlola_umkm/utils/global_function.dart';

class EmployeeOrderScreen extends StatefulWidget {
  const EmployeeOrderScreen({super.key});

  @override
  State<EmployeeOrderScreen> createState() => _EmployeeOrderScreenState();
}

class _EmployeeOrderScreenState extends State<EmployeeOrderScreen> {
  CheckoutProvider? checkout_provider;
  List<dynamic> products = [];

  Future<void> _getProduct() async {
    final httpRequest = await get_outlet_product();
    if (httpRequest["status"] == 200) {
      setState(() {
        products = httpRequest["data"];
      });
    }
  }

  void _openSheetProduct(dynamic data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => EmployeeProductSheet(product: data)
    );
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    checkout_provider = Provider.of<CheckoutProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          )
        )
      ),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            if (checkout_provider!.carts.isNotEmpty) Positioned(
              bottom: 12,
              left: MediaQuery.of(context).size.width / 3,
              child: ButtonCheckout()
            ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    for (var index = 0; index < products.length; index++) GestureDetector(
                      onTap: () {
                        _openSheetProduct(products[index]);
                      },
                        child: Container(
                        margin: index > 0 ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(top: 0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                "${dotenv.env["ASSET_URL"]}${products[index]["product_image"]}",
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
                                }
                              )
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index]["product_name"],
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).primaryColorDark
                                    )
                                  ),
                                  Text(
                                    transformPrice(double.parse(products[index]["product_price"])),
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
                      )
                    ),
                    const SizedBox(height: 16)
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}