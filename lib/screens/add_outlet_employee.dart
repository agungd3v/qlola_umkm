import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qlola_umkm/api/request.dart';
import 'package:qlola_umkm/components/outlet/add_employee_dialog.dart';
import 'package:qlola_umkm/providers/owner_provider.dart';
import 'package:qlola_umkm/utils/flush_message.dart';

class AddOutletEmployeeScreen extends StatefulWidget {
  final dynamic outlet;

  AddOutletEmployeeScreen({super.key, required this.outlet});

  @override
  State<AddOutletEmployeeScreen> createState() => _AddOutletEmployeeScreenState();
}

class _AddOutletEmployeeScreenState extends State<AddOutletEmployeeScreen> {
  OwnerProvider? owner_provider;
  bool proccess = false;
  bool load = false;

  Future<void> _addEmployee() async {
    final Map<String, dynamic> data = {
      "outlet_id": widget.outlet["id"],
      "employees": owner_provider!.employees
    };

    setState(() => proccess = true);

    final httpRequest = await add_outlet_employees(data);
    if (httpRequest["status"] == 200) {
      Navigator.pop(context);
      successMessage(context, widget.outlet["outlet_name"], "Berhasil memperbarui karyawan pada ${widget.outlet["outlet_name"]}");

      return;
    }

    setState(() => proccess = false);

    errorMessage(context, widget.outlet["outlet_name"], httpRequest["message"]);
  }

  Future _showEmployee() async {
    setState(() => load = true);

    final httpRequest = await get_outlet_employees(widget.outlet["id"]);
    if (httpRequest["status"] == 200) {
      owner_provider!.init_employee = httpRequest["data"] as List;
    }

    setState(() => load = false);
  }

  void _showListEmployee() {
    showDialog(context: context, builder: (context) => AddEmployeeDialog());
  }

  @override
  void initState() {
    super.initState();
    _showEmployee();
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                            child: Image.asset(
                                "assets/icons/arrow_back_gray.png",
                                width: 16,
                                height: 16))),
                    const SizedBox(width: 6),
                    Text(
                      "Karyawan - ${widget.outlet["outlet_name"]}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.only(left: 15, bottom: 20),
                child: GestureDetector(
                  onTap: () => _showListEmployee(),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.35, // Set width as a percentage of screen width
                    height:
                        30, // You can adjust the height for better proportions
                    alignment: Alignment
                        .center, // Ensures the text is centered both vertically and horizontally
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Text(
                      "Tambah Karyawan",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 12, // Font size remains consistent
                      )
                    )
                  )
                )
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
              if (!load && (owner_provider!.employees).isNotEmpty) Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      for (var index = 0;
                          index < (owner_provider!.employees).length;
                          index++)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          owner_provider!.employees[index]
                                              ["name"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              fontSize: 12))),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      owner_provider!.remove_employee =
                                          owner_provider!.employees[index];
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
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
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
                        ),
                    ],
                  ),
                ),
              ),
              if (!load && (owner_provider!.employees).isEmpty) Expanded(child: Container(
                padding: const EdgeInsets.all(16),
                child: Text("Tidak ditemukan karyawan di outlet ini"),
              )),
              if (!proccess)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _addEmployee();
                    },
                    child: Container(
                      height: 40,
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
                          Icon(
                            Icons.save, // Ikon save
                            color: Colors.white,
                            size: 20, // Ukuran ikon
                          ),
                          const SizedBox(
                              width:
                                  8), // Memberikan jarak antara ikon dan teks
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
                    ),
                  ),
                ),
              if (proccess)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    height: 40,
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
                        Text(
                          "Proses Simpan...",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
