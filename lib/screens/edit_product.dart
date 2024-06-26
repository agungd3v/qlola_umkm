import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:sizer/sizer.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  OwnerProvider? owner_provider;
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  bool proccess = false;

  Future<void> _addproduct() async {
    final Map<String, dynamic> data = {
      "id": owner_provider!.productEdit["id"].toString(),
      "product_name": productName.text,
      "product_price": productPrice.text
    };

    setState(() => proccess = true);

    final httpRequest = await update_product(data);
    if (httpRequest["status"] == 200) {
      Navigator.pop(context);

      return successMessage(context, "Informasi", "Berhasil memperbarui produk baru");
    }

    setState(() => proccess = false);
    errorMessage(context, "Informasi", httpRequest["message"]);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        productName.text = owner_provider!.productEdit["product_name"];
        productPrice.text = owner_provider!.productEdit["product_price"].toString();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Theme.of(context).dividerColor)
                  )
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Image.asset("assets/icons/arrow_back_gray.png", width: 4.5.w, height: 4.5.w)
                      )
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Edit Produk",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 3.6.w
                      )
                    )
                  ]
                )
              ),
              Expanded(child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "Nama produk",
                                hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 3.w
                                )
                              ),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 3.w
                              ),
                              cursorColor: Theme.of(context).focusColor,
                              controller: productName,
                            )
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "Harga jual",
                                hintStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 3.w
                                )
                              ),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 3.w
                              ),
                              keyboardType: TextInputType.number,
                              cursorColor: Theme.of(context).focusColor,
                              controller: productPrice,
                            )
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 10,
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 20)
                  ]
                )
              )),
              if (!proccess) Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _addproduct();
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))
                    ),
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white
                      )
                    )
                  )
                )
              ),
              if (proccess) Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Proses Simpan...",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                        )
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