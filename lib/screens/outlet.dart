import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/outlet/outlet_item.dart';
import 'package:qlola_umkm/screens/add_outlet.dart';
import 'package:google_fonts/google_fonts.dart';

class OutletScreen extends StatefulWidget {
  const OutletScreen({super.key});

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  List outlets = [];
  bool loading = true;

  void _getOutlet() async {
    setState(() {
      loading = true;
    });

    final httpRequest = await get_outlet();
    if (httpRequest["status"] == 200) {
      setState(() {
        outlets = httpRequest["data"];
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _navigateToAddOutlet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOutletScreen()),
    );

    if (result == true) {
      _getOutlet();
    }
  }

  @override
  void initState() {
    super.initState();
    _getOutlet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), // Adjust height as needed
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            "Outlet",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorDark,
              fontSize: 20
            )
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor,
            statusBarIconBrightness: Brightness.light,
          )
        )
      ),
      body: Stack(children: [
        Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kelola Outlet",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  Text(
                    "Kelola semua data outlet kamu di sini.",
                    style: GoogleFonts.roboto(
                      color: Theme.of(context).disabledColor,
                      fontSize: 14,
                    )
                  )
                ]
              )
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
                  onRefresh: () => Future.delayed(const Duration(seconds: 1), () => _getOutlet()),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: loading ? Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
                      )
                    ) : outlets.isEmpty ? _emptyData(constraints) : _notEmptyData(constraints)
                  )
                )
              )
            )
          ]
        ),
        // Positioned Button
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: _navigateToAddOutlet, // Navigate to add outlet page
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(
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
                child: Icon(Icons.add, color: Colors.white, size: 32)
              )
            )
          )
        )
      ])
    );
  }

  Widget _notEmptyData(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 16),
            for (var index = 0; index < outlets.length; index++) OutletItem(outlet: outlets[index], index: index),
            const SizedBox(height: 16)
          ]
        )
      )
    );
  }

  Widget _emptyData(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Expanded(child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/outlet_empty.png",
                    width: 320,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Belum ada Outlet",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).primaryColorDark,
                    )
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 320,
                    child: Text(
                      'Tekan "Icon Plus" untuk menambahkan outlet baru kamu',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 14,
                      )
                    )
                  )
                ]
              )
            ))
          ]
        )
      )
    );
  }
}
