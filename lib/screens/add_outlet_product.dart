import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/outlet/add_product_dialog.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class AddOutletProductScreen extends StatefulWidget {
  dynamic outlet;

  AddOutletProductScreen({super.key, required this.outlet});

  @override
  State<AddOutletProductScreen> createState() => _AddOutletProductScreenState();
}

class _AddOutletProductScreenState extends State<AddOutletProductScreen> {
  OwnerProvider? owner_provider;
  bool proccess = false;
  bool load = false;

  Future<void> _addEmployee() async {
    final Map<String, dynamic> data = {
      "outlet_id": widget.outlet["id"],
      "products": owner_provider!.products
    };

    setState(() => proccess = true);

    final httpRequest = await add_outlet_products(data);
    if (httpRequest["status"] == 200) {
      Navigator.pop(context);
      successMessage(context, widget.outlet["outlet_name"], "Berhasil memperbarui produk pada ${widget.outlet["outlet_name"]}");

      return;
    }

    setState(() => proccess = false);

    errorMessage(context, widget.outlet["outlet_name"], httpRequest["message"]);
  }

  Future _showProduct() async {
    setState(() => load = true);

    final httpRequest = await get_outlet_products(widget.outlet["id"]);
    if (httpRequest["status"] == 200) {
      owner_provider!.init_product = httpRequest["data"] as List;
    }

    setState(() => load = false);
  }

  void _showListProduct() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(outlet: widget.outlet),
    );
  }

  @override
  void initState() {
    super.initState();
    _showProduct();
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      owner_provider!.reset();
    });
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
              statusBarIconBrightness: Brightness.dark),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 1, color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset("assets/icons/arrow_back_gray.png",
                          width: 16, height: 16),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Produk - ${widget.outlet["outlet_name"]}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 4.w),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(left: 15, bottom: 20),
              child: GestureDetector(
                onTap: () => _showListProduct(),
                child: Container(
                  width: 140, // Set width as a percentage of screen width
                  height:
                      38, // You can adjust the height for better proportions
                  alignment: Alignment
                      .center, // Ensures the text is centered both vertically and horizontally
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Text(
                    "Tambah Produk",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14, // Font size remains consistent
                    ),
                  ),
                ),
              ),
            ),
            if (load) Expanded(child: Container(
              padding: const EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  )
                ]
              )
            )),
            if (!load && (owner_provider!.products).isNotEmpty) Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    for (var index = 0;
                        index < owner_provider!.products.length;
                        index++)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        margin: const EdgeInsets.only(bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    owner_provider!.products[index]
                                        ["product_name"],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    owner_provider!.remove_product =
                                        owner_provider!.products[index];
                                  },
                                  child: Container(
                                    height: 27,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      "Hapus",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Theme.of(context)
                                  .dividerColor, // Customize the color here
                              thickness: 1, // Set thickness of the underline
                              height:
                                  20, // Set the space between the content and the underline
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            if (!load && (owner_provider!.products).isEmpty) Expanded(child: Container(
              padding: const EdgeInsets.all(16),
              child: Text("Tidak ditemukan produk di outlet ini"),
            )),
            if (!proccess)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                margin: const EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _addEmployee();
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      "Simpan",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (proccess)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 5),
                      Text("Proses Simpan...",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              color: Colors.white))
                    ],
                  ),
                ),
              ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
