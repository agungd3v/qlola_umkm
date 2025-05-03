import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';

class SheetOutlet extends StatefulWidget {
  SheetOutlet({super.key});

  @override
  State<SheetOutlet> createState() => _SheetOutletState();
}

class _SheetOutletState extends State<SheetOutlet> {
  OwnerProvider? owner_provider;
  bool loading = false;

  List listOutlets = [
    {"label": "Semua Outlet", "value": null}
  ];
  Map<String, dynamic> selectedOutlet = {
    "label": "Semua Outlet",
    "value": null
  };

  Future _getOutlets() async {
    setState(() => loading = true);

    final httpRequest = await get_outlet();
    if (httpRequest["status"] == 200) {
      if (httpRequest["data"]!.isNotEmpty) {
        for (var index = 0; index < httpRequest["data"].length; index++) {
          setState(() {
            listOutlets.add({
              "label": httpRequest["data"][index]["outlet_name"],
              "value": httpRequest["data"][index]["id"]
            });
          });
        }
      }
    }

    setState(() => loading = false);
  }

  void _changeSelectedOutlet(Map<String, dynamic> param) {
    setState(() => selectedOutlet = param);
  }

  void _appyOutlet() {
    owner_provider!.set_report_outlet = selectedOutlet;

    return Navigator.pop(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      setState(() => selectedOutlet = owner_provider!.reportOutlet);
    });

    super.initState();
    _getOutlets();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("List Outlet",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 16)),
          const SizedBox(height: 12),
          if (!loading)
            for (var index = 0; index < listOutlets.length; index++)
              GestureDetector(
                  onTap: () {
                    _changeSelectedOutlet(listOutlets[index]);
                  },
                  child: Container(
                      width: double.infinity,
                      height: 38,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      margin: index > 0
                          ? EdgeInsets.only(top: 8)
                          : EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                          color: listOutlets[index]["value"] == selectedOutlet["value"]
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                              width: 1,
                              color: listOutlets[index]["value"] == selectedOutlet["value"]
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor)),
                      child: Text(listOutlets[index]["label"],
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: listOutlets[index]["value"] ==
                                      selectedOutlet["value"]
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color:
                                  listOutlets[index]["value"] == selectedOutlet["value"]
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).primaryColorDark,
                              fontSize: 12)))),
          if (loading)
            Text("Loading...",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 12)),
          const SizedBox(height: 20),
          Row(children: [
            GestureDetector(
                    onTap: () => _appyOutlet(),
                    child: Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save, // Ikon save
                                color: Colors.white,
                                size: 20, // Ukuran ikon
                              ),
                              const SizedBox(width: 8), // Memberikan jarak antara ikon dan teks
                              Text(
                                "Simpan",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ))),
            GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Center(
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor)))))
          ])
        ]);
  }
}
