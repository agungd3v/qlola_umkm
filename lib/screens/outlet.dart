import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/outlet/outlet_item.dart';
import 'package:qlola_umkm/screens/add_outlet.dart';

class OutletScreen extends StatefulWidget {
  final String title;
  final String buttonText;

  const OutletScreen({
    super.key,
    this.title = 'Kelola Outlet',
    this.buttonText = 'Tambah Outlet',
  });

  @override
  State<OutletScreen> createState() => _OutletScreenState();
}

class _OutletScreenState extends State<OutletScreen> {
  List outlets = [];
  bool isLoading = true;

  void _getOutlet() async {
    final httpRequest = await get_outlet();
    if (httpRequest["status"] == 200) {
      setState(() {
        outlets = httpRequest["data"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
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
        preferredSize: const Size.fromHeight(80),
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
              widget.title,
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                fontSize: 22, // Ukuran font judul yang lebih kecil
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: outlets.isNotEmpty
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Body header text
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 20, // Ukuran font lebih kecil
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Kelola semua data outlet kamu di sini.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).disabledColor,
                        fontSize:
                            12, // Ukuran font yang lebih kecil untuk deskripsi
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
                        const Duration(seconds: 1), () => _getOutlet()),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              if (!isLoading && outlets.isNotEmpty)
                                for (var index = 0;
                                    index < outlets.length;
                                    index++)
                                  OutletItem(
                                      outlet: outlets[index], index: index),
                              if (!isLoading && outlets.isEmpty)
                                Expanded(
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
                                        "Belum ada ${widget.buttonText.split(' ').last}",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: 280,
                                        child: Text(
                                          'Tekan tombol di bawah untuk menambahkan ${widget.buttonText.split(' ').last.toLowerCase()} kamu',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 100),
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
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
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
