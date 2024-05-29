import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/components/report/sheet_date.dart';
import 'package:qlola_umkm/components/report/sheet_outlet.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  OwnerProvider? owner_provider;

  void _showSelectDate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => SheetDate()
    );
  }

  void _showSelectOutlet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        content: SheetOutlet()
      )
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      owner_provider!.reset();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    owner_provider = Provider.of<OwnerProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light
          ),
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              border: Border(
                bottom: BorderSide(width: 1, color: Theme.of(context).primaryColor)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset("assets/icons/arrow_back_white.png", width: 16, height: 16)
                  )
                ),
                Text(
                  "Laporan Penjualan",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                  )
                ),
              ]
            )
          ),
          GestureDetector(
            onTap: () => _showSelectOutlet(),
            child: Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset("assets/icons/outlet.png", width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(
                    owner_provider!.reportOutlet["label"].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12
                    )
                  ),
                  const SizedBox(width: 15)
                ]
              )
            )
          ),
          GestureDetector(
            onTap: () => _showSelectDate(),
            child: Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset("assets/icons/calendar.png", width: 20, height: 20),
                  const SizedBox(width: 10),
                  Text(
                    owner_provider!.reportDate["label"].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 12
                    )
                  ),
                  const SizedBox(width: 15)
                ]
              )
            )
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 100,
              height: 35,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child:Text(
                "Terapkan",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 12
                )
              )
            )
          )
        ]
      )
    );
  }
}